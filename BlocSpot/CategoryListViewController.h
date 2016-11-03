//
//  CategoryListViewController.h
//  BlocSpot
//
//  Created by MELANIE MCGANNEY on 9/30/16.
//  Copyright © 2016 Bloc. All rights reserved.
//

#import <UIKit/UIKit.h>
//conform to add cat protocol
#import "AddCategoryViewController.h"
@class PointOfInterest;
@interface CategoryListViewController : UITableViewController 
@property (strong) PointOfInterest *POI;
- (IBAction)addItem:(id)sender;

@end
