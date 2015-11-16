//
//  ItemInputViewController.h
//  NavCtrl
//
//  Created by Aditya Narayan on 11/14/15.
//  Copyright © 2015 Aditya Narayan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DAO.h"

@interface ItemInputViewController : UIViewController

@property (strong, nonatomic) Company *currentCompany;
@property (strong, nonatomic) Product *currentProduct;

@end
