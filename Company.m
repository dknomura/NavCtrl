//
//  Company.m
//  NavCtrl
//
//  Created by Aditya Narayan on 11/14/15.
//  Copyright © 2015 Aditya Narayan. All rights reserved.
//

#import "Company.h"

@implementation Company

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.name forKey:@"NAME_KEY"];
    [aCoder encodeObject:self.products forKey:@"PRODUCTS_KEY"];
    [aCoder encodeObject:self.stockQuote forKey:@"STOCKQUOTE_KEY"];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super init]){
        self.name = [aDecoder decodeObjectForKey:@"NAME_KEY"];
        self.products = [aDecoder decodeObjectForKey:@"PRODUCTS_KEY"];
        self.stockQuote = [aDecoder decodeObjectForKey:@"STOCKQUOTE_KEY"];
    }
    return self;
}

@end
