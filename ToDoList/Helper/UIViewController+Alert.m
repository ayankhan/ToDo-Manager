//
//  UIViewController+Alert.m
//  ToDoList
//
//  Created by Ayan Khan on 31/08/16.
//  Copyright © 2016 Ayan Khan. All rights reserved.
//

#import "UIViewController+Alert.h"

@implementation UIViewController (Alert)
- (void)showAlertViewWithError:(NSError *)error {
    if (error) {
        [self showAlertViewWithTitle:NSLocalizedString(@"Validation failed!", nil) message:error.localizedDescription];
    }
}

- (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message {
    
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}
@end
