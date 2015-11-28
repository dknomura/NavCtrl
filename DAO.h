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
#import <sqlite3.h>
#import "ProductMO.h"
#import "CompanyMO.h"
#import <CoreData/CoreData.h>

@interface DAO : NSObject

@property (nonatomic, strong) CompanyMO *currentCompany;

@property (strong) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, strong) NSMutableArray *companyList;

@property (nonatomic, strong) NSMutableArray *companyNameList;

@property (nonatomic, strong) NSUserDefaults *userDefaults;

@property (nonatomic, strong) NSFileManager *fileManager;

@property (nonatomic, strong) NSString *directoryPathString;

@property (nonatomic, strong) NSString *filePathString;


-(void) initializeCoreData;

-(void) createCompaniesAndProducts;

+(instancetype) sharedInstance;

-(void)updateCurrentCompany:(Company*)company;
-(void)updateCurrentProduct:(Product *)product forCurrentCompany:(Company*)company;

-(void) addCompany:(Company*)company;
-(void) addProduct:(Product*) product forCompany:(Company*)company;

-(void) deleteCompany:(Company*)company;
-(void) deleteProduct:(Product*)product forCompany:(Company*)company;

-(void) updateCompanyIndices;
-(void) updateProductIndicesForCurrentCompany:(Company*)currentCompany;

-(void) loadCompanyListFromFetchedResults;


//
//
//-(void) addProduct:(Product*)product forCurrentCompany: (Company*) company;
//
//-(void) removeProduct:(Product*)product forCurrentCompany: (Company*) company;
//
//-(void) addCompany: (Company*) company;
//
//-(void) removeCompany: (Company*) company;
//
//-(void) deleteCompanyFromDB:(Company *) company;
//
//-(void) updateCompanyList;
//-(void) loadCompanyList;
//
//-(void) addCompanyToDB: (Company*) company;
//
//-(void) databaseAddProduct:(Product*)product fromCompany:(Company*)company;
//-(void) databaseDeleteProduct:(Product*) product fromCompany:(Company*) company;
//
//
//
//-(void) updateProductsForCompany: (Company*) company toProducts:(NSMutableArray*) updatedProducts;






@end
