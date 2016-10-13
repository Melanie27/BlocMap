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



-(void)updateAccessoryViewInAnnotationView:(MKAnnotationView *)annotationView {
    
    BLSDataSource *ds = [BLSDataSource sharedInstance];
    ds.currentPOI = [[PointOfInterest alloc] initWithMKPointAnnotation:(MKPointAnnotation*)annotationView.annotation];
    
    //Call Activity Controller
    /*NSString *string = @"this can be the individual note to share";
    //NSString *subtitle = ds.currentPOI.subtitle;
    NSString *name = ds.currentPOI.title;
    UIActivityViewController *activityViewController =
    [[UIActivityViewController alloc] initWithActivityItems:@[name, string]
                                      applicationActivities:nil];
    [self.navigationController presentViewController:activityViewController
                                            animated:YES
                                          completion:^{
                                              // ...
                                          }];*/
    
    
    
    
    if (![ds.arrayOfPOIs containsObject:ds.currentPOI]) {
        [ds.arrayOfPOIs addObject:ds.currentPOI];
    }
    
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    BLSDataSource *ds = [BLSDataSource sharedInstance];
    if (control == view.rightCalloutAccessoryView) {
        NSArray *arrayMapItem = [NSArray arrayWithObjects:view.annotation, nil];
        
        [ds convertPointAnnotationsToPOI:arrayMapItem];
        [ds savePOIAndThen:^(MKLocalSearchResponse * _Nullable response, NSError * _Nullable error) {}];
        self.containerView.hidden = NO;
        
       
        
    } else if (control == view.leftCalloutAccessoryView){
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Points of Interest"
                                                                       message:@"Do Stuff"
                                                                preferredStyle:UIAlertControllerStyleActionSheet]; // 1
        UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"get directions"
                                                              style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                  NSArray *arrayMapItem = [NSArray arrayWithObjects:view.annotation, nil];
                                                                  
                                                                  for (int i=0; i<[arrayMapItem count]; i++ ) {
                                                                      MKPointAnnotation* savedPoint = arrayMapItem[i];
                                                                      //NSLog(@"MKPointAnnotation %@", savedPoint);
                                                                      
                                                                      
                                                                      MKPlacemark *mapDest = [[MKPlacemark alloc]
                                                                                              initWithCoordinate:savedPoint.coordinate
                                                                                              addressDictionary:nil];
                                                                      
                                                                      //NSLog(@"mkdest %@", mapDest);
                                                                      
                                                                      MKMapItem *thisItem = [[MKMapItem alloc] initWithPlacemark:mapDest];
                                                                      [thisItem openInMapsWithLaunchOptions:nil];
                                                                  }
                                                                  
                                                              }];
        UIAlertAction *secondAction = [UIAlertAction actionWithTitle:@"add a brief note to poi"
                                                               style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Poi Note"
                                                                                                                   message:@"Add a brief note:"
                                                                                                                  delegate:self
                                                                                                         cancelButtonTitle:@"Done"
                                                                                                         otherButtonTitles:nil];
                                                                   
                                                                   alert.alertViewStyle = UIAlertViewStylePlainTextInput;
                                                                   UITextField *textField = [alert textFieldAtIndex:0];
                                                                   textField.keyboardType = UIKeyboardTypeDefault;
                                                                   textField.placeholder = @"Enter some text";
                                                                   
                                                                   [alert show];
                                                                   NSLog(@"add a brief note");
                                                                   
                                                               }];
        UIAlertAction *thirdAction = [UIAlertAction actionWithTitle:@"share poi"
                                                              style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                  NSLog(@"share poi");
                                                                  [self shareButtonPressed:self.annotationView];
                                                                  
                                                              }];
        UIAlertAction *fourthAction = [UIAlertAction actionWithTitle:@"delete poi"
                                                               style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
                                                                   NSLog(@"delete poi");
                                                                   
                                                               }];
        UIAlertAction *fifthAction = [UIAlertAction actionWithTitle:@"cancel"
                                                              style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
                                                                  NSLog(@"cancel");
                                                                  
                                                              }]; // 3
        
        [alert addAction:firstAction];
        [alert addAction:secondAction];
        [alert addAction:thirdAction];
        [alert addAction:fourthAction];
        [alert addAction:fifthAction];
        
        [self presentViewController:alert animated:YES completion:nil]; // 6
        //[self alertView:alert clickedButtonAtIndex:buttonIndex];
        
        /**/
    } else if (control == view.detailCalloutAccessoryView) {
        NSLog(@"write a note");
    }
    
}

- (void)alertView:(UIAlertView *)alert clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex > 0) {
        NSLog(@"is this being called??");
        UITextField *textField = [alert textFieldAtIndex:0];
        NSString *text = textField.text;
        NSLog(@"text %@", text);
        if(text == nil) {
            return;
        } else {
            //do something with text
        }
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


//BUILDING THE CUSTOM CALLOUT WITH MULTIPLE BUTTONS

/*- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
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
 CGFloat yourSelectedFontSize = 8.0 ;
 self.noteForPOI = [[UITextField alloc] initWithFrame:CGRectMake(0, 25, 140, 20)];
 UIFont *yourNewSameStyleFont = [self.noteForPOI.font fontWithSize:yourSelectedFontSize];
 self.noteForPOI.font = yourNewSameStyleFont;
 self.noteForPOI.layer.cornerRadius=8.0f;
 self.noteForPOI.layer.masksToBounds=NO;
 self.noteForPOI.layer.borderColor=[[UIColor redColor]CGColor];
 self.noteForPOI.layer.borderWidth= 1.0f;
 self.noteForPOI.placeholder = @"add a note";
 self.noteForPOI.minimumFontSize = 10;
 
 self.currentNote.noteText = self.noteForPOI.text;
 NSLog(@"note text %@", self.currentNote.noteText);
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
 
 [vw addSubview:self.noteForPOI];
 [vw addSubview:triggerShareButton];
 [vw addSubview:directionsButton];
 //[vw addSubview:savePOIButton];
 [vw addSubview:addNoteButton];
 [vw addSubview:deleteButton];
 
 
 [triggerShareButton addTarget:self action:@selector(shareButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
 
 [directionsButton addTarget:self action:@selector( directionsButtonPressed:annotationView:) forControlEvents:UIControlEventTouchUpInside];
 
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
 }*/

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



-(IBAction)shareButtonPressed: (MKAnnotationView *)view {
    BLSDataSource *ds = [BLSDataSource sharedInstance];
    ds.currentPOI = [[PointOfInterest alloc] initWithMKPointAnnotation:(MKPointAnnotation*)view.annotation];
    //Add UIActivityViewController here?
    NSString *string = @"this can be the individual note to share";
    
    //NSLog(@"current poi %@", self.currentPOI.title);
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

-(IBAction)deletePOIPressed:(UIButton *)button {
    NSLog(@"delete POI here");
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


@end
