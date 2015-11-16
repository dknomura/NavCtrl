//
//  Company.m
//  NavCtrl
//
//  Created by Aditya Narayan on 11/14/15.
//  Copyright © 2015 Aditya Narayan. All rights reserved.
//

#import "Company.h"

@implementation Company
-(id) mutableCopyWithZone:(NSZone *)zone
{
    Company *company = [[Company alloc] init];
    company.name = [_name mutableCopyWithZone:zone];
    company.products = [_products mutableCopyWithZone:zone];
    return company;
}

-(id) mutableCopy
{
    Company *company = [[Company alloc] init];
    company.name = [_name mutableCopy];
    company.products = [_products mutableCopy];
    return company;
}

@end
