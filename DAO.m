//
//  DAO.m
//  NavCtrl
//
//  Created by Aditya Narayan on 11/14/15.
//  Copyright © 2015 Aditya Narayan. All rights reserved.
//

#import "DAO.h"
#import <sqlite3.h>

@interface DAO()
//{
//    sqlite3 *companyDB;
//}
@property sqlite3 *companyDB;
@property sqlite3 *productDB;

@end

@implementation DAO


+(instancetype) sharedInstance
{
    static DAO *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once (&onceToken, ^{
        _sharedInstance = [[DAO alloc] init];
    });
    
    return _sharedInstance;
    
}

#pragma mark -Save to file method




-(void) loadFile
{
    
    
//    NSError *error;
//    NSData *encodedData = [[NSData alloc] initWithContentsOfFile:self.filePathString options:0 error:&error];
//    NSMutableArray *savedCompanyList = [NSKeyedUnarchiver unarchiveObjectWithData:encodedData];
//    self.companyList = savedCompanyList;
    
//    if (error){
//        NSLog(@"error loading url: %@", error);
//    } else {
//        NSMutableArray *savedCompanyList = [NSKeyedUnarchiver unarchiveObjectWithData:encodedData];
//        self.companyList = savedCompanyList;
//    }
}


#pragma mark - Database methods\



-(void) createFileDirectory
{
    self.fileManager = [NSFileManager defaultManager];
    
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSError *error;
    self.directoryPathString = [path objectAtIndex:0];
    self.filePathString = [self.directoryPathString stringByAppendingPathComponent: @"sqllite"];
    NSLog(@"%@",self.filePathString);
    
    NSString *fileDB = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: @"sqllite"];
     NSLog(@"%@",fileDB);
    
    if (![self.fileManager fileExistsAtPath:self.filePathString]){
        [self.fileManager copyItemAtPath:fileDB toPath:self.directoryPathString error:&error];
        const char *filePath = [self.filePathString UTF8String];
        
        sqlite3 *compDB;
        char *error;
        
        if (sqlite3_open(filePath, &compDB)==SQLITE_OK){
            const char *createCompanyAndProductTable = "CREATE TABLE IF NOT EXISTS company (ID INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT); CREATE TABLE IF NOT EXISTS product (company_id INTEGER, name TEXT, website TEXT)";
            if (sqlite3_exec(compDB, createCompanyAndProductTable, NULL, NULL, &error)==SQLITE_OK) {
                
            } else {
                NSLog(@"%s", error);
            } sqlite3_close(compDB);
            
            
        }
    } else {
//        [self loadCompanyList];
    }
    
    //    [self.fileManager createDirectoryAtPath:self.directoryPathString withIntermediateDirectories:false attributes:nil error:&error];
    //
    //    if (error){
    //        NSLog(@"Error creating directory: %@", error.localizedDescription);
    //    }
    //
    //    self.filePathString = [NSString stringWithFormat: @"%@/defaultFile", self.directoryPathString];
    
}

-(void) loadCompanyList
{
    sqlite3_stmt *statement;
    if(sqlite3_open([self.filePathString UTF8String], &_companyDB)== SQLITE_OK){
        NSMutableArray *updatedCompanyList = [NSMutableArray new];
        const char *query_sql = [[NSString stringWithFormat: @"SELECT name, id FROM company"] UTF8String];;
        const char *unusedTail;
        if (sqlite3_prepare_v2(_companyDB, query_sql, 999, &statement, &unusedTail) == SQLITE_OK){
            while (sqlite3_step(statement) == SQLITE_ROW){
                NSString *name = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                NSString *companyID = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                Company *company = [[Company alloc] init];
                company.name = name;
                company.products = [self makeProductsArrayWithCompanyName:companyID];
                [updatedCompanyList addObject:company];
                
            }
        } else {
            NSLog(@"%s", sqlite3_errmsg(_companyDB));

        }
        self.companyList = updatedCompanyList;
    }
    //    NSData *encodedData = [NSKeyedArchiver archivedDataWithRootObject: self.companyList];
    //
    //    [encodedData writeToFile:self.filePathString atomically:false];
}


-(NSMutableArray*) makeProductsArrayWithCompanyName:(NSString*) name
{
    NSMutableArray *productArray = [NSMutableArray new];
    const char *productQuery = [[NSString stringWithFormat:@"SELECT name, website FROM product WHERE company_id = %@", name] UTF8String];
    sqlite3_stmt *productStatement;
    const char *unusedTail;
    if (sqlite3_open([self.filePathString UTF8String], &_productDB )== SQLITE_OK){
        if (sqlite3_prepare_v2(_productDB, productQuery, -1, &productStatement, &unusedTail) == SQLITE_OK){
            while (sqlite3_step(productStatement) ==SQLITE_ROW){
                NSString *name = [[NSString alloc] initWithUTF8String:(const char*) sqlite3_column_text(productStatement, 0)];
                NSString *website = [[NSString alloc] initWithUTF8String:(const char*) sqlite3_column_text(productStatement, 1)];
                
                Product *product = [[Product alloc] init];
                product.name = name;
                product.website = website;
                
                [productArray addObject:product];
            }
            
        } else{
            NSLog(@"%s", sqlite3_errmsg(_productDB));
        }
    } else{
        NSLog(@"%s", sqlite3_errmsg(_productDB));
    }
    return productArray;
}



-(void)updateCompanyList
{
    char *error;
    if(sqlite3_open([self.filePathString UTF8String], &_companyDB)== SQLITE_OK){
        const char *clearCompany_sql = [[NSString stringWithFormat: @"DELETE FROM company"] UTF8String];
        if (sqlite3_exec(_companyDB, clearCompany_sql, NULL, NULL, &error)==SQLITE_OK){
            
            NSLog(@"Company Table cleared");
            
            const char *clearProduct_sql = [[NSString stringWithFormat: @"DELETE FROM product"] UTF8String];
            if (sqlite3_exec(_companyDB, clearProduct_sql, NULL, NULL, &error)==SQLITE_OK){
                NSLog(@"Product Table cleared");
            
            
            for (int i = 0; i<[self.companyList count]; i++) {
                Company *currentCompany = self.companyList[i];
                const char* insertCompany = [[NSString stringWithFormat:@"INSERT INTO company (id, name) VALUES ('%d', '%@')", i, currentCompany.name] UTF8String];
                if (sqlite3_exec(_companyDB, insertCompany, NULL, NULL, &error)==SQLITE_OK){
                    NSLog(@"%@ inserted into company table", currentCompany.name);
                    

                        
                        for (int j = 0; j< [currentCompany.products count]; j++){
                            Product *currentProduct = currentCompany.products[j];
                            const char *insertProduct = [[NSString stringWithFormat:@"INSERT INTO product (company_id, name, website) VALUES('%d', '%@', '%@')", i, currentProduct.name, currentProduct.website] UTF8String];
                            if (sqlite3_exec(_companyDB, insertProduct, NULL, NULL, &error)==SQLITE_OK){
                                NSLog(@"%@ inserted into product table for company: %@", currentProduct.name, currentCompany.name);
                            } else {
                                NSLog(@"%s", error);
                            }
                        }

                    } else {
                        NSLog(@"%s", error);
                    }
                }
            }else {
                NSLog(@"%s", error);
            }
        } else {
            NSLog(@"%s", error);
        }
    }
    
}



-(void) addCompanyToDB: (Company*) company
{
    char *error;
    if (sqlite3_open([self.filePathString UTF8String], &_companyDB) == SQLITE_OK){
        const char *insertStatement = [[NSString stringWithFormat:@"INSERT INTO company (NAME) VALUES ('%@')", company.name ]  UTF8String];
        if (sqlite3_exec(_companyDB, insertStatement, NULL, NULL, &error) == SQLITE_OK){
            [self.companyList addObject: company];
            
        }
        sqlite3_close(_companyDB);
    }
    [self loadCompanyList];
}

-(void) deleteCompanyFromDB:(Company *) company
{
    char *error;
    const char *delete_sql = ("DELETE FROM COMPANY WHERE NAME IS '%s'", [company.name UTF8String]);
    sqlite3_exec(_companyDB, delete_sql, NULL, NULL, &error);
    [self.companyList removeObject:company];
}



-(void) databaseAddProduct:(Product *)product fromCompany:(Company *)company
{
    char *error;
    if (sqlite3_open([self.filePathString UTF8String], &_productDB) == SQLITE_OK){
        const char *insertStatement = [[NSString stringWithFormat:@"INSERT INTO product (NAME) VALUES ('%@')", product.name ]  UTF8String];
        if (sqlite3_exec(_companyDB, insertStatement, NULL, NULL, &error) == SQLITE_OK){
            [company.products addObject:product];
            
        }
        sqlite3_close(_companyDB);
    }
    [self loadCompanyList];
}

-(void) databaseDeleteProduct:(Product *)product fromCompany:(Company *)company
{
    char *error;
    const char *delete_sql = ("DELETE FROM product WHERE NAME IS '%s'", [product.name UTF8String]);
    sqlite3_exec(_companyDB, delete_sql, NULL, NULL, &error);
    [company.products removeObject:product];
}

#pragma mark -NSUserDefaults methods
-(void) saveDefaultsWithCompanyList:(NSMutableArray*) companyList
{
    NSData *encodedData = [NSKeyedArchiver archivedDataWithRootObject:companyList];
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    [self.userDefaults setObject:encodedData forKey:@"SAVEDCompaniesList"];
    [self.userDefaults synchronize];
    
}


-(void) loadDefaults
{
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedData = [self.userDefaults objectForKey:@"SAVEDCompaniesList"];
    NSMutableArray *savedCompaniesList = [NSKeyedUnarchiver unarchiveObjectWithData:encodedData];
    self.companyList = savedCompaniesList;
}


#pragma mark- Update/Deleting Company/Product


-(void) addProduct:(Product*)product forCurrentCompany: (Company*) company
{
    [company.products addObject:product];
}

-(void) removeProduct:(Product*)product forCurrentCompany: (Company*) company
{
    [company.products removeObject:product];
}

-(void) addCompany: (Company*) company
{
    [self.companyList addObject:company];
    [self.companyNameList addObject:company.name];
}

-(void) removeCompany: (Company*) company
{
    [self.companyList removeObject:company];
    [self.companyNameList removeObject:company.name];
}




-(void)createCompaniesAndProducts
{
    self.apple = [[Company alloc] init];
    self.samsung = [[Company alloc] init];
    self.windows = [[Company alloc] init];
    self.sony = [[Company alloc] init];
    
    self.apple.name = @"Apple";
    self.samsung.name = @"Samsung";
    self.windows.name = @"Windows";
    self.sony.name = @"Sony";
    
    
    self.apple.stockQuote = [[StockQuote alloc] init];
    self.sony.stockQuote = [[StockQuote alloc] init];
    self.windows.stockQuote = [[StockQuote alloc] init];
    self.samsung.stockQuote = [[StockQuote alloc] init];
    
    Product *ipad = [[Product alloc] init];
    Product *ipod = [[Product alloc] init];
    Product *iphone = [[Product alloc] init];
    Product *galaxyS6 = [[Product alloc] init];
    Product *galaxyNote = [[Product alloc] init];
    Product *galaxyTab = [[Product alloc] init];
    Product *xperiaZ = [[Product alloc] init];
    Product *xperiaTab = [[Product alloc] init];
    Product *smartBandTalk = [[Product alloc] init];
    Product *lumia = [[Product alloc] init];
    Product *surfacePro = [[Product alloc] init];
    Product *microsoftBand = [[Product alloc] init];;
    
    ipad.name = @"iPad Air"; ipad.website = @"https://www.apple.com/ipad-air-2/";
    ipod.name = @"iPod Touch"; ipod.website = @"https://www.apple.com/ipod-touch/";
    iphone.name = @"iPhone 6s"; iphone.website = @"https://www.apple.com/iphone-6s/";
    
    galaxyS6.name = @"Galaxy S6"; galaxyS6.website = @"https://www.samsung.com/us/explore/galaxy-s6-edge-plus-features-and-specs/?cid=ppc-";
    galaxyNote.name = @"Galaxy Note 5"; galaxyNote.website = @"https://www.techtimes.com/articles/105942/20151114/blackberry-priv-vs-samsung-galaxy-note-5-vs-google-nexus-6p-to-priv-or-not-to-priv.htm";
    galaxyTab.name = @"Galaxy Tab"; galaxyTab.website = @"https://www.samsung.com/us/mobile/galaxy-tab/";
    
    
    xperiaZ.name = @"Xperia Z"; xperiaZ.website = @"https://www.sonymobile.com/global-en/products/phones/xperia-z/";
    xperiaTab.name = @"Xperia Z3 tablet"; xperiaTab.website = @"https://www.sonymobile.com/us/products/tablets/xperia-z3-tablet-compact/";
    smartBandTalk.name = @"SmartBand Talk"; smartBandTalk.website = @"https://www.sonymobile.com/global-en/products/smartwear/smartband-talk-swr30/";
    
    
    lumia.name = @"Lumia 950"; lumia.website = @"http://www.microsoft.com/en-us/mobile/phone/lumia950/";
    surfacePro.name = @"Surface Pro 3 tablet"; surfacePro.website = @"http://www.microsoft.com/surface/en-us/devices/surface-pro-3";
    microsoftBand.name = @"Microsoft Band 2"; microsoftBand.website = @"http://www.microsoftstore.com/store/msusa/en_US/pdp/Microsoft-Band-2/productID.324438600";
    
    self.apple.products = [NSMutableArray arrayWithObjects:ipad, ipod, iphone, nil];
    self.samsung.products = [NSMutableArray arrayWithObjects:galaxyS6, galaxyNote, galaxyTab, nil];
    self.windows.products = [NSMutableArray arrayWithObjects: xperiaZ, xperiaTab, smartBandTalk, nil];
    self.sony.products = [NSMutableArray arrayWithObjects: lumia, surfacePro, microsoftBand, nil];

        //GET RESULTS FROM DICTIONARY AND PUT THEM IN self.Company.StockTicker
        
        
    
    
    
    
    
    self.companyList = [NSMutableArray arrayWithObjects:self.apple, self.samsung, self.windows, self.sony, nil];
    
    self.companyNameList = [NSMutableArray arrayWithObjects:self.apple.name, self.samsung.name, self.windows.name, self.sony.name, nil];
    
    
    
    
}



@end
