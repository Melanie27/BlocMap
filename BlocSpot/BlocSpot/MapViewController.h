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

@interface MapViewController : UIViewController <MKMapViewDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;


@property(nonatomic, readonly) MKCoordinateRegion region;

@property (strong, nonatomic, getter=isChosen) MKAnnotationView *annotationView;
@property (strong, nonatomic) IBOutlet UIView *containerView;


@property (strong, nonatomic) IBOutlet UITextView *locationInformationView;
//@property (strong, nonatomic) IBOutlet UITextView *regionInformationView;

@property (strong, nonatomic) IBOutlet UITextView *geocodingResultsView;


@property (strong, nonatomic) IBOutlet UISwitch *locationUpdatesSwitch;
//@property (strong, nonatomic) IBOutlet UISwitch *regionMonitoringSwitch;
@property (strong, nonatomic) IBOutlet UIButton *reverseGeocodingButton;

- (IBAction)findCurrentAddress:(id)sender;


- (IBAction)toggleLocationUpdates:(id)sender;

//- (IBAction)toggleRegionMonitoring:(id)sender;

@property (strong, nonatomic) PointOfInterest *currentPOI;
//@property (strong, nonatomic) PointOfInterest *reviewText;
@property (strong, nonatomic) POICategory *currentCategory;
-(void)loadSearchResults;
@end
