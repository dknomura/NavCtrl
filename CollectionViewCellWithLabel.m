//
//  CollectionViewCellWithLabel.m
//  NavCtrl
//
//  Created by Aditya Narayan on 11/30/15.
//  Copyright © 2015 Aditya Narayan. All rights reserved.
//

#import "CollectionViewCellWithLabel.h"

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

    return self;
}
- (void)dealloc {
    [_stockLabel release];
    [_iconImage release];
    [super dealloc];
}
@end
