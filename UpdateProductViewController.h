//
//  UpdateProductViewController.h
//  NavCtrl
//
//  Created by Aditya Narayan on 11/15/15.
//  Copyright © 2015 Aditya Narayan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DAO.h"

@interface UpdateProductViewController : UIViewController
@property (strong, nonatomic) Product *currentProduct;
@property (strong, nonatomic) Company *currentCompany;

@end
