//
//  UserAccount.h
//  ToDoList
//
//  Created by Ayan Khan on 30/08/16.
//  Copyright © 2016 Ayan Khan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NGRValidator/NGRValidator.h>

@interface UserAccount : NSObject

//should have email syntax:
@property (strong, nonatomic) NSString *email;
//should have at least 5 signs:
@property (strong, nonatomic) NSString *password;
//should have at least 5 signs and be same as Password. Validated only on "signup" scenario.
@property (strong, nonatomic) NSString *repeatedPassword;

- (NSError *)validateWithScenario:(NSString *)scenario;

@end
