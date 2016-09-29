//
//  MapViewController.h
//  BlocSpot
//
//  Created by MELANIE MCGANNEY on 9/16/16.
//  Copyright © 2016 Bloc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/Mapkit.h>
#import <CoreLocation/CoreLocation.h>

@interface MapViewController : UIViewController <MKMapViewDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UILabel *userLocationLabel;
@property(nonatomic, readonly) MKCoordinateRegion region;

@property (strong, nonatomic) IBOutlet UIButton *categoriesButton;
- (IBAction)launchCategoriesList:(id)sender;


@property (strong, nonatomic, getter=isChosen) MKAnnotationView *annotationView;

-(void)loadSearchResults;
@end
