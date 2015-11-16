//
//  Product.m
//  NavCtrl
//
//  Created by Aditya Narayan on 11/14/15.
//  Copyright © 2015 Aditya Narayan. All rights reserved.
//

#import "Product.h"

@implementation Product
-(id) mutableCopyWithZone:(NSZone *)zone
{
    Product *product = [[Product alloc] init];
    product.name = [_name mutableCopyWithZone:zone];
    product.website = [_website mutableCopyWithZone:zone];
    return product;
}

-(id) mutableCopy
{
    Product *product = [[Product alloc] init];
    product.name = [_name mutableCopy];
    product.website = [_website mutableCopy];
    return product;
}

@end
