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
@property (nonatomic, strong) NSMutableArray *categories;

@end

@implementation CategoryListViewController

static NSString *CellIdentifier = @"Cell Identifier";

//TODO MOVE THIS STUFF TO DATASOURCE ONCE IT IS WORKING
-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if(self) {
        //set title
        self.title = @"Categories";
        
        //Load categories
         //[self seedCategories];
        [self loadCategories];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"Categories > %@", self.categories);
    // Register Class for Cell Reuse
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
    
    // Create Add Button
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addItem:)];
    
    // Create Add Button
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    self.navigationItem.leftBarButtonItem = backButton;
    
  
    
}

- (void)addItem:(id)sender {
    NSLog(@"Button was tapped.");
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
    return [self.categories count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BLSDataSource *ds = [BLSDataSource sharedInstance];
    
    // Fetch Item
    POICategory *category = [self.categories objectAtIndex:[indexPath row]];
    NSLog(@"category %@", category.categoryName);
    
    ds.currentPOI.category = category;
    
    //Save the category selected to the POI
    NSArray *arrayCategoryItem = [NSArray arrayWithObjects:category, nil];
    [ds saveCategoryToPOI:arrayCategoryItem];
    
    
    
    
    
    
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
    POICategory *category = [self.categories objectAtIndex:[indexPath row]];
    
    // Configure Cell
    [cell.textLabel setText:[category categoryName]];
    
    return cell;
}

-(void)loadCategories {
    //retrieve the path of the file in which the list of items is stored
    NSString *filePath = [self pathForCategories];
    //file manager api - reference an instance of the default class
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        self.categories = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    } else {
        //if nothing's there just instantiate a mutable array
        self.categories = [NSMutableArray array];
    }
    
}

//returns the path to the file containing the application's list of categories by appending a string to the path of the documents directory.
-(NSString*)pathForCategories {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths lastObject];
    
    return [documents stringByAppendingPathComponent:@"categories.plist"];
}


-(void)saveCategories {
    NSString *filePath = [self pathForCategories];
    [NSKeyedArchiver archiveRootObject:self.categories toFile:filePath];
}


- (NSString *)documentsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths lastObject];
}

- (void)controller:(AddCategoryViewController *)controller didSaveCategoryWithName:(NSString *)name andColor:(UIColor*)color {
    // Create Category
    POICategory *category = [POICategory createCategoryWithName:name andColor:color];
    //NSLog(@"color once back in table %@", color);
    
    // Add Item to Data Source
    [self.categories addObject:category];
    
    // Add Row to Table View
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:([self.categories count] - 1) inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    
    // Save Items
    [self saveCategories];
}

//GET THE COLORS INTO THE CELLS
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // Fetch Item
    POICategory *category = [self.categories objectAtIndex:[indexPath row]];
    cell.backgroundColor = category.categoryColor;
   
}

//Swipe to delete
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the category from the data source
        POICategory *category = [self.categories objectAtIndex:[indexPath row]];
        [self.categories removeObject:category];
        
        //TODO fix category deletion
        //NSArray *categories = [NSArray arrayWithObjects:self.categories, nil];
        //[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        NSIndexPath *deleteIndexPath = [NSIndexPath indexPathForItem:([self.categories count] - 1) inSection:0];
        [self.tableView deleteRowsAtIndexPaths:@[deleteIndexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
}


/*- (void)seedCategories {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    if (![ud boolForKey:@"TSPUserDefaultsSeedItems"]) {
        // Load Seed Items
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"seed" ofType:@"plist"];
        NSLog(@"filepath %@", filePath);
        NSArray *seedCategories = [NSArray arrayWithContentsOfFile:filePath];
        
        // Items
        NSMutableArray *categories = [NSMutableArray array];
        
        // Create List of Items
        for (int i = 0; i < [seedCategories count]; i++) {
            NSDictionary *seedCategory = [seedCategories objectAtIndex:i];
            
            // Create Item
            Category *category = [Category createCategoryWithName:[seedCategory objectForKey:@"categoryName"] andColor:[seedCategory objectForKey:@"categoryColor"]];
            
            // Add Item to Items
            [categories addObject:category];
        }
        
        // Items Path
        NSString *categoriesPath = [[self documentsDirectory] stringByAppendingPathComponent:@"items.plist"];
        
        // Write to File
        if ([NSKeyedArchiver archiveRootObject:categories toFile:categoriesPath]) {
            [ud setBool:YES forKey:@"TSPUserDefaultsSeedItems"];
        }
    }
}*/


@end
