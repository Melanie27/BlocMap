//
//  SearchResultsTableViewController.m
//  BlocSpot
//
//  Created by MELANIE MCGANNEY on 9/22/16.
//  Copyright © 2016 Bloc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchResultsTableViewController.h"
#import "SearchResultsTableViewCell.h"
#import "BLSDataSource.h"
#import "MapViewController.h"
#import "PointOfInterest.h"
#import "POICategory.h"


@interface SearchResultsTableViewController () <UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource, SearchResultsTableViewCellDelegate>
@property (nonatomic, strong) MKLocalSearchResponse *results;

@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@end

@implementation SearchResultsTableViewController

//Override the table view controller's initializer to create an empty array
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Search Results";
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
     //[BLSDataSource sharedInstance].srtvc = self;
    [[BLSDataSource sharedInstance] addObserver:self forKeyPath:@"arrayOfPOIs" options:0 context:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    BLSDataSource *ds = [BLSDataSource sharedInstance];
    if([ds.filteredArrayOfPOIs count] > 0)  {
        //return 4;
        //appears to be returning the number of categories rather than the number of pois
        return [[BLSDataSource sharedInstance] filteredArrayOfPOIs].count;
    } else {
    
       return [[BLSDataSource sharedInstance] arrayOfPOIs].count;
    }

}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    //NSLog(@"show a detail view now");
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
   SearchResultsTableViewCell *resultCell = [tableView dequeueReusableCellWithIdentifier:@"resultCell" forIndexPath:indexPath];
    
    // Configure the cell...
     resultCell.delegate = self;
    
    BLSDataSource *ds = [BLSDataSource sharedInstance];
    // Fetch Item
    //Choose to display a filtered set or the entire thang
    if([ds.filteredArrayOfPOIs count] > 0 && [ds.filteredArrayOfPOIs count]> indexPath.row) {
       PointOfInterest *poi = [ds.filteredArrayOfPOIs objectAtIndex:[indexPath row]];
        resultCell.entryTitle.text = poi.title;
        resultCell.entrySubtitle.text = poi.subtitle;
        
        //TODO - don't show any other cats
    } else if ([ds.arrayOfPOIs count ]>  0 && [ds.filteredArrayOfPOIs count] < 1 && [ds.arrayOfPOIs count] > indexPath.row  ){
        PointOfInterest *poi = [ds.arrayOfPOIs objectAtIndex:[indexPath row]];
        resultCell.entryTitle.text = poi.title;
        resultCell.entrySubtitle.text = poi.subtitle;
    }
   
    
    
    
    
   
    
    return resultCell;
}




//Override the default height
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
    
}

/*-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"resultDetail"]) {
        //ResultsDetailViewController *resultDetailVC = (ResultsDetailViewController*)segue.destinationViewController;
       
        
    }
}*/

- (IBAction)backToResults:(UIStoryboardSegue *)segue {
    //[super.navigationController popViewControllerAnimated:YES];
    NSLog(@"go back to results");
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

- (void) dealloc {
    [[BLSDataSource sharedInstance] removeObserver:self forKeyPath:@"arrayOfPOIs"];
}




- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == [BLSDataSource sharedInstance] && [keyPath isEqualToString:@"arrayOfPOIs"]) {
        NSKeyValueChange kindOfChange = [change[NSKeyValueChangeKindKey] unsignedIntegerValue];
        
        if (kindOfChange == NSKeyValueChangeRemoval) {
            // Someone set a brand new images array
            [self.tableView reloadData];
        }
    }
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
       
        BLSDataSource *ds = [BLSDataSource sharedInstance];
        PointOfInterest *item = [ds.arrayOfPOIs objectAtIndex:[indexPath row]];
        [[BLSDataSource sharedInstance] deletePOIItem:item];
       
        
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
