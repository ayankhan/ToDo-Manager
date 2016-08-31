//
//  SingletonClass.m
//  iLook
//
//  Created by Gaurav Singh on 7/23/15.
//  Copyright (c) 2015 Sandeep Kumar. All rights reserved.
//

#import "SingletonClass.h"

@implementation SingletonClass


+(instancetype)sharedInstance
{
    static SingletonClass *_sharedInstance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _sharedInstance = [[SingletonClass alloc] init];
    });
    return _sharedInstance;
}

/*....Create DataBase Ref....*/
-(FIRDatabaseReference *)dbRef{
   return [[FIRDatabase database] reference];
}

-(AppDelegate *)appdelegate
{
    return (AppDelegate*)[[UIApplication sharedApplication]delegate];
}
@end