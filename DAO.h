//
//  DAO.h
//  NavCtrl
//
//  Created by Aditya Narayan on 11/14/15.
//  Copyright © 2015 Aditya Narayan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Company.h"
#import "Product.h"
#import "StockQuote.h"


@interface DAO : NSObject

@property (nonatomic, strong) Company *currentCompany;

@property (nonatomic, strong) Company *apple;
@property (nonatomic, strong) Company *samsung;
@property (nonatomic, strong) Company *windows;
@property (nonatomic, strong) Company *sony;

@property (nonatomic, strong) NSMutableArray *companyList;

@property (nonatomic, strong) NSMutableArray *companyNameList;


-(void) addProduct:(Product*)product forCurrentCompany: (Company*) company;

-(void) removeProduct:(Product*)product forCurrentCompany: (Company*) company;

-(void) addCompany: (Company*) company;

-(void) removeCompany: (Company*) company;

-(void) updateNameForCompany: (Company*) company toString:(NSString*)string;

-(void) updateProduct:(Product *)updatedProduct forCurrentCompany:(Company *)currentCompany withName:(NSString*) name andWebsite:(NSString*) website;

-(void) updateProductsForCompany: (Company*) company toProducts:(NSMutableArray*) updatedProducts;




-(void) createCompaniesAndProducts;

+(instancetype) sharedInstance;



@end
