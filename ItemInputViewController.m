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

@interface ItemInputViewController ()
@property (retain, nonatomic) IBOutlet UITextField *companyTextField;
@property (retain, nonatomic) IBOutlet UITextField *productTextField1;
@property (retain, nonatomic) IBOutlet UITextField *productTextField2;
@property (retain, nonatomic) IBOutlet UITextField *websiteTextField1;
@property (retain, nonatomic) IBOutlet UITextField *websiteTextField2;
@property (retain, nonatomic) IBOutlet UITextField *websiteTextField3;
@property (retain, nonatomic) IBOutlet UITextField *productTextField3;
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
    self.productTextField1.text = [self.currentCompany.products [0] name];
    self.productTextField2.text = [self.currentCompany.products [1] name];
    self.productTextField3.text = [self.currentCompany.products [2] name];
    
    self.websiteTextField1.text = [self.currentCompany.products [0] website];
    self.websiteTextField2.text = [self.currentCompany.products [1] website];
    self.websiteTextField3.text = [self.currentCompany.products [2] website];

    


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
    
    NSMutableArray *products = [NSMutableArray arrayWithObjects:product1, product2, product3, nil];

    [self.dao updateProductsForCompany:self.currentCompany toProducts:products];
    
    [self.dao updateNameForCompany:self.currentCompany toString:self.companyTextField.text];
    
    
    
    self.companyTextField.text = nil;
    self.productTextField1.text = nil;
    self.productTextField2.text = nil;
    self.productTextField3.text = nil;
    
    self.websiteTextField1.text = nil;
    self.websiteTextField2.text = nil;
    self.websiteTextField3.text = nil;


    [self.navigationController popViewControllerAnimated:YES];

    ////    if ([[self.navigationController presentingViewController] isKindOfClass: [ProductViewController class]]){
    ////        NSString *currentCompanyString = [NSString stringWithString:self.title];
    ////        Company *currentCompany = [[Company alloc] init];
    ////
    //
    //
    //
    //    BOOL isCompanyNew = TRUE;
    //    BOOL isProductNew = TRUE;
    //
    //
    //    if (![self.companyTextField.text isEqualToString:@""]){
    //        for (Company *company in self.dao.companyNameList){
    //            if(company.name == self.companyTextField.text){
    //                isCompanyNew = FALSE;
    //                currentCompany = company;
    //            }
    //        }
    //        if (isCompanyNew){
    //            newCompany.name = self.companyTextField.text;
    //            [self.dao addCompany:newCompany];
    //            currentCompany = newCompany;
    //        }
    //        isCompanyNew = TRUE;
    //    }
    //
    //    if (![self.productTextField1.text isEqualToString:@""]){
    //        if (![self.websiteTextField1.text isEqualToString:@""]){
    //            newProduct1.website = self.websiteTextField1.text;
    //        }
    //        for (Product *product in currentCompany.products){
    //            if(product.name == self.productTextField1.text){
    //                isProductNew = FALSE;
    //                if (![self.websiteTextField1.text isEqualToString:@""]){
    //                    [self.dao addProduct:product forCurrentCompany:currentCompany];
    //                }
    //            }
    //            if (isProductNew){
    //                newProduct1.name = self.productTextField1.text;
    //            }
    //    
    //        }
    //
    //    }

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
    [super dealloc];
}
@end
