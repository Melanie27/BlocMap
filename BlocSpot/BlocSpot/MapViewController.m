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
//#import "ModalViewController.h"
#import "CategoryViewController.h"

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
    
    //detecting user interation with the annotated view
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    MKAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"loc"];
    annotationView.canShowCallout = YES;
    //make the additional button a heart or something that triggers save
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeContactAdd];
    //annotationView.leftCalloutAccessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"redHeart.png"]];
    //annotationView.rightCalloutAccessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"redHeart.png"]];
    return annotationView;
    
    
    //TODO - make special annotations with images in the furture
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
    /*if([annotation isKindOfClass:[MKPointAnnotation class]]) {
        
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
    
    }*/
    //returning nil results in default annotation mark
    return nil;
}

/*- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    // Annotation is your custom class that holds information about the annotation
    if ([view.annotation isKindOfClass:[Annotation class]]) {
        Annotation *annot = view.annotation;
        NSInteger index = [self.arrayOfAnnotations indexOfObject:annot];
    }
}*/

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
   
    
    [[BLSDataSource sharedInstance] savePOI];
    NSLog(@"save this pin %@", view);
    
    //change annotation view if it has been selected
    view.selected = ![view isSelected];
    
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    self.userLocationLabel.text =
    [NSString stringWithFormat:@"Location %.5f°, %.5f°", userLocation.coordinate.latitude, userLocation.coordinate.longitude];
     MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    NSLog(@"%@", [locations lastObject]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)launchCategoriesList:(id)sender {
    CategoryViewController *categoryVC = [CategoryViewController new];
    [self presentViewController:categoryVC animated:YES completion:^{
        
    }];
    
}

-(void)loadSearchResults {
    MKLocalSearchResponse *results = [[BLSDataSource sharedInstance] results];

    
    for (int i=0; i<[results.mapItems count]; i++) {
        MKMapItem* itemPOI = results.mapItems[i];
        MKPlacemark* annotation= [[MKPlacemark alloc] initWithPlacemark:itemPOI.placemark];
        
        MKPointAnnotation *marker = [MKPointAnnotation new];
        marker.coordinate = CLLocationCoordinate2DMake(annotation.coordinate.latitude, annotation.coordinate.longitude);
        marker.title = itemPOI.placemark.name;
        marker.subtitle = itemPOI.phoneNumber;
        
        [self.mapView addAnnotation:marker];
        
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
