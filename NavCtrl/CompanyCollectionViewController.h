//
//  CompanyCollectionViewController.h
//  NavCtrl
//
//  Created by Aditya Narayan on 11/30/15.
//  Copyright © 2015 Aditya Narayan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DAO.h"
#import "ProductCollectionViewController.h"

@interface CompanyCollectionViewController : UICollectionViewController

@property (nonatomic, retain) NSMutableArray *companyList;

@property (nonatomic, retain) IBOutlet  ProductCollectionViewController * productCollectionViewController;

@property (retain, nonatomic) IBOutlet UIViewController *companyInputViewController;

@end
