//
//  ItemInputViewController.m
//  NavCtrl
//
//  Created by Aditya Narayan on 11/14/15.
//  Copyright © 2015 Aditya Narayan. All rights reserved.
//

#import "ItemInputViewController.h"
#import "ProductViewController.h"
#import "DAO.h"
#import <sqlite3.h>


@interface ItemInputViewController ()
@property (retain, nonatomic) IBOutlet UITextField *companyTextField;
@property (retain, nonatomic) IBOutlet UITextField *productTextField1;
@property (retain, nonatomic) IBOutlet UITextField *productTextField2;
@property (retain, nonatomic) IBOutlet UITextField *websiteTextField1;
@property (retain, nonatomic) IBOutlet UITextField *websiteTextField2;
@property (retain, nonatomic) IBOutlet UITextField *websiteTextField3;
@property (retain, nonatomic) IBOutlet UITextField *productTextField3;
@property (retain, nonatomic) IBOutlet UITextField *symbolTextField;
@property (strong, nonatomic) DAO *dao;

@end

@implementation ItemInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dao = [DAO sharedInstance];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




-(void) viewWillAppear:(BOOL)animated
{
    self.companyTextField.text = self.currentCompany.name;
    self.symbolTextField.text = self.currentCompany.symbol;
    
    NSInteger numberOfProducts = [self.currentCompany.products count];
    
    if (numberOfProducts > 0){
        self.productTextField1.text = [self.currentCompany.products [0] name];
    } else{
        self.productTextField1.text = nil;
    }
    if (numberOfProducts > 1) {
        self.productTextField2.text = [self.currentCompany.products [1] name];
    }else{
        self.productTextField2.text = nil;
    }
    if (numberOfProducts > 2){
        self.productTextField3.text = [self.currentCompany.products [2] name];
    }else{
        self.productTextField3.text = nil;
    }
    if (numberOfProducts > 0){
        self.websiteTextField1.text = [self.currentCompany.products [0] website];
    }else{
        self.websiteTextField1.text = nil;
    }
    
    if (numberOfProducts > 1){
        self.websiteTextField2.text = [self.currentCompany.products [1] website];

    }else{
        self.websiteTextField2.text = nil;
    }
    if (numberOfProducts > 2) {
        self.websiteTextField3.text = [self.currentCompany.products [2] website];

    }else{
        self.websiteTextField3.text = nil;
    }

    


}

- (IBAction)save:(id)sender
{
    Product *product1 = [[Product alloc] init];
    Product *product2 = [[Product alloc] init];
    Product *product3 = [[Product alloc] init];
    
    product1.name = self.productTextField1.text;
    product1.website = self.websiteTextField1.text;
    
    product2.name = self.productTextField2.text;
    product2.website = self.websiteTextField2.text;
    
    product3.name = self.productTextField3.text;
    product3.website = self.websiteTextField3.text;
    
    NSMutableArray *productsList = [NSMutableArray arrayWithObjects:product1, product2, product3, nil];

    self.currentCompany.products = productsList;
    
    
    self.currentCompany.name = self.companyTextField.text;
    self.currentCompany.symbol = self.symbolTextField.text;
    
//    [self.dao saveDefaultsWithCompanyList:self.dao.companyList];
    [self.dao updateCurrentCompany:self.currentCompany];

    
    self.companyTextField.text = nil;
    self.symbolTextField.text = nil;
    
    self.productTextField1.text = nil;
    self.productTextField2.text = nil;
    self.productTextField3.text = nil;
    
    self.websiteTextField1.text = nil;
    self.websiteTextField2.text = nil;
    self.websiteTextField3.text = nil;


    [self.navigationController popViewControllerAnimated:YES];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dealloc {
    [_companyTextField release];
    [_productTextField1 release];
    [_productTextField3 release];
    [_productTextField3 release];
    [_websiteTextField1 release];
    [_websiteTextField2 release];
    [_websiteTextField3 release];
    [_productTextField3 release];
    [_symbolTextField release];
    [super dealloc];
}
@end
