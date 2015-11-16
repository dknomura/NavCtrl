//
//  Product.h
//  NavCtrl
//
//  Created by Aditya Narayan on 11/14/15.
//  Copyright © 2015 Aditya Narayan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Product : NSObject <NSMutableCopying>
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *website;
@end
