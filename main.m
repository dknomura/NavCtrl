//
//  main.m
//  NavCtrl
//
//  Created by Aditya Narayan on 10/22/13.
//  Copyright (c) 2013 Aditya Narayan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DAO.h"
#import "NavControllerAppDelegate.h"

int main(int argc, char * argv[])
{
    @autoreleasepool {
        DAO *dao = [DAO sharedInstance];
        [dao createCompaniesAndProducts];
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([NavControllerAppDelegate class]));
    }
}
