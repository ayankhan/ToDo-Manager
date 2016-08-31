//
//  DatabaseOperation.h
//  ToDoList
//
//  Created by Ayan Khan on 31/08/16.
//  Copyright © 2016 Ayan Khan. All rights reserved.
//

#import <Foundation/Foundation.h>

/*....Define Completion Block....*/
typedef void (^completion_block)(id object);
typedef void (^error_block)(NSError *error);

@interface DatabaseOperation : NSObject

/*....Save TODO to Firebase....*/
-(void)savePendingToDo:(completion_block)completionBlock onError:(error_block)errorBlock andTitle:(NSString  *)title;

/*....Update Existing TODO to Firebase....*/
-(void)updatePendingToDo:(completion_block)completionBlock onError:(error_block)errorBlock havingToDoID:(NSString*)idTODO andTitle:(NSString  *)title;
@end
