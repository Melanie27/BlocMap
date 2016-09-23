//
//  SearchViewController.h
//  BlocSpot
//
//  Created by MELANIE MCGANNEY on 9/19/16.
//  Copyright © 2016 Bloc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Mapkit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@class MapViewController;

@interface SearchViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *searchText;
@property (strong, nonatomic) IBOutlet MapViewController *mapVC;

- (IBAction)dismissSearchView:(id)sender;
- (IBAction)searchMap:(id)sender;

@end
