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
#import "MapViewController.h"

@interface FilterByCategoryTableViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *categories;
@end

@implementation FilterByCategoryTableViewController
static NSString *CellIdentifier = @"Cat Identifier";
//BLSDataSource *ds;
//TODO MOVE THIS STUFF TO DATASOURCE ONCE IT IS WORKING
-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if(self) {
        //set title
        self.title = @"Filter by Category";
        
        BLSDataSource *ds = [BLSDataSource sharedInstance];
        ds = [BLSDataSource sharedInstance];
        
        
    }
    
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    BLSDataSource *ds = [BLSDataSource sharedInstance];
    NSLog(@"Categories > %@", ds.arrayOfCategories);
    // Uncomment the following line to preserve selection between presentations.
    //self.clearsSelectionOnViewWillAppear = NO;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
    
    NSLog(@"array of pois %@", ds.arrayOfPOIs);
    // Create Add Button
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"No Filters" style:(UIBarButtonItemStylePlain) target:self action:@selector(removeFilters:)];
   
   
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)removeFilters:(id)sender {
    NSLog(@"unfilter");
    BLSDataSource *ds = [BLSDataSource sharedInstance];
    ds.filteredArrayOfPOIs = nil;
    [ds saveData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     BLSDataSource *ds = [BLSDataSource sharedInstance];
    return [ds.arrayOfCategories count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Dequeue Reusable Cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    BLSDataSource *ds = [BLSDataSource sharedInstance];
    // Fetch Item
    POICategory *category = [ds.arrayOfCategories objectAtIndex:[indexPath row]];
    
    // Configure Cell
    
    [cell.textLabel setText:[category categoryName]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {


    [tableView deselectRowAtIndexPath:indexPath animated:NO];
     BLSDataSource *ds = [BLSDataSource sharedInstance];
    //always set filtered set to nil here
    //ds.filteredArrayOfPOIs = nil;
   
    POICategory *category = [ds.arrayOfCategories objectAtIndex:[indexPath row]];
    
    self.currentlySelectedCategory = category;
    self.currentlySelectedCategory.categoryName= category.categoryName;
    

    NSSortDescriptor* categoryDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"categoryName" ascending:YES];
    NSArray *sortedByCategory = [ds.arrayOfPOIs sortedArrayUsingDescriptors:@[categoryDescriptor]];
     NSMutableArray *sortedMutable = [[NSMutableArray alloc] initWithArray:sortedByCategory];
    //NSLog(@"sort arr with Desc %@", sortedMutable);
    for (PointOfInterest *poi in sortedMutable) {
        //Get a filtered list out of the sorted POIS
        
        //NSPredicate *bPredicate = [NSPredicate predicateWithFormat:@"SELF.name contains[cd] %@",poi.category];
        //NSArray *filteredArray = [sortedByCategory filteredArrayUsingPredicate:bPredicate];
        //NSLog(@"HERE %@",filteredArray);
        
        
            if(self.currentlySelectedCategory == poi.category) {
                
                
                
                NSMutableArray *poisByCategory = [[NSMutableArray alloc] init];
                [poisByCategory addObject:poi];
                NSLog(@"pois by category %@", poisByCategory);
                ds.filteredArrayOfPOIs = poisByCategory;
                NSLog(@"filtered array %@", ds.filteredArrayOfPOIs);
            }
        
        
       
        
    }

    
    [ds saveData];
    
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
   BLSDataSource *ds = [BLSDataSource sharedInstance];
    POICategory *category = [ds.arrayOfCategories objectAtIndex:[indexPath row]];
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
