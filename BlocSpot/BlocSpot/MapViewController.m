//
//  MapViewController.m
//  BlocSpot
//
//  Created by MELANIE MCGANNEY on 9/16/16.
//  Copyright © 2016 Bloc. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController () <CLLocationManagerDelegate>
@property (nonatomic, strong) MKUserLocation *userLocationVisible;
@end

@implementation MapViewController
CLLocationManager *locationManager;

- (void)startStandardUpdates
{
    // Create the location manager if this object does not
    // already have one.
    if (nil == locationManager)
        locationManager = [[CLLocationManager alloc] init];
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    
    // Set a movement threshold for new events.
    locationManager.distanceFilter = 500; // meters
    
    [locationManager startUpdatingLocation];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"BlocSpot Map";
    
    //make the view controller be the map view's delegate
    self.mapView.delegate = self;
    self.mapView.zoomEnabled = YES;
    self.mapView.scrollEnabled = YES;
    [self startStandardUpdates];
    [[[CLLocationManager alloc] init]requestWhenInUseAuthorization];
    if([CLLocationManager locationServicesEnabled]) {
    
    self.mapView.showsUserLocation = YES;
        
    }
    
    
    //set initialial mapkit region
    //CLLocationCoordinate2D laLocation= CLLocationCoordinate2DMake(39.739, -104.983);
    //self.mapView.region = MKCoordinateRegionMakeWithDistance(laLocation, 100000, 100000);
    
    MKLocalSearchRequest* request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = @"coffee";
    
    // Set the region to an associated map view's region
    //request.region = myMapView.region;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
