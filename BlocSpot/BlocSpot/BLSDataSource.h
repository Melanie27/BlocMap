//
//  BLSDataSource.h
//  BlocSpot
//
//  Created by MELANIE MCGANNEY on 9/20/16.
//  Copyright © 2016 Bloc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/Mapkit.h>
#import <CoreLocation/CoreLocation.h>
#import "MapViewController.h"

@class SearchResultsTableViewController;
@class PointOfInterest;

typedef void (^MarkersSavedCompletionHandler)(NSArray *pois);

@interface BLSDataSource : NSObject <MKMapViewDelegate>


//use singleton pattern so that any code needing to use this class can share the single instance
+(instancetype) sharedInstance;

@property (nonatomic, strong) MKLocalSearchRequest *latestSearchRequest;
@property (nonatomic, strong) MKLocalSearchResponse *results;
@property (strong, nonatomic) MKMapView *mapView;
@property (strong, nonatomic) MKAnnotationView *view;
@property(nonatomic, assign) MKCoordinateRegion region;
@property (nonatomic, weak) SearchResultsTableViewController *srtvc;
@property (nonatomic, weak) MapViewController *mvc;
@property (retain, nonatomic) NSMutableArray *annotations;
@property (nonatomic) BOOL itemSelected;
@property (nonatomic, strong) NSMutableArray<PointOfInterest*> *arrayOfPOIs;

-(void)loadSavedMarkers:(MarkersSavedCompletionHandler)completionHandler;

- (void)convertMapItemsToPOI:(NSArray<MKMapItem *> *)mapItemsToSave;
- (void)convertPointAnnotationsToPOI:(NSArray<MKPointAnnotation *> *)pointAnnotationsToSave;
- (void)savePOIAndThen:(MKLocalSearchCompletionHandler)completionHandler;
- (void) savePOI:(NSArray<MKMapItem *> *)mapItemsToSave andThen:(MKLocalSearchCompletionHandler)completionHandler;;
-(void)searchMap:(NSString*)searchText andThen:(MKLocalSearchCompletionHandler)completionHandler;

@end
