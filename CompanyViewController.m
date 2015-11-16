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

@interface CompanyViewController ()
@property (strong, nonatomic) DAO* dao;
@property (strong, nonatomic) UIBarButtonItem *addButton;
@property (retain, nonatomic) IBOutlet ItemInputViewController *itemInputController;
@property BOOL addButtonHit;

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
    
    
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
    
    [self setStockQuotes];
    
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
-(void) setStockQuotes
{
    
    
    
    NSURL *url = [NSURL URLWithString:@"https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.quotes%20where%20symbol%20in%20(%22aapl%22%2C%22msft%22%2C%22sne%22%2C%22SSNLF%22)&format=json&diagnostics=true&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback="];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * data, NSURLResponse * response, NSError * error) {
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if (error){
            NSLog(@"Error with json get request: %@", error.localizedDescription);
            abort();
        }
        NSDictionary *resultsDictionary = [[jsonDictionary objectForKey:@"query"] objectForKey:@"results"];
        NSArray *quotesArray = [resultsDictionary objectForKey:@"quote"];
        
        self.dao.apple.stockQuote = [[StockQuote alloc] init];
        self.dao.sony.stockQuote = [[StockQuote alloc] init];
        self.dao.windows.stockQuote = [[StockQuote alloc] init];
        self.dao.samsung.stockQuote = [[StockQuote alloc] init];
        
        self.dao.apple.stockQuote.symbol = [quotesArray[0] objectForKey:@"symbol"];
        self.dao.apple.stockQuote.quote = [quotesArray[0] objectForKey:@"LastTradePriceOnly"];
        self.dao.apple.stockQuote.change = [quotesArray[0] objectForKey:@"Change"];
        
        self.dao.windows.stockQuote.symbol = [quotesArray[1] objectForKey:@"symbol"];
        self.dao.windows.stockQuote.quote = [quotesArray[1] objectForKey:@"LastTradePriceOnly"];
        self.dao.windows.stockQuote.change = [quotesArray[1] objectForKey:@"Change"];
        
        self.dao.sony.stockQuote.symbol = [quotesArray[2] objectForKey:@"symbol"];
        self.dao.sony.stockQuote.quote = [quotesArray[2] objectForKey:@"LastTradePriceOnly"];
        self.dao.sony.stockQuote.change = [quotesArray[2] objectForKey:@"Change"];
        
        self.dao.samsung.stockQuote.symbol = [quotesArray[3] objectForKey:@"symbol"];
        self.dao.samsung.stockQuote.quote = [quotesArray[3] objectForKey:@"LastTradePriceOnly"];
        self.dao.samsung.stockQuote.change = [quotesArray[3] objectForKey:@"Change"];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        
    }];
    [task resume];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
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
    if (currentCompany.stockQuote.quote){
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %@", currentCompany.stockQuote.quote, currentCompany.stockQuote.change];
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
        [self.dao.companyList removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        Company *company = [[Company alloc]init];
        company.name = @"New Company";
        Company *newCompany = [company mutableCopy];
        [self.dao addCompany:newCompany];
        [tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
}


// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
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
    
    self.productViewController.title = [[self.dao.companyList objectAtIndex:indexPath.row] name];
    
    [self.navigationController
     pushViewController:self.productViewController
     animated:YES];
    
    
}

#pragma mark - addButton Methods

//-(void) setEditing:(BOOL)editing animated:(BOOL)animated
//{
//    [super setEditing:editing animated:animated];
//    [self.tableView setEditing:editing animated:YES];
//
//    self.addButton= [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addItem:)];
//
//
////    if (editing){
////        self.navigationItem.leftBarButtonItem = self.addButton;
////    } else {
////        self.navigationItem.leftBarButtonItem = self.navigationItem.backBarButtonItem;
////    }
//}




- (void)dealloc {
    [_companyInputViewController release];
    [_itemInputController release];
    [super dealloc];
}
@end
