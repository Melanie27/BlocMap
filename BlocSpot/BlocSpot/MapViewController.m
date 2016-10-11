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

@property (nonatomic, strong) UIView *customAnnotationView;

@end

@implementation MapViewController
CLLocationManager *locationManager;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"BlocSpot Map";
    
    //register kvo for points of interest
    [[BLSDataSource sharedInstance] addObserver:self forKeyPath:@"arrayOfCategories" options:0 context:nil];
    
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
    
    
    
    
    
    

    /*[[BLSDataSource sharedInstance] saveCategoryToPOI:self.currentCategory andThen:^(NSArray *pois) {
        [self observeValueForKeyPath:@"arrayOfPOIs" ofObject:self.currentPOI change:nil context:nil];
         NSLog(@"chosen POI %@", self.currentCategory);
    }];*/
    
    /*[[BLSDataSource sharedInstance] saveCategoryToPOI:self.currentCategory andThen:^(POICategory *currCat) {
         [self observeValueForKeyPath:@"arrayOfPOIs" ofObject:self.currentCategory change:nil context:nil];
    }];*/
    [[BLSDataSource sharedInstance] saveCategoryToPOI:self.currentCategory];
    [self observeValueForKeyPath:@"arrayOfPOIs" ofObject:self.currentCategory change:nil context:nil];
    
    
    [[BLSDataSource sharedInstance] loadSavedMarkers:^(NSArray *pois) {
        // Set up annotations for each poi
        NSLog(@"number of stored map items %lu", (unsigned long)pois.count);
         
         NSLog(@"chosen POI %@", self.currentPOI);
        if(pois.count > 0) {
           
        }
        
         
         
        for (MKPointAnnotation *annotation in pois) {
         PointOfInterest *item = [[PointOfInterest alloc] initWithMKPointAnnotation:annotation];
            MKPointAnnotation *marker = [MKPointAnnotation new];
            marker.coordinate = CLLocationCoordinate2DMake(annotation.coordinate.latitude, annotation.coordinate.longitude);
            marker.title = item.title;
            marker.subtitle = item.subtitle;
            [self.mapView addAnnotation:marker];
            //NSLog(@"catogory of POI %@", item.category);
            
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
            //test what category it is then change the pin color accordingly
            NSLog(@" cat name %@", self.currentPOI.category);
            NSLog(@"observe poi title %@", self.currentPOI.title);
            
            
           
            //UIColor *catColor = [UIColor blueColor];
            //NSString *catName = self.currentPOI.category;
            //NSDictionary *attrs = @{ NSForegroundColorAttributeName : catColor };
            //NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:catName attributes:attrs];
            //self.scanLabel.attributedText = attrStr;
            
            
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

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    static NSString *reuseId = @"ann";
    
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView
                                                                  dequeueReusableAnnotationViewWithIdentifier:reuseId];
    if (annotationView == nil) {
        annotationView = [[MKPinAnnotationView alloc]
                          initWithAnnotation:annotation
                          reuseIdentifier:@"test"];
        annotationView.canShowCallout = YES;  //set to YES, default is NO
        
        //your code
        
        UIView *vw = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 200)];
        annotationView.leftCalloutAccessoryView = vw;
        //vw.backgroundColor = [UIColor redColor];
        //UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 35, 35)];
        //label.numberOfLines = 4;
        //label.text = @"hello";
        //[vw addSubview:label];
        
        
        
        //annotationView.rightCalloutAccessoryView = savePOIButton;
        UIButton *directionsButton = [[UIButton alloc]initWithFrame:CGRectMake(5, 5, 13, 13)];
        [directionsButton setBackgroundImage:[UIImage imageNamed:@"directions.png"] forState:UIControlStateNormal];
        
       
        UIButton *triggerShareButton = [[UIButton alloc] initWithFrame:CGRectMake(35, 5, 13, 13)];
        [triggerShareButton setBackgroundImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
        
        
        UIButton *savePOIButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        [savePOIButton setBackgroundImage:[UIImage imageNamed:@"save.png"] forState:UIControlStateNormal];
        annotationView.rightCalloutAccessoryView = savePOIButton;
        
        UIButton *addNoteButton = [[UIButton alloc] initWithFrame:CGRectMake(65, 5, 13, 13)];
        [addNoteButton setBackgroundImage:[UIImage imageNamed:@"note.png"] forState:UIControlStateNormal];
        
        UIButton *deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(95, 5, 13, 13)];
        [deleteButton setBackgroundImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
        
        [vw addSubview:triggerShareButton];
        [vw addSubview:directionsButton];
        //[vw addSubview:savePOIButton];
        [vw addSubview:addNoteButton];
        [vw addSubview:deleteButton];
        
        
        [triggerShareButton addTarget:self action:@selector(shareButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [directionsButton addTarget:self action:@selector( directionsButtonPressed:mapView:annotationView:) forControlEvents:UIControlEventTouchUpInside];
        
        //[savePOIButton addTarget:self action:@selector(savePOIButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [addNoteButton addTarget:self action:@selector(addNoteButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [deleteButton addTarget:self action:@selector(deletePOIPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
    }
    else {
        //Update view's annotation reference
        //because we are re-using view that may have
        //been previously used for another annotation...
        annotationView.annotation = annotation;
    }
    
    return annotationView;
}


-(IBAction)shareButtonPressed:(UIButton *)button  {
    //BLSDataSource *ds = [BLSDataSource sharedInstance];
    //ds.currentPOI = [[PointOfInterest alloc] initWithMKPointAnnotation:(MKPointAnnotation*)annotationView.annotation];
    //Add UIActivityViewController here?
    NSString *string = @"this can be the individual note to share";
    //NSString *name = ds.currentPOI.title;
    NSString *name = @"this will be the name";
    //ADD the point of interest name and number?
    
    //NSURL *URL = ...;
    
    UIActivityViewController *activityViewController =
    [[UIActivityViewController alloc] initWithActivityItems:@[string, name]
                                      applicationActivities:nil];
    [self.navigationController presentViewController:activityViewController
                                            animated:YES
                                          completion:^{
                                              // ...
                                          }];
}
-(IBAction)directionsButtonPressed:(UIButton *)button mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view {
    NSLog(@"map it");
    NSArray *arrayMapItem = [NSArray arrayWithObjects:view.annotation, nil];
    BLSDataSource *ds = [BLSDataSource sharedInstance];
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

-(IBAction)deletePOIPressed:(UIButton *)button {
    NSLog(@"delete POI here");
}

/*-(IBAction)savePOIButtonPressed:(UIButton *)button {
    NSLog(@"save poi");
}*/

-(IBAction)addNoteButtonPressed:(UIButton *)button {
    NSLog(@"add Note");
}


#pragma mark add map functionality
- (BOOL)openInMapsWithLaunchOptions:(NSDictionary<NSString *,id> *)launchOptions {
    
    return YES;
}



//gives an annotation and returns a view for that annotation
/*-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    
    //detecting user interation with the annotated view
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    static NSString *reuseIdentifier = @"MapViewControllerLoc";
    MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:reuseIdentifier];
    if(!annotationView) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
        annotationView.canShowCallout = YES;
        UIButton *infoButton = [[UIButton alloc]init];
        [infoButton setBackgroundImage:[UIImage imageNamed:@"directions.png"] forState:UIControlStateNormal];
        [infoButton sizeToFit];
        //UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"redHeart.png"]];
        annotationView.leftCalloutAccessoryView = infoButton;
        
        UIButton *savePOIButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
        annotationView.rightCalloutAccessoryView = savePOIButton;
    }
    
    
    //annotationView = annotation;
    
    
    return annotationView;
    

}*/





-(void)updateAccessoryViewInAnnotationView:(MKAnnotationView *)annotationView {
    
    //this stuff needs to be in the notes object
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Save a note Location" message:nil delegate:self cancelButtonTitle:@"Continue" otherButtonTitles: nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField * alertTextField = [alert textFieldAtIndex:0];
    alertTextField.keyboardType = UIKeyboardTypeDefault;
    alertTextField.placeholder = @"Enter title of your tag";
    
    [alert  show];
    self.currentNote = alertTextField.text;
    NSLog(@"current note %@", self.currentNote);
    [[BLSDataSource sharedInstance] saveNoteToPOI:self.currentNote];
    
    BLSDataSource *ds = [BLSDataSource sharedInstance];
    ds.currentPOI = [[PointOfInterest alloc] initWithMKPointAnnotation:(MKPointAnnotation*)annotationView.annotation];
    
    //Add UIActivityViewController here?
    NSString *string = @"this can be the individual note to share";
    NSString *name = ds.currentPOI.title;
    //NSString *name = @"this will be the name";
    //ADD the point of interest name and number?
    
    //NSURL *URL = ...;
    
    UIActivityViewController *activityViewController =
    [[UIActivityViewController alloc] initWithActivityItems:@[string, name]
                                      applicationActivities:nil];
    [self.navigationController presentViewController:activityViewController
                                            animated:YES
                                          completion:^{
                                              // ...
                                          }];

    
    if (![ds.arrayOfPOIs containsObject:ds.currentPOI]) {
        [ds.arrayOfPOIs addObject:ds.currentPOI];
    }
    
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    BLSDataSource *ds = [BLSDataSource sharedInstance] ;
    if (control == view.rightCalloutAccessoryView) {
        NSArray *arrayMapItem = [NSArray arrayWithObjects:view.annotation, nil];
        
        [ds convertPointAnnotationsToPOI:arrayMapItem];
        [ds savePOIAndThen:^(MKLocalSearchResponse * _Nullable response, NSError * _Nullable error) {}];
        self.containerView.hidden = NO;
        
        
    } else if (control == view.leftCalloutAccessoryView){
       
    
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
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([sender isKindOfClass:[MKAnnotationView class]]) {
        [self prepareViewController:segue.destinationViewController forSegue:segue.identifier toShowAnnotation:((MKAnnotationView *) sender).annotation];
    }
    //prepare segue for embed
    if ([segue.identifier isEqualToString:@"showEmbed"]) {
        NSLog(@"showEmbed");
    } else if ([segue.identifier isEqualToString:@"showCategories"]) {
        NSLog(@"showCategories");
        
        
        UINavigationController *navc = (UINavigationController*)segue.destinationViewController;
        CategoryListViewController *clvc = (CategoryListViewController*)([navc viewControllers][0]);
        clvc.POI = self.currentPOI;
        
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



-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    //self.userLocationLabel.text =
    [NSString stringWithFormat:@"Location %.5f°, %.5f°", userLocation.coordinate.latitude, userLocation.coordinate.longitude];
     MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    //NSLog(@"%@", [locations lastObject]);
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
        
        //open MKMapItem in the maps app
        [itemPOI openInMapsWithLaunchOptions:nil];
        
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
