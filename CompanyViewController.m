//
//  CompanyViewController.m
//  NavCtrl
//
//  Created by Aditya Narayan on 10/22/13.
//  Copyright (c) 2013 Aditya Narayan. All rights reserved.
//

#import "CompanyViewController.h"
#import "ProductViewController.h"
#import "ItemInputViewController.h"
#import <sqlite3.h>

@interface CompanyViewController (){
    int newCompanyID;
}
@property (strong, nonatomic) DAO* dao;
@property (strong, nonatomic) UIBarButtonItem *undoButton;
@property (retain, nonatomic) IBOutlet ItemInputViewController *itemInputController;

@end

@implementation CompanyViewController

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
    
    self.title = @"Mobile device makers";
    

}


-(void) viewWillAppear:(BOOL)animated
{
    [self setStockQuotes];
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
    return [self.dao.companyList count];
}

-(void) handleLongTouchGesture: (UILongPressGestureRecognizer*) gesture
{
    if (gesture.state == UIGestureRecognizerStateEnded){
        NSIndexPath *currentIndexPath = [self.tableView indexPathForRowAtPoint:[gesture locationInView:self.tableView]];
        UITableViewCell *currentCell = [self.tableView cellForRowAtIndexPath: currentIndexPath ];
        if (currentCell.textLabel.text){
            self.itemInputController.title = [NSString stringWithFormat:@"Update %@", currentCell.textLabel.text];
            for (Company *company in self.dao.companyList){
                if([company.name isEqualToString: currentCell.textLabel.text]){
                    self.itemInputController.currentCompany = company;
                }
            }
        } else {
            self.itemInputController.title = @"Update Company";
        }
        
        [self.navigationController pushViewController:self.itemInputController animated:YES];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongTouchGesture:)];
    [cell addGestureRecognizer:longPressRecognizer];
    longPressRecognizer.allowableMovement = 2;
    
    
    Company *currentCompany = [self.dao.companyList objectAtIndex:[indexPath row]];
    
    cell.textLabel.text = currentCompany.name;
    if (currentCompany.stockQuote){
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@: %@, %@", currentCompany.symbol, currentCompany.stockQuote, currentCompany.change];
    }else {
        cell.detailTextLabel.text = @"No stock information available";
    }
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@ icon.png", currentCompany.name]];

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
    if ([self.dao.companyList count]- 1 == indexPath.row)
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
        Company *companyToRemove = [self.dao.companyList objectAtIndex:indexPath.row];
        [self.dao deleteCompany:companyToRemove];
     //   [self.dao updateCompanyList];
//        [self.dao saveDefaultsWithCompanyList:self.dao.companyList];

        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        Company *companyToAdd = [[Company alloc]init];
        companyToAdd.name = @"NewCompany";
        
        for (Company *company in self.dao.companyList){
            if ([companyToAdd.name isEqualToString:company.name]){
                companyToAdd.name = [NSString stringWithFormat:@"NewCompany%d", newCompanyID];
                newCompanyID++;
            }
        }
//        [self.dao saveDefaultsWithCompanyList:self.dao.companyList];
        [self.dao addCompany:companyToAdd];

        //      [self.dao updateCompanyList];
        [tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
}


// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    Company *companyToMove = self.dao.companyList [fromIndexPath.row];
    [self.dao.companyList removeObjectAtIndex:fromIndexPath.row];
    [self.dao.companyList insertObject:companyToMove atIndex:toIndexPath.row];
    [self.dao updateCompanyIndices];
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
    Company *currentCompany = [self.dao.companyList objectAtIndex:indexPath.row];
    
    self.productViewController.title = currentCompany.name;
    self.productViewController.currentCompany = currentCompany;
    
    [self.navigationController
     pushViewController:self.productViewController
     animated:YES];    
}

#pragma mark - addButton Methods

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
//    [self.dao.managedObjectContext.undoManager endUndoGrouping];
    //    [self.dao.managedObjectContext.undoManager undoNestedGroup];
    [self.dao.managedObjectContext.undoManager undo]; 
    [self.dao loadCompanyListFromFetchedResults];
    [self setStockQuotes];
    [self.tableView reloadData];

//    if (self.dao.managedObjectContext.undoManager.groupingLevel != 0) {
//        
//        [self.dao.managedObjectContext.undoManager endUndoGrouping];
//        //    [self.dao.managedObjectContext.undoManager undoNestedGroup];
//        [self.dao.managedObjectContext.undoManager undo];
//        
//        NSFetchRequest *testFetch = [NSFetchRequest fetchRequestWithEntityName:@"CompanyMO"];
//        NSSortDescriptor *sortByIndex = [NSSortDescriptor sortDescriptorWithKey:@"index" ascending:true];
//        testFetch.sortDescriptors = @[sortByIndex];
//        NSArray *testArray = [self.dao.managedObjectContext executeFetchRequest:testFetch error:nil];
//        NSLog(@"%@", testArray);
//
//        
//        [self.dao loadCompanyListFromFetchedResults];
//        [self setStockQuotes];
//        [self.tableView reloadData];
//    }
//    [self.dao.managedObjectContext.undoManager beginUndoGrouping];

}


-(void) setStockQuotes
{
    NSMutableString *stockSymbolInURL = [NSMutableString new];
    
    for (int i = 0; i < [self.dao.companyList count]; i++){
        
        [stockSymbolInURL appendString: @"%22"];
        if ([self.dao.companyList[i] symbol]){
            [stockSymbolInURL appendString:[NSString stringWithFormat:@"%@", [self.dao.companyList[i] symbol]]];
        } else {
            [stockSymbolInURL appendString:[NSString stringWithFormat:@"%@", [self.dao.companyList[i] uniqueID]]];
        }
        if (i == [self.dao.companyList count] - 1){
            [stockSymbolInURL appendString:@"%22"];
        } else {
            [stockSymbolInURL appendString:@"%22%2C"];
        }
    }
    
    
    NSMutableString *urlString = [NSMutableString stringWithString:@"https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.quotes%20where%20symbol%20in%20("];
    [urlString appendString:stockSymbolInURL];
    [urlString appendString:@")&format=json&diagnostics=true&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback="];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * data, NSURLResponse * response, NSError * error) {
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        if (error){
            NSLog(@"Error with json get request: %@", error.localizedDescription);
            abort();
        }
        NSDictionary *resultsDictionary = [[jsonDictionary objectForKey:@"query"] objectForKey:@"results"];
        NSArray *quotesArray = [resultsDictionary objectForKey:@"quote"];
        
        for (int i = 0; i< [self.dao.companyList count]; i++){
            Company *company = self.dao.companyList[i];
            company.symbol = [quotesArray[i] objectForKey:@"symbol"];
            company.stockQuote = [quotesArray[i] objectForKey:@"LastTradePriceOnly"];
            company.change = [quotesArray[i] objectForKey:@"Change"];
//            for (CompanyMO *companyMO in companyMOList){
//                if ([company.name isEqualToString:companyMO.name]){
//                    if ([company.symbol isKindOfClass:[NSString class]]) {
//                        companyMO.symbol = company.symbol;
//                    }
//                }
//            }
        }

        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        
    }];
    [task resume];
}




- (void)dealloc {
    [_companyInputViewController release];
    [_itemInputController release];
    [super dealloc];
}
@end
