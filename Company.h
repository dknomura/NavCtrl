//
//  Company.h
//  NavCtrl
//
//  Created by Aditya Narayan on 11/14/15.
//  Copyright © 2015 Aditya Narayan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Company : NSObject <NSMutableCopying>
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSMutableArray *products;
@end
