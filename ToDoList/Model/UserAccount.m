//
//  UserAccount.m
//  ToDoList
//
//  Created by Ayan Khan on 30/08/16.
//  Copyright © 2016 Ayan Khan. All rights reserved.
//

#import "UserAccount.h"

@implementation  UserAccount

- (NSError *)validateWithScenario:(NSString *)scenario {
    NSError *error = nil;
    [NGRValidator validateModel:self error:&error scenario:scenario delegate:nil rules:^NSArray *{
        return @[NGRValidate(@"email").required().syntax(NGRSyntaxEmail),
                 NGRValidate(@"password").required().minLength(5),
                 NGRValidate(@"repeatedPassword").required().match(self.password).onScenarios(@[@"signup"])];
    }];
    return error;
}

@end
