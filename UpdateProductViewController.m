//
//  UpdateProductViewController.m
//  NavCtrl
//
//  Created by Aditya Narayan on 11/15/15.
//  Copyright © 2015 Aditya Narayan. All rights reserved.
//

#import "UpdateProductViewController.h"
#import <sqlite3.h>


@interface UpdateProductViewController ()
@property (retain, nonatomic) IBOutlet UITextField *productTextField;
@property (retain, nonatomic) IBOutlet UITextField *websiteTextField;
@property (strong, nonatomic) DAO *dao;

@end

@implementation UpdateProductViewController

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
    self.productTextField.text = self.currentProduct.name;
    self.websiteTextField.text = self.currentProduct.website;
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
    [_productTextField release];
    [_websiteTextField release];
    [super dealloc];
}
- (IBAction)save:(id)sender
{
    self.currentProduct.name = self.productTextField.text;
    self.currentProduct.website = self.websiteTextField.text;
    
//    [self.dao saveDefaultsWithCompanyList:self.dao.companyList];
    [self.dao updateCurrentProduct:self.currentProduct forCurrentCompany:self.currentCompany];

    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}
@end
