//
//  CollectionViewCellWithLabel.m
//  NavCtrl
//
//  Created by Aditya Narayan on 11/30/15.
//  Copyright © 2015 Aditya Narayan. All rights reserved.
//

#import "CollectionViewCellWithLabel.h"
#import "CompanyCollectionViewController.h"
#import "ProductCollectionViewController.h"

@implementation CollectionViewCellWithLabel
-(instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"NibCell" owner:self options:nil];
        
        if ([arrayOfViews count] < 1) {
            return nil;
        }
        
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]) {
            return nil;
        }
        self = [arrayOfViews objectAtIndex:0];
    }
    self.dao = [DAO sharedInstance];

    return self;
}
- (void)dealloc {
    [_stockLabel release];
    [_iconImage release];
    [_deleteButton release];
    [_hitToDeleteButton release];
    [super dealloc];
}

- (IBAction)deleteCell:(id)sender
{

    id currentCollectionView = self.superview;
    CGPoint pointOfButton = self.center;
    NSIndexPath *indexPathOfButton = [currentCollectionView indexPathForItemAtPoint: pointOfButton];
    [currentCollectionView performBatchUpdates:^{
        Product *productToRemove = [self.dao.currentCompany.products objectAtIndex:indexPathOfButton.row];
        [self.dao deleteProduct:productToRemove forCompany:self.dao.currentCompany];
        [currentCollectionView deleteItemsAtIndexPaths:@[indexPathOfButton]];
    }completion:nil];
}
@end
