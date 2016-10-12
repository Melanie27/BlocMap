//
//  FilterByCategoryTableViewController.m
//  BlocSpot
//
//  Created by MELANIE MCGANNEY on 10/12/16.
//  Copyright © 2016 Bloc. All rights reserved.
//

#import "FilterByCategoryTableViewController.h"
#import "POICategory.h"
#import "PointOfInterest.h"
#import "BLSDataSource.h"

@interface FilterByCategoryTableViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *categories;
@end

@implementation FilterByCategoryTableViewController
static NSString *CellIdentifier = @"Cat Identifier";

//TODO MOVE THIS STUFF TO DATASOURCE ONCE IT IS WORKING
-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if(self) {
        //set title
        self.title = @"Filter by Category";
        
        //Load categories
        
        [self loadCategories];
    }
    
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
   
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
return [self.categories count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Dequeue Reusable Cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Fetch Item
    POICategory *category = [self.categories objectAtIndex:[indexPath row]];
    
    // Configure Cell
    [cell.textLabel setText:[category categoryName]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BLSDataSource *ds = [BLSDataSource sharedInstance];
    
    // Fetch Item
    POICategory *category = [self.categories objectAtIndex:[indexPath row]];
    NSLog(@"category %@", category.categoryName);
    
    ds.currentPOI.category = category;
    
    //grab all pois
    NSMutableArray *arrayOfPOIs = [[BLSDataSource sharedInstance] arrayOfPOIs];
    NSLog(@"array of pois %@", arrayOfPOIs);
    //get categoryname
    
    //check if the category name is equal to category variable
    
    //get all points of interest associated with this category
    
    
    
    //NSMutableArray *poisWithCategory = [NSMutableArray ]
    
    NSLog(@"current poi %@", ds.currentPOI);
    
    NSLog(@"perform filter on all points of interest with the selected category, dismiss the view controller, show the map with only the selected category markers");
    
    
    
}


-(void)loadCategories {
   
    NSString *filePath = [self pathForCategories];
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        self.categories = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    } else {
        self.categories = [NSMutableArray array];
    }
    
}

-(NSString*)pathForCategories {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths lastObject];
    return [documents stringByAppendingPathComponent:@"categories.poi"];
}

//GET THE COLORS INTO THE CELLS
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // Fetch Item
    POICategory *category = [self.categories objectAtIndex:[indexPath row]];
    cell.backgroundColor = category.categoryColor;
    
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
