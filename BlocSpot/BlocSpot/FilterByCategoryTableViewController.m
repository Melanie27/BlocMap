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
    NSLog(@"for heavens sake just look at all of them");
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
   
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    BLSDataSource *ds = [BLSDataSource sharedInstance];
    POICategory *category = [ds.arrayOfCategories objectAtIndex:[indexPath row]];
    self.currentlySelectedCategory = category;
    self.currentlySelectedCategory.categoryName= category.categoryName;
    NSLog(@"tapped cat  %@", self.currentlySelectedCategory);
    NSLog(@"tapped cat name %@", self.currentlySelectedCategory.categoryName);
   
    NSMutableArray *newlySelectedArrayOfPOIs = [[NSMutableArray alloc]init];
    if (newlySelectedArrayOfPOIs == nil) {
        newlySelectedArrayOfPOIs = [NSMutableArray arrayWithCapacity:100];
    }
    
    
    
    //STEPS
    // NSString *savedPOICategofyNames =  poi.categoryName;
    //NSLog(@"list of saved poi category names, %@", savedPOICategofyNames);
    // 1 get the category name of the poi
    // 2 compare the category name to the currentlySelectedCategory name
    // if 1 and 2 match, show those pois in the map and table
    // if one and 2 do not match hide the relevant pois
   
    
    for (PointOfInterest *poi in ds.arrayOfPOIs) {
       // NSLog(@"current cat %@",self.currentlySelectedCategory);
        //NSLog(@"poi after  %@", poi.category.categoryName);
        //NSLog(@"in loop array of pois %@", ds.arrayOfPOIs);
        if(self.currentlySelectedCategory == poi.category) {
            NSLog(@"each poi that matches %@", poi);
            
            //PRint a list of the POIS that meet this critera
            PointOfInterest *matchingItem = [[PointOfInterest alloc] init];
            [newlySelectedArrayOfPOIs addObject:matchingItem];
            NSLog(@"new array %@", newlySelectedArrayOfPOIs);
            //NSLog(@"matching item %@", matchingItem);
            ds.arrayOfPOIs = newlySelectedArrayOfPOIs;
            
            
            //SAVE FILTERED DATA
            //NEED TO CAPTURE THIS DATA IN THE MODEL
            //NEED TO UPDATE THE RESULTS TABLE VIEW
            
            
            
        //} else if (self.currentlySelectedCategory != poi.category){
            
            //PointOfInterest *hiddenItem = [[PointOfInterest alloc] init];
            //[newlyHiddenArrayOfPOIs addObject:hiddenItem];
            //ds.arrayOfPOIs = newlySelectedArrayOfPOIs;
            //NSLog(@"newly hidden %@",newlyHiddenArrayOfPOIs);
            
            
            //for (int i=0; i<[newlyHiddenArrayOfPOIs count]; i++) {
                ///for each newlyhiddenarray hide the pin
                //delegate?
            //}

            
            
        }
        
        
    }
    
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
