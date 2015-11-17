//
//  DAO.m
//  NavCtrl
//
//  Created by Aditya Narayan on 11/14/15.
//  Copyright © 2015 Aditya Narayan. All rights reserved.
//

#import "DAO.h"

@interface DAO()


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

-(void) saveFileWithCompanyList: (NSMutableArray*) companyList
{
    
    NSData *encodedData = [NSKeyedArchiver archivedDataWithRootObject: companyList];
    
    [encodedData writeToFile:self.filePathString atomically:false];
}


-(void) loadFile
{
    NSError *error;
    NSData *encodedData = [[NSData alloc] initWithContentsOfFile:self.filePathString options:0 error:&error];
    NSMutableArray *savedCompanyList = [NSKeyedUnarchiver unarchiveObjectWithData:encodedData];
    self.companyList = savedCompanyList;
    
//    if (error){
//        NSLog(@"error loading url: %@", error);
//    } else {
//        NSMutableArray *savedCompanyList = [NSKeyedUnarchiver unarchiveObjectWithData:encodedData];
//        self.companyList = savedCompanyList;
//    }
}


-(void) createFileDirectory
{
    self.fileManager = [NSFileManager defaultManager];
    self.directoryPathString = @"/Users/adityanarayan/Desktop/Daniel Nomura/Section 3-2 2/File/holder";
    NSError *error;
    
    [self.fileManager createDirectoryAtPath:self.directoryPathString withIntermediateDirectories:false attributes:nil error:&error];
    
    if (error){
        NSLog(@"Error creating directory: %@", error.localizedDescription);
    }
    
    self.filePathString = [NSString stringWithFormat: @"%@/defaultFile", self.directoryPathString];

}

#pragma mark -NSUserDefaults methods
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
