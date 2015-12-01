//
//  CollectionViewCellWithLabel.h
//  NavCtrl
//
//  Created by Aditya Narayan on 11/30/15.
//  Copyright © 2015 Aditya Narayan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DAO.h"

@interface CollectionViewCellWithLabel : UICollectionViewCell
@property (nonatomic,strong) IBOutlet UILabel *companyNameLabel;
@property (retain, nonatomic) IBOutlet UIImageView *iconImage;
@property (retain, nonatomic) IBOutlet UILabel *stockLabel;
@property (retain, nonatomic) IBOutlet UIButton *deleteButton;
@property (retain, nonatomic) IBOutlet UIButton *hitToDeleteButton;
@property (strong, nonatomic) DAO *dao;
- (IBAction)deleteCell:(id)sender;

@end
