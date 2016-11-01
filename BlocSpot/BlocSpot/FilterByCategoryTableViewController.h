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



@interface FilterByCategoryTableViewController : UITableViewController



@property (strong) PointOfInterest *POI;
@property (nonatomic, strong) POICategory *currentlySelectedCategory;
@end

