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
    
     [BLSDataSource sharedInstance].srtvc = self;
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

    MKLocalSearchResponse *results = [[BLSDataSource sharedInstance] results];
   
   
    return [results.mapItems count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MKLocalSearchResponse *results = [[BLSDataSource sharedInstance] results];
   SearchResultsTableViewCell *resultCell = [tableView dequeueReusableCellWithIdentifier:@"resultCell" forIndexPath:indexPath];
    resultCell.delegate = self;
    // Configure the cell...
    
    MKMapItem *item = results.mapItems[indexPath.row];
    //NSLog(@"table item %@", item);
    //resultCell.textLabel.text = item.name;
    //resultCell.detailTextLabel.text = item.placemark.addressDictionary[@"Street"];
    resultCell.detailTextLabel.text = item.phoneNumber;
    resultCell.entryTitle.text = item.name;
    resultCell.entrySubtitle.text = item.phoneNumber;
    
    //accessory button to a popup
    UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [button addTarget:self action:@selector(didTapResultDetail:) forControlEvents:UIControlEventTouchDown];
    button.tag = indexPath.row;
    resultCell.accessoryView = button;
    //when adding the category images
    //[resultCell.contentView addSubview:resultCell.catPhoto];
    //resultCell.catPhoto.tag = indexPath.row;
    
    return resultCell;
}

#pragma mark - QuestionsTableViewCellDelegate
- (IBAction)didTapResultDetail:(id)sender {
    
    NSLog(@"will show the detail view here");
    //BLSDataSource *ds = [BLSDataSource sharedInstance];
    
    //UIButton *theButton = (UIButton *)sender;
    //self.questionAddingTo = [BLDataSource sharedInstance].questions[theButton.tag];
    //ds.detailNumber = theButton.tag;
    //ds.question = self.questionAddingTo;
    
    //[self performSegueWithIdentifier:@"resultDetail" sender:self];
    
}


//Override the default height
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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
