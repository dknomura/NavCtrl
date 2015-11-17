//
//  StockQuote.m
//  NavCtrl
//
//  Created by Aditya Narayan on 11/16/15.
//  Copyright © 2015 Aditya Narayan. All rights reserved.
//

#import "StockQuote.h"

@implementation StockQuote
-(instancetype) initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]){
        self.symbol = [aDecoder decodeObjectForKey:@"SYMBOL_KEY"];
        self.quote = [aDecoder decodeObjectForKey:@"QUOTE_KEY"];
        self.change = [aDecoder decodeObjectForKey:@"CHANGE_KEY"];

    }
    return self;
}

-(void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.symbol forKey:@"SYMBOL_KEY"];
    [aCoder encodeObject:self.quote forKey:@"QUOTE_KEY"];
    [aCoder encodeObject:self.change forKey:@"CHANGE_KEY"];

}

@end
