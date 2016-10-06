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
#import "CategoryListViewController.h"

//#import "CategoryViewController.h"

@interface MapViewController () <CLLocationManagerDelegate, UIViewControllerTransitioningDelegate, MKMapViewDelegate, UIGestureRecognizerDelegate>

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
    
    [[BLSDataSource sharedInstance] loadSavedMarkers:^(NSArray *pois) {
        // Set up annotations for each poi
        NSLog(@"number of stored map items %lu", (unsigned long)pois.count);
        if(pois.count > 0) {
            NSLog(@"number of stored map items %lu", (unsigned long)pois.count);
        }
        
        for (MKPointAnnotation *annotation in pois) {
         PointOfInterest *item = [[PointOfInterest alloc] initWithMKPointAnnotation:annotation];
            MKPointAnnotation *marker = [MKPointAnnotation new];
            marker.coordinate = CLLocationCoordinate2DMake(annotation.coordinate.latitude, annotation.coordinate.longitude);
            marker.title = item.title;
            marker.subtitle = item.subtitle;
            [self.mapView addAnnotation:marker];
            
        }
        
        
    }];
    
    UITapGestureRecognizer *tapOutsideContainerRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(dismissContainerView)];
    [self.mapView addGestureRecognizer:tapOutsideContainerRecognizer];
    
}

-(void)dismissContainerView {
    
     self.containerView.hidden = YES;
}

-(void)updateMapviewAnnotations {
    
}
-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    
}



-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)annotationView {
    
        [self updateLeftCalloutAccessoryViewInAnnotationView:annotationView];
    
    
}

//gives an annotation and returns a view for that annotation
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    
    //detecting user interation with the annotated view
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    static NSString *reuseIdentifier = @"MapViewControllerLoc";
    MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:reuseIdentifier];
    if(!annotationView) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
        annotationView.canShowCallout = YES;
        UIButton *infoButton = [[UIButton alloc]init];
        [infoButton setBackgroundImage:[UIImage imageNamed:@"redHeart.png"] forState:UIControlStateNormal];
        [infoButton sizeToFit];
        //UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"redHeart.png"]];
        annotationView.leftCalloutAccessoryView = infoButton;
        
        UIButton *savePOIButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
        annotationView.rightCalloutAccessoryView = savePOIButton;
    }
    
    
    //annotationView = annotation;
    
    return annotationView;
    

}

/*- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    // Annotation is your custom class that holds information about the annotation
    if ([view.annotation isKindOfClass:[Annotation class]]) {
        Annotation *annot = view.annotation;
        NSInteger index = [self.arrayOfAnnotations indexOfObject:annot];
    }
}*/

-(void)updateLeftCalloutAccessoryViewInAnnotationView:(MKAnnotationView *)annotationView {
    //NSlog update the color of the heart depending on the category the poi has been assigned
    //see stanford lecture 15 around min 45
    //will have to respond to changing data model
    NSLog(@"change appearance of heart");
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    BLSDataSource *ds = [BLSDataSource sharedInstance];
    if (control == view.rightCalloutAccessoryView) {
        NSArray *arrayMapItem = [NSArray arrayWithObjects:view.annotation, nil];
        
        
        [ds convertPointAnnotationsToPOI:arrayMapItem];
        [ds savePOIAndThen:^(MKLocalSearchResponse * _Nullable response, NSError * _Nullable error) {
            NSLog(@"response %@", response.mapItems);}];
        self.containerView.hidden = NO;
        
        //NSLog(@"response %@", response.mapItems);
        
    } else if (control == view.leftCalloutAccessoryView){
        NSLog(@"add to a category");
    }
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([sender isKindOfClass:[MKAnnotationView class]]) {
        [self prepareViewController:segue.destinationViewController forSegue:segue.identifier toShowAnnotation:((MKAnnotationView *) sender).annotation];
    }
    //prepare segue for embed
    if ([segue.identifier isEqualToString:@"showEmbed"]) {
        
        
        CategoryListViewController *clvc = (CategoryListViewController*)segue.destinationViewController;
        NSLog(@"showEmbed");
        //clvc.POI = self.POI
        
    }
    
    //if([segue.destinationViewController isKindOfClass:[CategoryListViewController class]]) {
        //pass some data about the POI so that that is can be saved to a category
    //}
}

-(void)prepareViewController:(id)vc
                    forSegue:(NSString *)segueIdentifier
            toShowAnnotation:(id<MKAnnotation>)annotation {
     NSLog(@"check call");
    PointOfInterest *poi = nil;
    //if([annotation isKindOfClass:[PointOfInterest class]]) {
        poi = (PointOfInterest *)annotation;
        NSLog(@"poi");
    //}
    
    if(poi) {
        if(![segueIdentifier length] || [segueIdentifier isEqualToString:@"showCategories"]) {
            if ([vc isKindOfClass:[UITableViewController class]]) {
                UITableViewController *tvc = (UITableViewController *)vc;
                tvc.title = poi.title;
                NSLog(@"title %@", tvc.title);
                //pass stuff
            }
        }
    }
    
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
    //[self.mapView showAnnotations:results.mapItems animated:YES];
   
}

- (void)viewWillAppear:(BOOL)animated {
    [self loadSearchResults];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
/*- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UIViewController *vc = [segue destinationViewController];
    if ([vc isKindOfClass:[SearchViewController class]]) {
        SearchViewController *svc = (SearchViewController*)vc;
        svc.mapVC = self;
    }
}*/


@end
