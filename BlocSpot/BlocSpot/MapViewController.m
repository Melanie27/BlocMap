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

@interface MapViewController () <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
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
    self.mapView.region = MKCoordinateRegionMakeWithDistance(laLocation, 1000000, 1000000);
    
    //add optional scroll and zoom properties
    self.mapView.zoomEnabled = YES;
    self.mapView.scrollEnabled = YES;
    
    self.locationManager = [[CLLocationManager alloc] init];
    [[[CLLocationManager alloc ] init ]requestAlwaysAuthorization];
    if([CLLocationManager locationServicesEnabled]) {
        //[self.locationManager requestWhenInUseAuthorization];
        [self.locationManager requestAlwaysAuthorization];
        self.mapView.showsUserLocation = YES;
        [self.mapView setUserTrackingMode:MKUserTrackingModeNone animated:YES];

    }
    
   
    
    
    
    
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    /*if([annotation isKindOfClass:[MyAnnotation class]]) {
        static NSString *myAnnotationID = @"myAnnotation";
         MyAnnotationView *annotationView = (MyAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:(myAnnotationID)];
        
        if(annotationView) {
          annotationView.annotation = annotation;
        } else {
            annotationView = [[MyAnnotationView alloc] initWithAnnotation:(annotation) reuseIdentifier:myAnnotationID];;
        }
        
        return annotationView;
    }*/
    
    //don't create annotation views for the user location
    if([annotation isKindOfClass:[MKPointAnnotation class]]) {
        
        static NSString *userPinAnnotationPurpleId = @"userPinAnnotation";
        
        //create an annotation view, but reuse a cached on if available
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:(userPinAnnotationPurpleId)];
        
        if(annotationView) {
            //cached view found, set pin color only
            annotationView.annotation = annotation;
            
        } else {
            //no cached views available
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:(annotation) reuseIdentifier:userPinAnnotationPurpleId];
            
            //purple indicates user defined pin
            annotationView.pinTintColor = [UIColor purpleColor];
        }
        
        return annotationView;
    
    }
    //returning nil results in default annotation mark
    return nil;
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    self.userLocationLabel.text =
    [NSString stringWithFormat:@"Location %.5f°, %.5f°", userLocation.coordinate.latitude, userLocation.coordinate.longitude];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"%@", [locations lastObject]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadSearchResults {
    MKLocalSearchResponse *results = [[BLSDataSource sharedInstance] results];

    
    for (int i=0; i<[results.mapItems count]; i++) {
        MKMapItem* itemPOI = results.mapItems[i];
        NSLog(@"Result: %@",itemPOI.placemark.name);
    
        
        MKPlacemark* annotation= [[MKPlacemark alloc] initWithPlacemark:itemPOI.placemark];
        
        MKPointAnnotation *marker = [MKPointAnnotation new];
        marker.coordinate = CLLocationCoordinate2DMake(33.8303, -116.5453);
        marker.title = itemPOI.placemark.name;
        marker.subtitle = itemPOI.placemark.name;
        [self.mapView addAnnotation:marker];
        
        NSLog(@"annotations %d",[self.mapView.annotations count]);
        
    }
    //NSLog(@"%@",searchText);
    
    
    if (!results) {return;}
    NSLog(@"*************results %@", results);
    self.mapView.region = results.boundingRegion;
    NSLog(@"bounding region %@", self.mapView);
    
     
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
