//
//  StockQuote.h
//  NavCtrl
//
//  Created by Aditya Narayan on 11/16/15.
//  Copyright © 2015 Aditya Narayan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StockQuote : NSObject
@property (nonatomic, strong) NSString *symbol;
@property (nonatomic, strong) NSString *quote;
@property (nonatomic, strong) NSString *change;

@end
