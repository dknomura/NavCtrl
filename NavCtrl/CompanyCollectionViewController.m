//
//  CompanyCollectionViewController.m
//  NavCtrl
//
//  Created by Aditya Narayan on 11/30/15.
//  Copyright © 2015 Aditya Narayan. All rights reserved.
//


#import "CompanyCollectionViewController.h"
#import "ProductViewController.h"
#import "ItemInputViewController.h"
#import "CollectionViewCellWithLabel.h"


@interface CompanyCollectionViewController ()
@property (strong, nonatomic) DAO* dao;
@property (strong, nonatomic) UIBarButtonItem *undoButton;
@property (retain, nonatomic) IBOutlet ItemInputViewController *itemInputController;
@end

@implementation CompanyCollectionViewController

static NSString * const reuseIdentifier = @"cvCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
//    
//    CollectionViewCellWithLabel *collectionViewCellWithLabel = [[CollectionViewCellWithLabel alloc] initWithFrame:self.collectionView.frame];
    
    [self.collectionView registerClass:[CollectionViewCellWithLabel class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
    
    self.dao = [DAO sharedInstance];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.title = @"Mobile Device Makers";
}

-(void) viewWillAppear:(BOOL)animated
{
    [self setStockQuotes];
    [self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
#warning Incomplete implementation, return the number of sections
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of items
    return [self.dao.companyList count];
}

//-(void) handleLongTouchGesture: (UILongPressGestureRecognizer*) gesture
//{
//    if (gesture.state == UIGestureRecognizerStateEnded){
//        NSIndexPath *currentIndexPath = [self.collectionView indexPathForRowAtPoint:[gesture locationInView:self.collectionView]];
//        CollectionViewCellWithLabel *currentCell = [self.collectionView cellForItemAtIndexPath:currentIndexPath];
//        
//        self.itemInputController.title = [NSString stringWithFormat:@"Update %@", currentCell.companyNameLabel.text];
//        
//        for (Company *company in self.dao.companyList){
//            if([company.name isEqualToString: currentCell.companyNameLabel.text]){
//                self.itemInputController.currentCompany = company;
//                
//        [self.navigationController pushViewController:self.itemInputController animated:YES];
//            }
//        }
//    }
//}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCellWithLabel *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
//    UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongTouchGesture:)];
//    [cell addGestureRecognizer:longPressRecognizer];
//    longPressRecognizer.allowableMovement = 2;
    
    Company *currentCompany = [self.dao.companyList objectAtIndex:[indexPath row]];
    
    cell.companyNameLabel.text = currentCompany.name;
    if (currentCompany.stockQuote){
        cell.stockLabel.text = [NSString stringWithFormat:@"%@: %@, %@", currentCompany.symbol, currentCompany.stockQuote, currentCompany.change];
    } else {
        cell.stockLabel.text = @"No stock information available";
    }
    cell.iconImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@ icon.png", currentCompany.name]];

    return cell;
}


-(BOOL) collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void) collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    Company *companyToMove = self.dao.companyList [sourceIndexPath.row];
    [self.dao.companyList removeObjectAtIndex:sourceIndexPath.row];
    [self.dao.companyList insertObject:companyToMove atIndex:destinationIndexPath.row];
    [self.dao updateCompanyIndices];
}


-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Company *currentCompany = [self.dao.companyList objectAtIndex:indexPath.row];
    
    self.productCollectionViewController = [[ProductCollectionViewController alloc] init];
    
    
    self.productCollectionViewController.currentCompany = currentCompany;
    
    [self.navigationController
     pushViewController:self.productCollectionViewController
     animated:YES];
}


#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

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
            [self.collectionView reloadData];
        });
        
    }];
    [task resume];
}


@end
