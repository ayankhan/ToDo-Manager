//
//  DatabaseOperation.m
//  ToDoList
//
//  Created by Ayan Khan on 31/08/16.
//  Copyright © 2016 Ayan Khan. All rights reserved.
//

#import "DatabaseOperation.h"
#import "SingletonClass.h"

@implementation DatabaseOperation

#pragma mark - Save New TODO
-(void)savePendingToDo:(completion_block)completionBlock onError:(error_block)errorBlock andTitle:(NSString  *)title
{
    /*....Create TODO with Pending Status....*/
    NSDictionary *todo = @{@"title": title,
                           @"status": @"PENDING"};
    
    /*....Save TODO To User's Account....*/
    [[[[[[[SingletonClass sharedInstance] dbRef] child:@"users"] child:[[SingletonClass sharedInstance] userID]] child:@"Todo's"]childByAutoId] setValue:todo withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        
        if (error) {
            
            errorBlock(error);
            
        }
        else{
            
            completionBlock(ref);
            
        }
        
    }];

}

#pragma mark - Update Existing TODO

-(void)updatePendingToDo:(completion_block)completionBlock onError:(error_block)errorBlock havingToDoID:(NSString*)idTODO andTitle:(NSString  *)title
{
    /*....Create TODO with Pending Status....*/
    NSDictionary *todo = @{@"title": title,
                           @"status": @"DONE"};
    
    /*....Save TODO To User's Account....*/
    [[[[[[[SingletonClass sharedInstance] dbRef] child:@"users"] child:[[SingletonClass sharedInstance] userID]] child:@"Todo's"]child:idTODO] updateChildValues:todo withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        
        if (error) {
            
            errorBlock(error);
            
        }
        else{
            
            completionBlock(ref);
            
        }
        
    }];
    
}
@end
