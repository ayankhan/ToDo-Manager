//
//  ViewController.m
//  ToDoList
//
//  Created by Ayan Khan on 30/08/16.
//  Copyright © 2016 Ayan Khan. All rights reserved.
//

@import FirebaseAuth;

#import "ViewController.h"
#import "UserAccount.h"
#import "UIViewController+Alert.h"
#import "SingletonClass.h"

@interface ViewController ()
/*....UI Outlets....*/
@property (weak, nonatomic) IBOutlet UITextField *mEmailTextField;
@property (weak, nonatomic) IBOutlet UITextField *mPasswordTextfield;
@property (weak, nonatomic) IBOutlet UITextField *mConfirmTextfield;
@property (weak, nonatomic) IBOutlet UIButton *mLoginButton;

/*....Constraint....*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mConfirmHeight;

/*....Actions....*/
- (IBAction)action_loginRegister:(id)sender;
- (IBAction)action_segment:(id)sender;

/*....Validation Model....*/
@property (strong, nonatomic) UserAccount *user;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    /*....Setup Validation....*/
    _user = [[UserAccount alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Methods
- (IBAction)action_loginRegister:(id)sender {
    
    /*....Check Internet....*/
    if ([[[SingletonClass sharedInstance] appdelegate] Is_InternetAvailable]) {
        self.user.email = self.mEmailTextField.text;
        self.user.password = self.mPasswordTextfield.text;
        self.user.repeatedPassword = self.mConfirmTextfield.text;
        
        /*....Check Login/Register....*/
        
        if ([[self.mLoginButton titleForState:UIControlStateNormal]isEqualToString:@"Login"]) {
            
            NSError *error = [self.user validateWithScenario:@"login"];
            if (!error) {
                [[[SingletonClass sharedInstance] appdelegate] showLoadingAnimation];
                /*....Login to Firebase....*/
                [[FIRAuth auth] signInWithEmail:self.mEmailTextField.text password:self.mPasswordTextfield.text
                                     completion:^(FIRUser *user, NSError *error) {
                                         // ...
                                         
                                         [[[SingletonClass sharedInstance] appdelegate] hideLoadingAnimation];
                                         
                                         if (error) {
                                             [self showAlertViewWithError:error];
                                         }
                                         else{
                                             /*....Save UserID & Continue....*/
                                             [[SingletonClass sharedInstance] setUserID:user.uid];
                                             
                                         }
                                     }];
            }
            else{
                [self showAlertViewWithError:error];
            }
            
        }
        else{
            
            NSError *error = [self.user validateWithScenario:@"signup"];
            if (!error) {
                
                [[[SingletonClass sharedInstance] appdelegate] showLoadingAnimation];
                
                /*....Register User to Firebase....*/
                [[FIRAuth auth]
                 createUserWithEmail:self.mEmailTextField.text
                 password:self.mPasswordTextfield.text
                 completion:^(FIRUser *_Nullable user,
                              NSError *_Nullable error) {
                     // ...
                     
                     [[[SingletonClass sharedInstance] appdelegate] hideLoadingAnimation];
                     
                     if (error) {
                         [self showAlertViewWithError:error];
                     }
                     else{
                         /*....Save UserID & Continue....*/
                         [[SingletonClass sharedInstance] setUserID:user.uid];
                         
                     }
                     
                 }];
            }
            else{
                [self showAlertViewWithError:error];
            }
            
            
        }

    }
    else{
        [self showAlertViewWithTitle:@"No Internet !" message:@"Please check your internet connection."];
    
    }
    
}

- (IBAction)action_segment:(id)sender {
    
    [self.view endEditing:true];
    
    self.mEmailTextField.text=@"";
    self.mPasswordTextfield.text=@"";
    self.mConfirmTextfield.text=@"";

    UISegmentedControl *mSegment = (UISegmentedControl*)sender;
    
    if (mSegment.selectedSegmentIndex==0) {
        
        self.mConfirmHeight.constant=0;
        self.mConfirmTextfield.hidden=YES;
        [self.mLoginButton setTitle:@"Login" forState:UIControlStateNormal];
        
    }
    else{
        
        self.mConfirmHeight.constant=30;
        self.mConfirmTextfield.hidden=NO;
        [self.mLoginButton setTitle:@"Register" forState:UIControlStateNormal];
        
    }
    
    [UIView animateWithDuration:0.1 animations:^{
        [self.view layoutIfNeeded];
    }];
    
}


@end
