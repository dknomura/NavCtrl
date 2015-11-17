//
//  Product.m
//  NavCtrl
//
//  Created by Aditya Narayan on 11/14/15.
//  Copyright © 2015 Aditya Narayan. All rights reserved.
//

#import "Product.h"

@implementation Product

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.name forKey:@"NAME_KEY"];
    [aCoder encodeObject:self.website forKey:@"WEBSITE_KEY"];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super init]){
        self.name = [aDecoder decodeObjectForKey:@"NAME_KEY"];
        self.website = [aDecoder decodeObjectForKey:@"WEBSITE_KEY"];
    }
    return self;
}

@end
