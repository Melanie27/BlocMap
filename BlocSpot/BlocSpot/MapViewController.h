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

@class PointOfInterest;
@class POICategory;

@interface MapViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate> {

    CLLocationManager *_locationManager;
}

@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@property(nonatomic, readonly) MKCoordinateRegion region;

@property (strong, nonatomic, getter=isChosen) MKAnnotationView *annotationView;
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) PointOfInterest *currentPOI;
@property (strong, nonatomic) POICategory *currentCategory;

@property (strong, nonatomic) IBOutlet UITextView *locationInformationView;
@property (strong, nonatomic) IBOutlet UISwitch *locationUpdatesSwitch;
- (IBAction)toggleLocationUpdates:(id)sender;



-(void)loadSearchResults;
@end
