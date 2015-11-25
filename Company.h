//
//  Company.h
//  NavCtrl
//
//  Created by Aditya Narayan on 11/14/15.
//  Copyright © 2015 Aditya Narayan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StockQuote.h"

@interface Company : NSObject <NSCoding>
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *symbol;
@property (strong, nonatomic) NSString *stockQuote;
@property (nonatomic, strong) NSString *change;

@property (strong, nonatomic) NSMutableArray *products;
@property (strong, nonatomic) NSNumber *index;


@end
