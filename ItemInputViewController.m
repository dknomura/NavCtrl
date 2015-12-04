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
@property (retain, nonatomic) IBOutlet UITextField *productTextField3;

@property (retain, nonatomic) IBOutlet UITextField *websiteTextField1;
@property (retain, nonatomic) IBOutlet UITextField *websiteTextField2;
@property (retain, nonatomic) IBOutlet UITextField *websiteTextField3;

@property (strong, nonatomic) NSMutableArray *productTextFieldList;
@property (strong, nonatomic) NSMutableDictionary *textFieldsToUpdate;
@property (strong, nonatomic) NSMutableDictionary *textFieldsToAdd;

@property (strong, nonatomic) NSMutableArray *websiteTextFieldList;


@property (strong, nonatomic) DAO *dao;
@property (nonatomic) NSInteger numberOfProducts;

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
    
    self.numberOfProducts = [self.currentCompany.products count];
 
    self.productTextFieldList = [NSMutableArray arrayWithArray: @[self.productTextField1, self.productTextField2, self.productTextField3]];
    self.websiteTextFieldList= [NSMutableArray arrayWithArray:@[self.websiteTextField1, self.websiteTextField2, self.websiteTextField3]];
    
//    NSMutableArray *openingProductTextFieldList = [self.productTextFieldList copy];
//    NSMutableArray *openingWebsiteTextFieldList = [self.websiteTextFieldList copy];
//    
//    NSArray *arrayOfTextFieldArrays = @[openingProductTextFieldList, openingWebsiteTextFieldList];
//    for (NSMutableArray *array in arrayOfTextFieldArrays) {
//        for (UITextField *textField in array){
//            if (!textField.text){
//                [array removeObject:textField];
//            }
//        }
//    }
    
    self.textFieldsToAdd = [NSMutableDictionary new];
    self.textFieldsToUpdate = [NSMutableDictionary new];
    
    for (int i = 0; i < self.productTextFieldList.count; i++) {
        UITextField *productTextField = [self.productTextFieldList objectAtIndex:i];
        UITextField *websiteTextField = [self.websiteTextFieldList objectAtIndex:i];
        if (self.numberOfProducts > i){
            Product *currentProduct = self.currentCompany.products[i];
            productTextField.text = currentProduct.name;
            websiteTextField.text = currentProduct.website;
            [self.textFieldsToUpdate setObject:@[productTextField, websiteTextField] forKey:[NSNumber numberWithInt: i]];
        }
        else {
            [self.textFieldsToAdd setObject:@[productTextField, websiteTextField] forKey:[NSNumber numberWithInt: i]];
            productTextField.text = nil;
            websiteTextField.text = nil;
        }
    }
}


- (IBAction)save:(id)sender
{
//    NSMutableArray *productList = [NSMutableArray new];
    for (int i = 0; i < self.productTextFieldList.count; i++) {
        Product *newProduct = [[Product alloc] init];
        NSArray *arrayOfTextFieldsToUpdate = [self.textFieldsToUpdate objectForKey:[NSNumber numberWithInt: i]];
        NSArray *arrayOfTextFieldsToAdd = [self.textFieldsToAdd objectForKey:[NSNumber numberWithInt: i]];
        if (arrayOfTextFieldsToAdd){
            for (int i = 0; i < arrayOfTextFieldsToAdd.count; i++) {
                UITextField *textField = arrayOfTextFieldsToAdd[i];
                if (i == 0) newProduct.name = textField.text;
                if (i== 1) newProduct.website = textField.text;
            }
            [self.dao databaseAddProduct:newProduct fromCompany:self.currentCompany];
//            [productList addObject:newProduct];
        }else{
            Product *productToUpdate = [self.currentCompany.products objectAtIndex:i];
            UITextField *productTextFieldToUpdate = arrayOfTextFieldsToUpdate[0];
            UITextField *websiteTextFieldToUpdate = arrayOfTextFieldsToUpdate[1];
            [self.dao updateProduct:productToUpdate name: productTextFieldToUpdate.text andWebsite:websiteTextFieldToUpdate.text];
//            [productList addObject:productToUpdate];
        }

        UITextField *productTextField = self.productTextFieldList[i];
        UITextField *websiteTextField = self.websiteTextFieldList[i];
        productTextField.text = nil;
        websiteTextField.text = nil;
    }

//    self.currentCompany.products = productList;
    
    [self.dao updateCompany:self.currentCompany withName:self.companyTextField.text];

    self.companyTextField.text = nil;
    
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
    [super dealloc];
}
@end
