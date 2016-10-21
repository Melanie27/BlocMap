//
//  FilterByCategoryTableViewController.h
//  BlocSpot
//
//  Created by MELANIE MCGANNEY on 10/12/16.
//  Copyright © 2016 Bloc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PointOfInterest;
@class POICategory;

//@protocol FilterByCategoryTableViewControllerDelegate;

@interface FilterByCategoryTableViewController : UITableViewController

//@property (weak) id<FilterByCategoryTableViewControllerDelegate> delegate;


@property (strong) PointOfInterest *POI;
@property (nonatomic, strong) POICategory *currentlySelectedCategory;
@end

//@protocol FilterByCategoryTableViewControllerDelegate <NSObject>

//What do I want to happen here?
//Get the hidden categories and send that information to mapview controller and results view controller

/*- (void)controller:(AddCategoryViewController *)controller didSaveCategoryWithName:(NSString *)name andColor:(UIColor*)color;*/

//method to reset the number of ds.arrayOfPOIs?

//@end