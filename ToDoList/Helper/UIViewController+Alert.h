//
//  UIViewController+Alert.h
//  ToDoList
//
//  Created by Ayan Khan on 31/08/16.
//  Copyright © 2016 Ayan Khan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Alert)
- (void)showAlertViewWithError:(NSError *)error;
- (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message;
@end
