//
//  CollectionViewCellWithLabel.h
//  NavCtrl
//
//  Created by Aditya Narayan on 11/30/15.
//  Copyright © 2015 Aditya Narayan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewCellWithLabel : UICollectionViewCell
@property (nonatomic,strong) IBOutlet UILabel *companyNameLabel;
@property (retain, nonatomic) IBOutlet UIImageView *iconImage;
@property (retain, nonatomic) IBOutlet UILabel *stockLabel;
@end
