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

@interface MapViewController () <CLLocationManagerDelegate, UIViewControllerTransitioningDelegate, MKMapViewDelegate, UIGestureRecognizerDelegate, UIAlertViewDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLGeocoder *geocoder;
@property (nonatomic, strong) PointOfInterest *chosenPointOfInterest;

@end

@implementation MapViewController
CLLocationManager *locationManager;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"BlocSpot Map";
   
    //register kvo for points of interest
    [[BLSDataSource sharedInstance] addObserver:self forKeyPath:@"arrayOfPOIs" options:0 context:nil];
    
    //make the view controller be the map view's delegate
    self.mapView.delegate = self;
   
    
    //set init mapkit region
    CLLocationCoordinate2D laLocation= CLLocationCoordinate2DMake(34.0195, -118.4912);
    self.mapView.region = MKCoordinateRegionMakeWithDistance(laLocation, 100000, 100000);
    
    
   
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [[[CLLocationManager alloc ] init ]requestAlwaysAuthorization];
    if([CLLocationManager locationServicesEnabled]) {
        [self.locationManager requestAlwaysAuthorization];
        self.mapView.showsUserLocation = YES;
        [self.mapView setMapType:MKMapTypeStandard];
        [self.mapView setZoomEnabled:YES];
        [self.mapView setScrollEnabled:YES];
        //[self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];

    }
    

    [self observeValueForKeyPath:@"arrayOfPOIs" ofObject:_chosenPointOfInterest change:nil context:nil];

    [[BLSDataSource sharedInstance] loadSavedData:^(NSArray *pois) {
        // Set up annotations for each poi
        
        NSLog(@"number of stored map items hi %lu", (unsigned long)pois.count);
        
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


- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    

    if (object == [BLSDataSource sharedInstance] && [keyPath isEqualToString:@"arrayOfPOIs"]) {
        // We know arrayOfPOIs changed.  Let's see what kind of change it is.
        
        NSKeyValueChange kindOfChange = [change[NSKeyValueChangeKindKey] unsignedIntegerValue];
        
        if (kindOfChange == NSKeyValueChangeSetting) {
            
            NSLog(@"registering a change neeed to update color of the POI title");
    
            //TODO Grab a hold of the POI that was categorized and update the color of the annotation.title to the corresponding category color
           
            
        }  else if (kindOfChange == NSKeyValueChangeInsertion ||
                     kindOfChange == NSKeyValueChangeRemoval ||
                     kindOfChange == NSKeyValueChangeReplacement) {
            // We have an incremental change: inserted, deleted, or replaced pins
            
        }

    }
}

//remove kv observer when it's no longer needed
- (void) dealloc {
    [[BLSDataSource sharedInstance] removeObserver:self forKeyPath:@"arrayOfPOIs"];
}

-(void)dismissContainerView {
    
     self.containerView.hidden = YES;
}

-(void)updateMapviewAnnotations {
    
}
-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    
}

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)annotationView {
            [self updateAccessoryViewInAnnotationView:annotationView];
    
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
        //TODO need different image to trigger Action sheet
        [infoButton setBackgroundImage:[UIImage imageNamed:@"directions.png"] forState:UIControlStateNormal];
        [infoButton sizeToFit];
        annotationView.leftCalloutAccessoryView = infoButton;
        UIButton *savePOIButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
        annotationView.rightCalloutAccessoryView = savePOIButton;
        
    }
    
    return annotationView;
    
}

-(void)mapView:(MKMapView *)mapView currentPOI:(NSString*)title currentPOI:(NSString*)reviewText shareButtonPressed:(MKAnnotationView *)annotationView {
    BLSDataSource *ds = [BLSDataSource sharedInstance];
    ds.currentPOI = [[PointOfInterest alloc] initWithMKPointAnnotation:(MKPointAnnotation*)annotationView.annotation];
    if (![ds.arrayOfPOIs containsObject:ds.currentPOI]) {
        [ds.arrayOfPOIs addObject:ds.currentPOI];
    }
    //Call Activity Controller
    
    UIActivityViewController *activityViewController =
    [[UIActivityViewController alloc] initWithActivityItems:@[title, reviewText]
                                      applicationActivities:nil];
    [self.navigationController presentViewController:activityViewController
                                            animated:YES
                                          completion:^{
                                              // ...
                                          }];

}


-(void)updateAccessoryViewInAnnotationView:(MKAnnotationView *)annotationView {
    
    BLSDataSource *ds = [BLSDataSource sharedInstance];

   NSUInteger index = [ds.arrayOfPOIs indexOfObjectPassingTest:^BOOL(PointOfInterest * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.coordinate.latitude == annotationView.annotation.coordinate.latitude &&
            obj.coordinate.longitude == annotationView.annotation.coordinate.longitude &&
            [obj.title isEqualToString:annotationView.annotation.title]) {
                return YES;
            } else {
                return NO;
            }
    }];
    
    ds.currentPOI = ds.arrayOfPOIs[index];
    
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)annotationView calloutAccessoryControlTapped:(UIControl *)control{
    BLSDataSource *ds = [BLSDataSource sharedInstance];
    
    NSUInteger index = [ds.arrayOfPOIs indexOfObjectPassingTest:^BOOL(PointOfInterest * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.coordinate.latitude == annotationView.annotation.coordinate.latitude &&
            obj.coordinate.longitude == annotationView.annotation.coordinate.longitude &&
            [obj.title isEqualToString:annotationView.annotation.title]) {
            return YES;
        } else {
            return NO;
        }
    }];
    
    ds.currentPOI = ds.arrayOfPOIs[index];
    if (control == annotationView.rightCalloutAccessoryView) {
        NSArray *arrayMapItem = [NSArray arrayWithObjects:annotationView.annotation, nil];
        
        [ds convertPointAnnotationsToPOI:arrayMapItem];
        [ds savePOIAndThen:^(MKLocalSearchResponse * _Nullable response, NSError * _Nullable error) {}];
        self.containerView.hidden = NO;
        
       
        
    } else if (control == annotationView.leftCalloutAccessoryView){
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Points of Interest"
                                                                       message:@"Do Stuff"
                                                                preferredStyle:UIAlertControllerStyleActionSheet]; // 1
        UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"get directions"
                                                              style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                  NSArray *arrayMapItem = [NSArray arrayWithObjects:annotationView.annotation, nil];
                                                                  
                                                                  for (int i=0; i<[arrayMapItem count]; i++ ) {
                                                                      MKPointAnnotation* savedPoint = arrayMapItem[i];
                                                                      //NSLog(@"MKPointAnnotation %@", savedPoint);
                                                                      
                                                                      
                                                                      MKPlacemark *mapDest = [[MKPlacemark alloc]
                                                                                              initWithCoordinate:savedPoint.coordinate
                                                                                              addressDictionary:nil];
                                                                      
                                                                     
                                                                      
                                                                      MKMapItem *thisItem = [[MKMapItem alloc] initWithPlacemark:mapDest];
                                                                      [thisItem openInMapsWithLaunchOptions:nil];
                                                                  }
                                                                  
                                                              }];
        
       
        UIAlertAction *secondAction = [UIAlertAction actionWithTitle:@"add a brief note to poi"
                                                               style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Add a note" message:@"Brief description of this POI." preferredStyle:UIAlertControllerStyleAlert];
                                                                   
                                                                   
                                                                   UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                       // access text from text field
                                                                      
                                                                       NSString *reviewText = ((UITextField *)[alert.textFields objectAtIndex:0]).text;
                                                                       ds.currentPOI.noteText = reviewText;
                                                                      NSLog(@"review text %@",  reviewText);
                                                                       //method that saves
                                                                       [ds saveNoteToPOI:ds.currentPOI];

                                                                   }];
                                                                  
                                                                   
                                                                   [alert addAction:defaultAction]; // 9
                                                                   
                                                                   [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                                                                       textField.placeholder = @"Input data...";
                                                                   }];
                                                                   
                                                                  
                                                                  [self presentViewController:alert animated:YES completion:nil]; 
                                                                  
                                                                   
                                                               }];
        UIAlertAction *thirdAction = [UIAlertAction actionWithTitle:@"share poi"
                                                              style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                 
                                                                  if (![ds.arrayOfPOIs containsObject:ds.currentPOI]) {
                                                                      [ds.arrayOfPOIs addObject:ds.currentPOI];
                                                                  }
                                                                  
                                                                  NSString *name = ds.currentPOI.title;
                                                                  NSString *reviewText = ds.currentPOI.noteText;
                                                                  NSLog(@"note %@", ds.currentPOI.noteText);
                                                                  
                                                                  
                                                                  //test if user somehow entered empty string
                                                                  if ([reviewText length] == 0) {
                                                                      reviewText = @"add a review if you haven't";
                                                                  }
                                                                  
                                                                  [self mapView:self.mapView currentPOI:name currentPOI:reviewText shareButtonPressed:self.annotationView ];
                                                                  
                                                                  
                                                              }];
        UIAlertAction *fourthAction = [UIAlertAction actionWithTitle:@"delete poi"
                                                               style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
                                                                   NSLog(@"delete poi");
                                                                   
                                                               }];
        UIAlertAction *fifthAction = [UIAlertAction actionWithTitle:@"cancel"
                                                              style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
                                                                  NSLog(@"cancel");
                                                                  
                                                              }];
        
        [alert addAction:firstAction];
        [alert addAction:secondAction];
        [alert addAction:thirdAction];
        [alert addAction:fourthAction];
        [alert addAction:fifthAction];
        
        [self presentViewController:alert animated:YES completion:nil]; // 6
        
    }
    
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([sender isKindOfClass:[MKAnnotationView class]]) {
        [self prepareViewController:segue.destinationViewController forSegue:segue.identifier toShowAnnotation:((MKAnnotationView *) sender).annotation];
    }
    //prepare segue for embed
    if ([segue.identifier isEqualToString:@"showEmbed"]) {
        //NSLog(@"showEmbed");
    } else if ([segue.identifier isEqualToString:@"showCategories"]) {
       // NSLog(@"showCategories");
        
        
        UINavigationController *navc = (UINavigationController*)segue.destinationViewController;
        CategoryListViewController *clvc = (CategoryListViewController*)([navc viewControllers][0]);
        clvc.POI = self.currentPOI;
        
    }
    
}

-(void)prepareViewController:(id)vc
                    forSegue:(NSString *)segueIdentifier
            toShowAnnotation:(id<MKAnnotation>)annotation {
    
    PointOfInterest *poi = nil;
        poi = (PointOfInterest *)annotation;
        //NSLog(@"poi");
  
    
    if(poi) {
        if(![segueIdentifier length] || [segueIdentifier isEqualToString:@"showCategories"]) {
            if ([vc isKindOfClass:[UITableViewController class]]) {
                UITableViewController *tvc = (UITableViewController *)vc;
                tvc.title = poi.title;
                //NSLog(@"title %@", tvc.title);
               
            }
        }
    }
    
}



-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
   
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    
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


-(IBAction)directionsButtonPressed:(UIButton *)button annotationView:(MKAnnotationView *)view {
    NSLog(@"map it");
    BLSDataSource *ds = [BLSDataSource sharedInstance];
    NSArray *arrayMapItem = [NSArray arrayWithObjects:view.annotation, nil];
    
    [ds convertPointAnnotationsToPOI:arrayMapItem];
    for (int i=0; i<[arrayMapItem count]; i++ ) {
        MKPointAnnotation* savedPoint = arrayMapItem[i];
        NSLog(@"MKPointAnnotation %@", savedPoint);
        
        
        MKPlacemark *mkDest = [[MKPlacemark alloc]
                               initWithCoordinate:savedPoint.coordinate
                               addressDictionary:nil];
        
        
        MKMapItem *thisItem = [[MKMapItem alloc] initWithPlacemark:mkDest];
        [thisItem openInMapsWithLaunchOptions:nil];
        
        
    }
}


/*-(IBAction)savePOIButtonPressed:(UIButton *)button {
 NSLog(@"save poi");
 }*/

-(IBAction)addNoteButtonPressed:(UIButton *)button {
    
    //self.currentNote.noteText = self.noteForPOI.text;
    //NSLog(@"add Note %@", self.currentNote.noteText);
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

//CHECKPOINT 8


//geocoding
- (IBAction)findCurrentAddress:(id)sender {
    if([CLLocationManager locationServicesEnabled]) {
        if(self.locationManager == nil) {
            
            _locationManager = [[CLLocationManager alloc] init];
            _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
            _locationManager.distanceFilter = 500;
            _locationManager.delegate = self;
            
        }
        
        [self.locationManager startUpdatingLocation];
        self.geocodingResultsView.text = @"Getting location";
    } else {
        self.geocodingResultsView.text = @"location services unavailable";
    }
    
}

///STARTING AND STOPPING LOCATION UPDATES

- (IBAction)regionMonitoringSwitch:(id)sender {
}



- (IBAction)toggleLocationUpdates:(id)sender {
    NSLog(@"toggling");
    if(self.locationUpdatesSwitch.on == YES) {
        
        if([CLLocationManager locationServicesEnabled] == NO) {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Location Services Disabled"
                                                                           message:@"This feature requires location services. Enable it in theprivacy settings on your device."
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
            
            //self.locationUpdatesSwitch.on == NO;
            return;
            
        }
        
        if(_locationManager == nil) {
            _locationManager = [[CLLocationManager alloc] init];
            _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            _locationManager.distanceFilter = 1;
            _locationManager.activityType = CLActivityTypeFitness;
            _locationManager.delegate = self;
        }
        
        [_locationManager startUpdatingLocation];
    }
    
    else {
        //Switch was turned off
        //Stop updates if they have been started
        if(_locationManager !=nil) {
            [_locationManager stopUpdatingLocation];
        }
    }
}

- (IBAction)toggleRegionMonitoring:(id)sender {
    NSLog(@"toggle region monitor");
    if(self.regionMonitoringSwitch.on == YES) {
        CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
        
        if (status == kCLAuthorizationStatusAuthorizedAlways ||
            status == kCLAuthorizationStatusAuthorizedWhenInUse ||
            status == kCLAuthorizationStatusNotDetermined) {
            
            //start monitoring the region here
            
            //instantiate location manager instance variable if not already created
            if (self.locationManager == nil) {
                self.locationManager = [[CLLocationManager alloc]init];
                self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
                self.locationManager.delegate = self;
            }
            
            //define center coordinate and radius of region to monitor
            CLLocationCoordinate2D laLocation= CLLocationCoordinate2DMake(34.0195, -118.4912);
            int regionRadius = 3000; //meters
            if(regionRadius > self.locationManager.maximumRegionMonitoringDistance) {
                regionRadius = self.locationManager.maximumRegionMonitoringDistance;
            }
            
            CLCircularRegion *laRegion = [[CLCircularRegion alloc] initWithCenter:laLocation radius:regionRadius identifier:@"laRegion"];
            
            [self.locationManager startMonitoringForRegion:laRegion];
            
            
            
        } else {
            if(self.locationManager == nil) {
                for (CLCircularRegion *monitoredRegion in [self.locationManager monitoredRegions]){
                    [self.locationManager stopMonitoringForRegion:monitoredRegion];
                    self.regionInformationView.text = [NSString stringWithFormat:@"Turned off region monitoring for %@", monitoredRegion.identifier];
                }
            }
            self.regionInformationView.text = @"Region Monitoring Disabled";
            self.regionMonitoringSwitch.on = NO;
        }
    }
}

//managing failures
-(void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
        switch (error.code) {
            case kCLErrorRegionMonitoringDenied: {
                self.regionInformationView.text = @"Region monitoring denied on this device";
                break;
            }
            case kCLErrorRegionMonitoringFailure: {
                self.regionInformationView.text = [NSString stringWithFormat:@"Region Monitoring failed for region: %@", region.identifier];
                break;
            }
            default: {
                self.regionInformationView.text = [
                                                   NSString stringWithFormat:@"An unhandled error occured: %@", error.description];
                break;
            }
        }
    
}

//enter a region
-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    self.regionInformationView.text = @"Welcome to LA!";
    
    UILocalNotification *entranceNotification = [[UILocalNotification alloc] init];
    entranceNotification.alertBody = @"Welcome to LA!";
    entranceNotification.alertAction= @"Ok";
    entranceNotification.soundName = UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication] presentLocalNotificationNow:entranceNotification];
}

//exit a region
-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    self.regionInformationView.text = @"Thanks for visiting! Come back soon!";
    
    UILocalNotification *exitNotification = [[UILocalNotification alloc] init];
    exitNotification.alertBody = @"See ya!";
    exitNotification.alertAction= @"Ok";
    exitNotification.soundName = UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication] presentLocalNotificationNow:exitNotification];
    
}

//Receiving Location Updates
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if(error.code == kCLErrorDenied) {
        //turning switch off triggers toggle action to stop further updates
        //self.locationUpdatesSwitch.on == NO;
        self.geocodingResultsView.text = @"Location information denied";
    } else {
        NSLog(@"Error %@", error);
    }
}



//Handle Location Updates
-(void)locationManager:(CLLocationManager*)manager didUpdateLocations:(nonnull NSArray<CLLocation *> *)locations {
    CLLocation *lastLocation = [locations lastObject];
    NSLog(@"%@", lastLocation);
    //Check if timestamp on location is recent
    NSTimeInterval eventInterval = [lastLocation.timestamp timeIntervalSinceNow];
    if(fabs(eventInterval) < 30.0) {
        //check accuracy of event
        if(lastLocation.horizontalAccuracy >= 0 && lastLocation.horizontalAccuracy <20) {
            self.locationInformationView.text = lastLocation.description;
            //NSLog(@"loc info %@", self.locationInformationView.text);
            
            UILocalNotification *notification= [[UILocalNotification alloc] init];
            notification.alertBody= [NSString stringWithFormat:@"New Location: %.3f, %.3f", lastLocation.coordinate.latitude, lastLocation.coordinate.longitude];
            notification.alertAction = @"OK";
            notification.soundName = UILocalNotificationDefaultSoundName;
            
            //increment the application badge number
            notification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] +1;
            [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
            
            
            //geocoding stuff
            if (self.geocoder == nil)
                self.geocoder = [[CLGeocoder alloc] init];
            
            //only one geocoding instance per action
            if([self.geocoder isGeocoding])
                [self.geocoder cancelGeocode];
            
            //begin reverse geocoding
            
            //TODO pass the placemarks from the arrayofPOIS Here?
            [self.geocoder reverseGeocodeLocation:lastLocation completionHandler:^(NSArray *placemarks, NSError *error) {
                    if([placemarks count] > 0) {
                        CLPlacemark *foundPlacemark = [placemarks objectAtIndex:0];
                        self.geocodingResultsView.text = [NSString stringWithFormat:@"You are near %@", foundPlacemark.description];
                    } else if (error.code == kCLErrorGeocodeCanceled) {
                        NSLog(@"geocode cancelled");
                    } else if (error.code == kCLErrorGeocodeFoundNoResult) {
                        self.geocodingResultsView.text=@"no geocode result found";
                    } else if  (error.code == kCLErrorGeocodeFoundPartialResult) {
                        self.geocodingResultsView.text = @"got partial result";
                    } else {
                        self.geocodingResultsView.text = [NSString stringWithFormat:@"Unknown error %@", error.description];
                    }
                }
             ];
            //stop updating location until they click the button again
            [manager stopUpdatingLocation];
        }
    }
}








@end
