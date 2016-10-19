//
//  CategoryListViewController.m
//  BlocSpot
//
//  Created by MELANIE MCGANNEY on 9/30/16.
//  Copyright © 2016 Bloc. All rights reserved.
//

#import "CategoryListViewController.h"
#import "POICategory.h"
#import "MapViewController.h"
#import "PointOfInterest.h"
#import "BLSDataSource.h"
#import "POICategory.h"

@interface CategoryListViewController() <UITableViewDelegate, UITableViewDataSource, AddCategoryViewControllerDelegate>

//add private mutable array
//@property (nonatomic, strong) NSMutableArray *categories;

@end

@implementation CategoryListViewController

static NSString *CellIdentifier = @"Cell Identifier";
BLSDataSource *ds;

//TODO MOVE THIS STUFF TO DATASOURCE ONCE IT IS WORKING
-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if(self) {
        //set title
        self.title = @"Categories";
        
        //Load categories
        ds = [BLSDataSource sharedInstance];

        //[self loadCategories];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"Categories > %@", ds.arrayOfCategories);
    // Register Class for Cell Reuse
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
    
    // Create Add Button
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addItem:)];
    
    // Create Add Button
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    
    
}

- (void)addItem:(id)sender {
    //NSLog(@"Button was tapped.");
    [self performSegueWithIdentifier:@"AddCategoryViewController" sender:self];
}

-(void)back:(id)sender {
    
    //[super.navigationController popViewControllerAnimated:YES];
    //[self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
    NSLog(@"go back");
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
   
    if([segue.identifier isEqualToString:@"AddCategoryViewController"]) {
            AddCategoryViewController *addCategoryVC = (AddCategoryViewController*)segue.destinationViewController;
            [addCategoryVC setDelegate:self];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [ds.arrayOfCategories count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    // Fetch Item
    POICategory *category = [ds.arrayOfCategories objectAtIndex:[indexPath row]];
    NSLog(@"category %@", category.categoryName);
    ds.currentPOI.category = category;
    //Get POI
    PointOfInterest *poi = [ds.arrayOfPOIs objectAtIndex:[indexPath row]];
    ds.currentPOI = poi;
    
    
    //Save the category selected to the POI
    //NSSet *setCategoryItem = [NSSet setWithObjects:category, nil];
   
    //save POI to category
    //save the current POI to the the current category
    //get current POI
     NSLog(@"current poi to be saved to this category %@", ds.currentPOI);
    NSLog(@"current poi title %@", ds.currentPOI.title);
    NSLog(@"current poi subtitle %@", ds.currentPOI.subtitle);
     NSLog(@"current cat  %@", ds.currentPOI.category);
    //NSLog(@"current cat name %@", ds.currentPOI.categoryName);
    //NSLog(@"current cat color %@", ds.currentPOI.categoryColor);
    NSLog(@"current poi cat %@", ds.currentPOI.category);
    
    
    //TODO change this to an NSSet so it doesn't get double saved
    //[ds savePOIToCategory:poi];
    //[ds saveCategoryToPOI:category];
    //[ds savePOIToCategory:poi];
    [ds saveCategoryToPOI:category];
    [ds saveData];
    

}

-(NSIndexPath*)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSIndexPath *oldIndex = [self.tableView indexPathForSelectedRow];
    [self.tableView cellForRowAtIndexPath:oldIndex].accessoryType = UITableViewCellAccessoryNone;
    [self.tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    return indexPath;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Dequeue Reusable Cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Fetch Item
    POICategory *category = [ds.arrayOfCategories objectAtIndex:[indexPath row]];
    
    // Configure Cell
    [cell.textLabel setText:[category categoryName]];
    
    return cell;
}



//returns the path to the file containing the application's list of categories by appending a string to the path of the documents directory.
-(NSString*)pathForCategories {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths lastObject];
    
    return [documents stringByAppendingPathComponent:@"categories.poi"];
}


-(void)saveCategories {
    [[BLSDataSource sharedInstance]saveData];
    
    //NSString *filePath = [self pathForCategories];
    //[NSKeyedArchiver archiveRootObject:self.categories toFile:filePath];
}


- (NSString *)documentsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths lastObject];
}

- (void)controller:(AddCategoryViewController *)controller didSaveCategoryWithName:(NSString *)name andColor:(UIColor*)color {
    // Create Category
    POICategory *category = [POICategory createCategoryWithName:name andColor:color];
    //NSLog(@"color once back in table %@", color);
    BLSDataSource *ds = [BLSDataSource sharedInstance];
    
    // Add Item to Data Source
    if (![ds.arrayOfCategories containsObject:category])
        [ds.arrayOfCategories addObject:category];
    
    ds.currentPOI.category = category; 
    
    // Save Items
    [self saveCategories];
    
    // Add Row to Table View
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:([ds.arrayOfCategories count] - 1) inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    
}

//GET THE COLORS INTO THE CELLS
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // Fetch Item
    POICategory *category = [ds.arrayOfCategories objectAtIndex:[indexPath row]];
    cell.backgroundColor = category.categoryColor;
   
}

//Swipe to delete
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the category from the data source
        POICategory *category = [ds.arrayOfCategories objectAtIndex:[indexPath row]];
        [ds.arrayOfCategories removeObject:category];
        
        //TODO fix category deletion
        //NSArray *categories = [NSArray arrayWithObjects:self.categories, nil];
        //[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        NSIndexPath *deleteIndexPath = [NSIndexPath indexPathForItem:([ds.arrayOfCategories count] - 1) inSection:0];
        [self.tableView deleteRowsAtIndexPaths:@[deleteIndexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
}





@end
