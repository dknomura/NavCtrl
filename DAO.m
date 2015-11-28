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
@property (strong, nonatomic) NSFetchedResultsController *companyFetchedResultsController;

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



#pragma mark - Core Data methods



-(void) initializeCoreData
{

    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    NSManagedObjectModel *mom = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    NSAssert(mom != nil, @"Error initializing ManagedObjectModel");
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    self.managedObjectContext= [[NSManagedObjectContext alloc]initWithConcurrencyType:NSMainQueueConcurrencyType];
    [self.managedObjectContext setPersistentStoreCoordinator:psc];
    self.managedObjectContext.undoManager = [[NSUndoManager alloc]init];
    
//    [self.managedObjectContext.undoManager beginUndoGrouping];

    
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *documentsURL = [fileManager URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:NULL create:true error:&error];
    NSURL *storeURL = [documentsURL URLByAppendingPathComponent:@"Model.sqlite"];
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *error;
//        NSPersistentStoreCoordinator *psc = [self.managedObjectContext persistentStoreCoordinator];
        NSPersistentStore *store = [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];
        NSAssert(store != nil, @"Error initializing PSC: %@, %@", error.localizedDescription, error.userInfo);
    });
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"CompanyMO"];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:true];
    [request setSortDescriptors:@[sortDescriptor]];
    self.companyFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    if (![self.companyFetchedResultsController performFetch:&error]){
        NSLog(@"Failed to initialize FetchedResults Controller: %@, %@", error.localizedDescription, error.userInfo);
        abort();
    }
    
    NSArray *results = self.companyFetchedResultsController.fetchedObjects;
    
//    [self clearManagedObjectContext];
//    
//    [self createCompaniesAndProducts];

    if ([results count] == 0){
        [self createCompaniesAndProducts];
    } else {
        [self loadCompanyListFromFetchedResults];
        
    }
}


-(void) loadCompanyListFromFetchedResults
{
    NSError *error = nil;
    NSFetchRequest *companyFetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"CompanyMO"];
    NSSortDescriptor *sortByIndex = [NSSortDescriptor sortDescriptorWithKey:@"index" ascending:TRUE];
    companyFetchRequest.sortDescriptors = @[sortByIndex];
    NSArray *companyResults = [self.managedObjectContext executeFetchRequest:companyFetchRequest error:&error];
    if (!companyResults) {
        [NSException raise:@"Fetch Failed" format:@"%@", error.localizedDescription];
    }
    
    self.companyList = [NSMutableArray new];
//    for (int i = 0; i < [results count]; i++){
//        [self.companyList addObject:[NSNumber numberWithInt:i]];
//    }
    
    
    for(CompanyMO* companyMO in companyResults){
        Company *company = [[Company alloc] init];
        company.name = companyMO.name;
        company.stockQuote = companyMO.stockQuote;
        company.index = companyMO.index;
        company.symbol = companyMO.symbol;
        company.uniqueID = companyMO.uniqueID;
        company.products = [NSMutableArray new];
        for(Product* productMO in companyMO.products){
            Product *product = [[Product alloc] init];
            product.index = productMO.index;
            product.name = productMO.name;
            product.website = productMO.website;
            product.uniqueID = productMO.uniqueID;
            [company.products addObject:product];
        }
        [self.companyList addObject:company];
    }
//    [self.managedObjectContext.undoManager beginUndoGrouping];
}


-(void) clearManagedObjectContext
{
    NSFetchRequest *companyRequest = [[[NSFetchRequest alloc] init] autorelease];
    [companyRequest setEntity:[NSEntityDescription entityForName:@"CompanyMO" inManagedObjectContext:self.managedObjectContext]];
    NSArray *companyMOList = [self.managedObjectContext executeFetchRequest:companyRequest error:nil];
    for (CompanyMO *companyMO in companyMOList){
        [self.managedObjectContext deleteObject:companyMO];
        for (ProductMO *productMO in companyMO.products){
            [self.managedObjectContext deleteObject:productMO];
        }
    }
    [self saveChanges];
}

-(void) saveChanges
{
    NSError *error;
    BOOL saveSuccess = [self.managedObjectContext save:&error];
    if (saveSuccess){
        NSLog(@"Data Saved");
    }else{
        NSLog(@"%@", error.localizedDescription);
    }
}


//-(NSArray*)updatedCompanyMOList
//{
//    NSFetchRequest *companyFetch = [NSFetchRequest fetchRequestWithEntityName:@"CompanyMO"];
//    NSError *error = nil;
//    NSArray *companyMOList = [self.managedObjectContext executeFetchRequest:companyFetch error:&error];
//    if (error){
//        NSLog(@"Error fetching CompanyList: %@, %@", error.localizedDescription, error.userInfo);
//        abort();
//    }
//    return companyMOList;
//}

-(void) addCompany:(Company*)company
{
    CompanyMO *newCompanyMO = [NSEntityDescription insertNewObjectForEntityForName:@"CompanyMO" inManagedObjectContext:self.managedObjectContext];
    
    newCompanyMO.name = company.name;
    [self.companyList addObject:company];

    [self setNewCompanyIDForCompanyMO:newCompanyMO];
    
    [self updateCompanyIndices];
}



-(void) deleteCompany:(Company *)company
{
    [self.companyFetchedResultsController performFetch:nil];
    
    for(CompanyMO *companyMO in self.companyFetchedResultsController.fetchedObjects){
        if([company.uniqueID isEqualToNumber:companyMO.uniqueID]){
            [self.managedObjectContext deleteObject:companyMO];
            break;
        }
    }
    [self.companyList removeObject:company];
    [self updateCompanyIndices];
}

-(void) addProduct:(Product *)product forCompany:(Company *)company
{
    [company.products addObject:product];
    
    [self.companyFetchedResultsController performFetch:nil];

    for (CompanyMO *companyMO in self.companyFetchedResultsController.fetchedObjects){
        if ([companyMO.uniqueID isEqualToNumber:company.uniqueID]){
            ProductMO *newProductMO = [NSEntityDescription insertNewObjectForEntityForName:@"ProductMO" inManagedObjectContext:self.managedObjectContext];
            newProductMO.name = product.name;
            newProductMO.website = product.website;
            newProductMO.whoSells = companyMO;
            [self setNewProductIDForProductMO:newProductMO];
            break;
        }
    }
    [self updateProductIndicesForCurrentCompany:company];
}

-(void)deleteProduct:(Product *)product forCompany:(Company *)company
{
    [self.companyFetchedResultsController performFetch:nil];

    for(CompanyMO *companyMO in self.companyFetchedResultsController.fetchedObjects){
        if([companyMO.uniqueID isEqualToNumber:company.uniqueID]){
            for (ProductMO *productMO in companyMO.products) {
                if([product.uniqueID isEqualToNumber:productMO.uniqueID]){
                    [self.managedObjectContext deleteObject:productMO];
                }
            }
        }
    }
    [company.products removeObject:product];
    [self updateProductIndicesForCurrentCompany:company];
}

-(void) updateCurrentCompany:(Company *)company
{
    [self.companyFetchedResultsController performFetch:nil];

    for (CompanyMO *companyMO in self.companyFetchedResultsController.fetchedObjects){
        if ([company.uniqueID isEqualToNumber:companyMO.uniqueID]){
            companyMO.name = company.name;
            companyMO.symbol = company.symbol;
            for (int i = 0; i < [company.products count]; i++){
                Product *updatingProduct = company.products[i];
                ProductMO *MOproductToUpdate;
                
                if([companyMO.products count] <= i){
                    MOproductToUpdate = [NSEntityDescription insertNewObjectForEntityForName:@"ProductMO" inManagedObjectContext:self.managedObjectContext];
                    [self setNewProductIDForProductMO:MOproductToUpdate];

                } else {
                    MOproductToUpdate = [[companyMO.products allObjects] objectAtIndex:i];
                }
                MOproductToUpdate.name = updatingProduct.name;
                MOproductToUpdate.website = updatingProduct.website;
                MOproductToUpdate.whoSells = companyMO;
                }
            break;
        }
    }
    [self updateProductIndicesForCurrentCompany:company];
}

-(void)updateCurrentProduct:(Product *)product forCurrentCompany:(Company*)company
{
//    NSError *error;
//    [self.companyFetchedResultsController performFetch:&error];
//    if (error) {
//        NSLog(@"Error performing fetch: %@, %@", error.localizedDescription, error.userInfo);
//        abort();
//    }
//
    [self.companyFetchedResultsController performFetch:nil];

    for(CompanyMO *companyMO in self.companyFetchedResultsController.fetchedObjects){
        if ([companyMO.uniqueID isEqualToNumber: company.uniqueID]){
            for (ProductMO *productMO in companyMO.products){
                if ([product.uniqueID isEqualToNumber:productMO.uniqueID]){
                    productMO.website = product.website;
                    productMO.name = product.name;
                }
            }
        }
    }
}

-(void) updateCompanyIndices
{
    [self.companyFetchedResultsController performFetch:nil];

    for (Company *company in self.companyList){
        company.index = [NSNumber numberWithLong:[self.companyList indexOfObject:company]];
        for (CompanyMO *companyMO in self.companyFetchedResultsController.fetchedObjects){
            if ([company.uniqueID isEqualToNumber: companyMO.uniqueID]){
                companyMO.index = company.index;
                break;
            }
        }
    }
//    [self saveChanges];
}

-(void) updateProductIndicesForCurrentCompany:(Company*)currentCompany
{
    [self.companyFetchedResultsController performFetch:nil];

    for (CompanyMO *companyMO in self.companyFetchedResultsController.fetchedObjects) {
        if([companyMO.uniqueID isEqualToNumber:currentCompany.uniqueID]){
            for (Product *product in currentCompany.products){
                product.index = [NSNumber numberWithLong:[currentCompany.products indexOfObject:product]];
                for(ProductMO *productMO in companyMO.products) {
                    if ([product.name isEqualToString:productMO.name]){
                        productMO.index = product.index;
                        break;
                    }
                }
            }
        }
    }
//    [self saveChanges];
}


-(void) setNewCompanyIDForCompanyMO:(CompanyMO*)newCompany
{
    NSFetchRequest *companyFetch = [NSFetchRequest fetchRequestWithEntityName:@"CompanyMO"];
    NSSortDescriptor *sortByID = [NSSortDescriptor sortDescriptorWithKey:@"uniqueID" ascending:FALSE];
    [companyFetch setSortDescriptors:@[sortByID]];
    NSArray *companyListDescendingByID = [self.managedObjectContext executeFetchRequest:companyFetch error:nil];
    NSNumber *newCompanyID = [NSNumber numberWithInt:[[[companyListDescendingByID objectAtIndex:0] uniqueID] intValue] + 1];
    newCompany.uniqueID = newCompanyID;
    
    for (Company *company in self.companyList){
        if ([company.name isEqualToString:newCompany.name]){
            company.uniqueID = newCompanyID;
        }
    }
}

-(void) setNewProductIDForProductMO:(ProductMO*)newProduct
{
    NSFetchRequest *productFetch = [NSFetchRequest fetchRequestWithEntityName:@"ProductMO"];
    NSSortDescriptor *sortByID = [NSSortDescriptor sortDescriptorWithKey:@"uniqueID" ascending:FALSE];
    [productFetch setSortDescriptors:@[sortByID]];
    NSArray *productResult = [self.managedObjectContext executeFetchRequest:productFetch error:nil];
    NSNumber *newProductID = [NSNumber numberWithInt:[[[productResult objectAtIndex:0] uniqueID] intValue] +1];
    newProduct.uniqueID = newProductID;
    
    for (Company *company in self.companyList){
        for (Product *product in company.products){
            if ([product.name isEqualToString:newProduct.name]){
                product.uniqueID = newProductID;
            }
        }
    }

}

-(void)createCompaniesAndProducts
{
    CompanyMO *apple = [NSEntityDescription insertNewObjectForEntityForName:@"CompanyMO" inManagedObjectContext:self.managedObjectContext];
    CompanyMO *samsung = [NSEntityDescription insertNewObjectForEntityForName:@"CompanyMO" inManagedObjectContext:self.managedObjectContext];
    CompanyMO *windows = [NSEntityDescription insertNewObjectForEntityForName:@"CompanyMO" inManagedObjectContext:self.managedObjectContext];
    CompanyMO *sony = [NSEntityDescription insertNewObjectForEntityForName:@"CompanyMO" inManagedObjectContext:self.managedObjectContext];
    
    apple.name = @"Apple";
    apple.index = [NSNumber numberWithInt:0];
    apple.symbol = @"aapl";
    apple.uniqueID = [NSNumber numberWithInt:0];
    
    samsung.name = @"Samsung";
    samsung.index = [NSNumber numberWithInt:1];
    samsung.symbol = @"SSNLF";
    samsung.uniqueID = [NSNumber numberWithInt:1];
    
    windows.name = @"Windows";
    windows.index = [NSNumber numberWithInt:2];
    windows.symbol = @"msft";
    windows.uniqueID = [NSNumber numberWithInt:2];
    
    sony.name = @"Sony";
    sony.index = [NSNumber numberWithInt:3];
    sony.symbol = @"sne";
    sony.uniqueID = [NSNumber numberWithInt:3];
    
    ProductMO *ipad = [NSEntityDescription insertNewObjectForEntityForName:@"ProductMO" inManagedObjectContext:self.managedObjectContext];
    ProductMO *ipod = [NSEntityDescription insertNewObjectForEntityForName:@"ProductMO" inManagedObjectContext:self.managedObjectContext];
    ProductMO *iphone = [NSEntityDescription insertNewObjectForEntityForName:@"ProductMO" inManagedObjectContext:self.managedObjectContext];
    ProductMO *galaxyS6 = [NSEntityDescription insertNewObjectForEntityForName:@"ProductMO" inManagedObjectContext:self.managedObjectContext];
    ProductMO *galaxyNote = [NSEntityDescription insertNewObjectForEntityForName:@"ProductMO" inManagedObjectContext:self.managedObjectContext];
    ProductMO *galaxyTab = [NSEntityDescription insertNewObjectForEntityForName:@"ProductMO" inManagedObjectContext:self.managedObjectContext];
    ProductMO *xperiaZ = [NSEntityDescription insertNewObjectForEntityForName:@"ProductMO" inManagedObjectContext:self.managedObjectContext];
    ProductMO *xperiaTab = [NSEntityDescription insertNewObjectForEntityForName:@"ProductMO" inManagedObjectContext:self.managedObjectContext];
    ProductMO *smartBandTalk = [NSEntityDescription insertNewObjectForEntityForName:@"ProductMO" inManagedObjectContext:self.managedObjectContext];
    ProductMO *lumia = [NSEntityDescription insertNewObjectForEntityForName:@"ProductMO" inManagedObjectContext:self.managedObjectContext];
    ProductMO *surfacePro = [NSEntityDescription insertNewObjectForEntityForName:@"ProductMO" inManagedObjectContext:self.managedObjectContext];
    ProductMO *microsoftBand = [NSEntityDescription insertNewObjectForEntityForName:@"ProductMO" inManagedObjectContext:self.managedObjectContext];
    
    
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
    
    apple.products = [NSSet setWithObjects: ipad, ipod, iphone, nil];
    samsung.products = [NSSet setWithObjects:galaxyS6, galaxyNote, galaxyTab, nil];
    sony.products = [NSSet setWithObjects: xperiaZ, xperiaTab, smartBandTalk, nil];
    windows.products = [NSSet setWithObjects: lumia, surfacePro, microsoftBand, nil];
    
    NSFetchRequest *productsFetch = [NSFetchRequest fetchRequestWithEntityName:@"ProductMO"];
    NSArray *productsResult = [self.managedObjectContext executeFetchRequest:productsFetch error:nil];
    int ID = 0;
    for(ProductMO *productMO in productsResult){
        productMO.uniqueID = [NSNumber numberWithInt:ID];
        ID++;
    }

    NSArray *companyMOList = [NSArray arrayWithObjects:apple, samsung, windows, sony, nil];
    self.companyList = [NSMutableArray new];
    
    for(CompanyMO* companyMO in companyMOList){
        Company *company = [[Company alloc] init];
        company.name = companyMO.name;
        company.index = companyMO.index;
        company.symbol = companyMO.symbol;
        company.uniqueID = companyMO.uniqueID;
        company.products = [NSMutableArray new];
        for(Product* productMO in companyMO.products){
            Product *product = [[Product alloc] init];
            product.name = productMO.name;
            product.website = productMO.website;
            product.uniqueID = productMO.uniqueID;
            [company.products addObject:product];
        }
        [self.companyList addObject:company];
    }
}




//-(void) loadFile
//{
//    

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
//}
//
//
//-(void) addCompanyToDB: (Company*) company
//{
//    char *error;
//    if (sqlite3_open([self.filePathString UTF8String], &_companyDB) == SQLITE_OK){
//        const char *insertStatement = [[NSString stringWithFormat:@"INSERT INTO company (NAME) VALUES ('%@')", company.name ]  UTF8String];
//        if (sqlite3_exec(_companyDB, insertStatement, NULL, NULL, &error) == SQLITE_OK){
//            [self.companyList addObject: company];
//            
//        }
//        sqlite3_close(_companyDB);
//    }
//    [self loadCompanyList];
//}
//
//-(void) deleteCompanyFromDB:(Company *) company
//{
//    char *error;
//    const char *delete_sql = ("DELETE FROM COMPANY WHERE NAME IS '%s'", [company.name UTF8String]);
//    sqlite3_exec(_companyDB, delete_sql, NULL, NULL, &error);
//    [self.companyList removeObject:company];
//}
//
//
//
//-(void) databaseAddProduct:(Product *)product fromCompany:(Company *)company
//{
//    char *error;
//    if (sqlite3_open([self.filePathString UTF8String], &_productDB) == SQLITE_OK){
//        const char *insertStatement = [[NSString stringWithFormat:@"INSERT INTO product (NAME) VALUES ('%@')", product.name ]  UTF8String];
//        if (sqlite3_exec(_companyDB, insertStatement, NULL, NULL, &error) == SQLITE_OK){
//            [company.products addObject:product];
//            
//        }
//        sqlite3_close(_companyDB);
//    }
//    [self loadCompanyList];
//}
//
//-(void) databaseDeleteProduct:(Product *)product fromCompany:(Company *)company
//{
//    char *error;
//    const char *delete_sql = ("DELETE FROM product WHERE NAME IS '%s'", [product.name UTF8String]);
//    sqlite3_exec(_companyDB, delete_sql, NULL, NULL, &error);
//    [company.products removeObject:product];
//}
//
//#pragma mark -NSUserDefaults methods
//-(void) saveDefaultsWithCompanyList:(NSMutableArray*) companyList
//{
//    NSData *encodedData = [NSKeyedArchiver archivedDataWithRootObject:companyList];
//    self.userDefaults = [NSUserDefaults standardUserDefaults];
//    [self.userDefaults setObject:encodedData forKey:@"SAVEDCompaniesList"];
//    [self.userDefaults synchronize];
//    
//}
//
//
//-(void) loadDefaults
//{
//    self.userDefaults = [NSUserDefaults standardUserDefaults];
//    NSData *encodedData = [self.userDefaults objectForKey:@"SAVEDCompaniesList"];
//    NSMutableArray *savedCompaniesList = [NSKeyedUnarchiver unarchiveObjectWithData:encodedData];
//    self.companyList = savedCompaniesList;
//}
//
//
//#pragma mark- Update/Deleting Company/Product
//
//
//-(void) addProduct:(Product*)product forCurrentCompany: (Company*) company
//{
//    [company.products addObject:product];
//}
//
//-(void) removeProduct:(Product*)product forCurrentCompany: (Company*) company
//{
//    [company.products removeObject:product];
//}
//
//-(void) addCompany: (Company*) company
//{
//    [self.companyList addObject:company];
//    [self.companyNameList addObject:company.name];
//}
//
//-(void) removeCompany: (Company*) company
//{
//    [self.companyList removeObject:company];
//    [self.companyNameList removeObject:company.name];
//}


@end
