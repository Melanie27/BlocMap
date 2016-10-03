//
//  MapViewController.m
//  BlocSpot
//
//  Created by MELANIE MCGANNEY on 9/16/16.
//  Copyright © 2016 Bloc. All rights reserved.
//

#import "MapViewController.h"
#import "MyAnnotation.h"
#import "MyAnnotationView.h"
#import "BLSDataSource.h"
#import "SearchViewController.h"
#import "PointOfInterest.h"

//#import "CategoryViewController.h"

@interface MapViewController () <CLLocationManagerDelegate, UIViewControllerTransitioningDelegate, MKMapViewDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic, strong) PointOfInterest *chosenPointOfInterest;
@end

@implementation MapViewController
CLLocationManager *locationManager;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"BlocSpot Map";
    
    //make the view controller be the map view's delegate
    self.mapView.delegate = self;
    //set initialial mapkit region
    CLLocationCoordinate2D laLocation= CLLocationCoordinate2DMake(34.0195, -118.4912);
    self.mapView.region = MKCoordinateRegionMakeWithDistance(laLocation, 100000, 100000);
    
    //add optional scroll and zoom properties
    self.mapView.zoomEnabled = YES;
    self.mapView.scrollEnabled = YES;
    
    self.locationManager = [[CLLocationManager alloc] init];
    [[[CLLocationManager alloc ] init ]requestAlwaysAuthorization];
    if([CLLocationManager locationServicesEnabled]) {
        [self.locationManager requestAlwaysAuthorization];
        self.mapView.showsUserLocation = YES;
        [self.mapView setUserTrackingMode:MKUserTrackingModeNone animated:YES];

    }
    

    [[BLSDataSource sharedInstance] loadSavedMarkers];
    
    
    
    //[self.mapView addAnnotation:marker];
     

    
}



-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    //detecting user interation with the annotated view
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    
    MKAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"loc"];
    annotationView.canShowCallout = YES;
    //make the additional button a heart or something that triggers save
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeContactAdd];
    annotationView.leftCalloutAccessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"redHeart.png"]];
    
    return annotationView;
    
    
   
    
}

/*- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    // Annotation is your custom class that holds information about the annotation
    if ([view.annotation isKindOfClass:[Annotation class]]) {
        Annotation *annot = view.annotation;
        NSInteger index = [self.arrayOfAnnotations indexOfObject:annot];
    }
}*/

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
   
    //right now just passing empty array - need to grab the correct item
    NSLog(@"annot %@", view.annotation);
    NSArray *arrayMapItem = [NSArray arrayWithObjects:view.annotation, nil];
    
    [[BLSDataSource sharedInstance] savePOI:(arrayMapItem) andThen:^(MKLocalSearchResponse * _Nullable response, NSError * _Nullable error) {
    }];
    
}



/*-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    self.userLocationLabel.text =
    [NSString stringWithFormat:@"Location %.5f°, %.5f°", userLocation.coordinate.latitude, userLocation.coordinate.longitude];
     MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
}*/

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    NSLog(@"%@", [locations lastObject]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)loadSearchResults {
    MKLocalSearchResponse *results = [[BLSDataSource sharedInstance] results];

    MKMapRect zoomRect = MKMapRectNull;
    for (int i=0; i<[results.mapItems count]; i++) {
        MKMapItem* itemPOI = results.mapItems[i];
        MKPlacemark* annotation= [[MKPlacemark alloc] initWithPlacemark:itemPOI.placemark];
        
        MKPointAnnotation *marker = [MKPointAnnotation new];
        marker.coordinate = CLLocationCoordinate2DMake(annotation.coordinate.latitude, annotation.coordinate.longitude);
        marker.title = itemPOI.placemark.name;
        marker.subtitle = itemPOI.phoneNumber;
        MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1);
        zoomRect = MKMapRectUnion(zoomRect, pointRect);
        [self.mapView addAnnotation:marker];
        [self.mapView setVisibleMapRect:zoomRect animated:YES];
        
    }
   
}

- (void)viewWillAppear:(BOOL)animated {
    [self loadSearchResults];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UIViewController *vc = [segue destinationViewController];
    if ([vc isKindOfClass:[SearchViewController class]]) {
        SearchViewController *svc = (SearchViewController*)vc;
        svc.mapVC = self;
    }
}


@end
