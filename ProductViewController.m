//
//  ProductViewController.m
//  NavCtrl
//
//  Created by Aditya Narayan on 10/22/13.
//  Copyright (c) 2013 Aditya Narayan. All rights reserved.
//

#import "ProductViewController.h"
#import <WebKit/WebKit.h>
#import "UpdateProductViewController.h"
#import <sqlite3.h>



@interface ProductViewController ()

@property (strong, nonatomic) NSMutableDictionary *companyAndCompanyNamesDictionary;
@property (strong, nonatomic) DAO *dao;
@property (retain, nonatomic) IBOutlet UpdateProductViewController *productUpdateController;
@property (strong, nonatomic) UIBarButtonItem *undoButton;



@end

@implementation ProductViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dao = [DAO sharedInstance];
    
    
//    [self.dao.managedObjectContext.undoManager registerUndoWithTarget:self handler:^(id  _Nonnull target) {
//        NSLog(@"Undo done");
//    }];
    
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
    
    
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    NSMutableArray *companyNameList = [NSMutableArray new];
//    
//    for (Company *company in self.dao.companyList){
//        [companyNameList addObject:company.name];
//    }
//    
//    self.companyAndCompanyNamesDictionary = [NSMutableDictionary dictionaryWithObjects: self.dao.companyList forKeys:companyNameList];
//    
//    self.currentCompany = [self.companyAndCompanyNamesDictionary objectForKey:self.title];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.currentCompany.products count];
}

-(void) handleLongTouchGesture: (UILongPressGestureRecognizer*) gesture
{
    if (gesture.state == UIGestureRecognizerStateEnded){
        NSIndexPath *currentIndexPath = [self.tableView indexPathForRowAtPoint:[gesture locationInView:self.tableView]];
        UITableViewCell *currentCell = [self.tableView cellForRowAtIndexPath: currentIndexPath ];
        if (currentCell.textLabel.text){
            self.productUpdateController.title = [NSString stringWithFormat:@"Update %@", currentCell.textLabel.text];
            for (Product *product in self.currentCompany.products){
                if([product.name isEqualToString: currentCell.textLabel.text]){
                    self.productUpdateController.currentProduct = product;
                }
            }
        } else {
            self.productUpdateController.title = @"Update Product";
        }
        self.productUpdateController.currentCompany = self.currentCompany;
        
        [self.navigationController pushViewController:self.productUpdateController animated:YES];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongTouchGesture:)];
    [cell addGestureRecognizer:longPressRecognizer];
    longPressRecognizer.allowableMovement = 2;
    
    cell.textLabel.text = [[self.currentCompany.products objectAtIndex: indexPath.row] name];
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


-(UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.currentCompany.products count]- 1 == indexPath.row)
    {
        return UITableViewCellEditingStyleInsert;
    }else
        return  UITableViewCellEditingStyleDelete;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        Product *productToRemove = [self.currentCompany.products objectAtIndex:indexPath.row];
//        [self.dao saveDefaultsWithCompanyList:self.dao.companyList];
        [self.dao deleteProduct:productToRemove forCompany:self.currentCompany];

        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        Product *product = [[Product alloc] init];
        product.name = @"New Product";
        //        Product *newProduct = [product mutableCopy];
        [self.dao addProduct:product forCompany:self.currentCompany];
//        [self.dao saveDefaultsWithCompanyList:self.dao.companyList];
        [tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}



// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    
    Product *productToMove = self.currentCompany.products[fromIndexPath.row];
    [self.currentCompany.products removeObjectAtIndex:fromIndexPath.row];
    [self.currentCompany.products insertObject:productToMove atIndex:toIndexPath.row];
    [self.dao updateProductIndicesForCurrentCompany:self.currentCompany];

}



// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}

#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    
    NSURL *url = [NSURL URLWithString:[[self.currentCompany.products objectAtIndex:indexPath.row] website]];
    
    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.frame];
    NSURLRequest *request = [NSURLRequest requestWithURL: url];
    
    [webView loadRequest:request];
    
    
    UIViewController *webViewController = [[UIViewController alloc] init];
    
    webViewController.view = webView;
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:webViewController animated:YES];
}

-(void) setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:YES];
    
    self.undoButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemUndo target:self action:@selector(undoLastAction)];
    
    if (editing){
        self.navigationItem.leftBarButtonItem = self.undoButton;
    } else {
        self.navigationItem.leftBarButtonItem = self.navigationItem.backBarButtonItem;
    }
}

-(void)undoLastAction
{
    //    [self.dao.managedObjectContext.undoManager undoNestedGroup];
    [self.dao.managedObjectContext.undoManager undo];
    [self.dao loadCompanyListFromFetchedResults];
    
    for (Company *company in self.dao.companyList){
        if ([company.name isEqualToString:self.currentCompany.name]){
            self.currentCompany = company;
            break;
        }
    }
    
    [self.tableView reloadData];
}


- (void)dealloc {
//    [_productUpdateController release];
//    [super dealloc];
}
@end
