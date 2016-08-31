//
//  SingletonClass.h
//  iLook
//
//  Created by Gaurav Singh on 7/23/15.
//  Copyright (c) 2015 Sandeep Kumar. All rights reserved.
//
@import FirebaseDatabase;
@import FirebaseAuth;

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "UIViewController+Alert.h"

@interface SingletonClass : NSObject

@property (strong,nonatomic) NSString *userID;

/*....DataBase Ref....*/

-(FIRDatabaseReference *)dbRef;


+(instancetype)sharedInstance;
-(AppDelegate *)appdelegate;

@end
