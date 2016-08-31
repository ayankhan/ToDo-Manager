//
//  ToDoListTableViewController.m
//  ToDoList
//
//  Created by Ayan Khan on 31/08/16.
//  Copyright © 2016 Ayan Khan. All rights reserved.
//

#import "ToDoListTableViewController.h"
#import "SingletonClass.h"
#import "DatabaseOperation.h"

@interface ToDoListTableViewController ()<UITextFieldDelegate>
{
    
    UISegmentedControl *segmentedControl;
    BOOL isfiltering;
    
}

/*....Done Button....*/

@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButtoAaddToDo;

/*....Add Button Alert to enable....*/

@property(nonatomic, strong)UIAlertAction *addAction;

/*....Create Database Operation Obect....*/

@property(nonatomic, strong)DatabaseOperation *mDB;


/*....TODO's Values Array....*/

@property(nonatomic, strong)NSMutableArray *arrayTODOs;

/*....TODO's Values Array....*/

@property(nonatomic, strong)NSMutableArray *arrayFiltered;


/*....Add Button Action....*/

- (IBAction)action_addToDo:(id)sender;

/*....Logout Button Action....*/

- (IBAction)action_logout:(id)sender;

@end

@implementation ToDoListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView setTintColor:[UIColor lightGrayColor]];
    
    /*....Add Segment To Navigation....*/
    segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"All",@"Pending",@"Done"]];
    segmentedControl.frame = CGRectMake(0 , 0, 180, 29);
    [segmentedControl addTarget:self action:@selector(action_filterToDo:) forControlEvents: UIControlEventValueChanged];
    [self.navigationItem setTitleView:segmentedControl];
    
    /*....Remove Empty Rows....*/
    [self.tableView setTableFooterView:[UIView new]];

    /*....Initialize Database Operation....*/
    _mDB = [[DatabaseOperation alloc] init];
    
    /*....Initialize TODOs Arrays....*/
    _arrayTODOs=[NSMutableArray new];

    
    /*....Listen for new comments in the Firebase database....*/
    [[[SingletonClass sharedInstance] appdelegate] showLoadingAnimation];
    
    [[[SingletonClass sharedInstance] dbRef]
     observeEventType:FIRDataEventTypeValue
     withBlock:^(FIRDataSnapshot *snapshot) {
         
         segmentedControl.selectedSegmentIndex=0;
         isfiltering=false;
         [_arrayFiltered removeAllObjects];
         
         /*....Empty Array....*/
         if (_arrayTODOs.count) {
             [_arrayTODOs removeAllObjects];
         }
         
         /*....Seperate Keys & Values....*/

         NSDictionary *dictAllTODOs=[[[snapshot.value valueForKey:@"users"] valueForKey:[[SingletonClass sharedInstance]userID]] valueForKey:@"Todo's"];
         
         /*....Check Records....*/

         if ([dictAllTODOs isKindOfClass:[NSDictionary class]]) {
             
             [dictAllTODOs enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                 
                 /*....Change Structure to Array for Tableview....*/
                 
                 NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:obj];
                 [dict setObject:key forKey:@"id"];
                 [_arrayTODOs addObject:dict];
                 
             }];
             /*....Sort Array....*/
             
             NSSortDescriptor* brandDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
             _arrayTODOs=[[_arrayTODOs sortedArrayUsingDescriptors:@[brandDescriptor]] mutableCopy];
             
             
             [self.tableView reloadData];
             

         }
         
         [[[SingletonClass sharedInstance] appdelegate] hideLoadingAnimation];

         
     }];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Segment Action

-(void)action_filterToDo:(UISegmentedControl*)sender{
    
    
    NSPredicate *predicate;
    
    isfiltering=true;
    
    /*....Check Filter....*/

    if (sender.selectedSegmentIndex==0){//All
        
        isfiltering=false;
        
    }
    else if (sender.selectedSegmentIndex==1) {//Pending
        
        predicate  = [NSPredicate predicateWithFormat:@"status contains[c] %@",@"PENDING"];
        
        /*....Filter Array With Status Pending....*/
        
        _arrayFiltered = [[_arrayTODOs filteredArrayUsingPredicate:predicate] mutableCopy];

    }
    else{//Done
        
        predicate  = [NSPredicate predicateWithFormat:@"status contains[c] %@",@"DONE"];
        
        /*....Filter Array With Status Done....*/
        
        _arrayFiltered = [[_arrayTODOs filteredArrayUsingPredicate:predicate] mutableCopy];

        
    }
    
    
    [self.tableView reloadData];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return isfiltering?_arrayFiltered.count: _arrayTODOs.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID" forIndexPath:indexPath];
    
    // Configure the cell...
    NSDictionary *dictTODO=nil;
    
    /*....Check for Filter....*/
    if (isfiltering) {
        
        dictTODO=[_arrayFiltered objectAtIndex:indexPath.row];
        
    }
    else{
        
        dictTODO=[_arrayTODOs objectAtIndex:indexPath.row];

    }
    
    cell.textLabel.text=[dictTODO valueForKey:@"title"];
    
    /*....Configure According to TODO Status....*/
    
    if ([[dictTODO valueForKey:@"status"]isEqualToString:@"PENDING"]) {//Pending
        
        cell.textLabel.textColor=[UIColor blackColor];
        cell.detailTextLabel.text=@"Pending";
        cell.detailTextLabel.textColor=[UIColor redColor];
        cell.selectionStyle=UITableViewCellSelectionStyleGray;
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        
    }
    else{//Done
        
        cell.detailTextLabel.text=@"Done";
        cell.detailTextLabel.textColor=[UIColor lightGrayColor];

        cell.textLabel.textColor=[UIColor lightGrayColor];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    NSDictionary *dictTODO=nil;
    
    /*....Check for Filter....*/
    if (isfiltering) {
        
        dictTODO=[_arrayFiltered objectAtIndex:indexPath.row];
        
    }
    else{
        
        dictTODO=[_arrayTODOs objectAtIndex:indexPath.row];
        
    }
    
    /*....Check for Pending TODO....*/
    
    if ([[dictTODO valueForKey:@"status"]isEqualToString:@"PENDING"]) {
        
        /*....Create AlertController with To Update TODO....*/
        
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"ToDo" message:@"Update this TODO as Done." preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"Update" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            /*....Update TODO to Database....*/
            [_mDB updatePendingToDo:^(id object) {
                NSLog(@"Successfully Updated");
            } onError:^(NSError *error) {
                [self showAlertViewWithError:error];
            } havingToDoID:[[_arrayTODOs objectAtIndex:indexPath.row] valueForKey:@"id"] andTitle:[[_arrayTODOs objectAtIndex:indexPath.row] valueForKey:@"title"]];
            
            [alert dismissViewControllerAnimated:YES completion:nil];
        }]];
        
        [self presentViewController:alert animated:YES completion:nil];

    }
    
}
#pragma mark - UITexfield Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString *finalString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    [self.addAction setEnabled:(finalString.length >= 3)];
    return YES;
}

#pragma mark - Add Todo

- (IBAction)action_addToDo:(id)sender {
    
    /*....Create AlertController with Textfield....*/
    
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"ToDo" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder=@"Enter Title";
        textField.delegate = self;

    }];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    _addAction=[UIAlertAction actionWithTitle:@"Add" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        /*....Get Textfield of Alert....*/
        UITextField *textField=[[alert textFields]firstObject];
        
        /*....Save TODO to Database....*/

        [_mDB savePendingToDo:^(id object) {
            
            NSLog(@"Successfully Saved");

        } onError:^(NSError *error) {
            
            [self showAlertViewWithError:error];
            
        } andTitle:textField.text];
        
        
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    
    /*....Disable Add Button Initially....*/
    
    _addAction.enabled=NO;
    
    [alert addAction:_addAction];
    
    [self presentViewController:alert animated:YES completion:nil];

}
#pragma mark - LogoOut User

- (IBAction)action_logout:(id)sender {
    
    /*....Signout from Firebase....*/
    [[FIRAuth auth]signOut:nil];
    
}
@end
