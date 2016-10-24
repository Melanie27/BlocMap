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
#import "POICategory.h"

@class SearchResultsTableViewController;
@class CategoryListViewController;
@class PointOfInterest;

typedef void (^MarkersSavedCompletionHandler)(NSArray *pois);
typedef void (^MarkersFilteredCompletionHandler)(NSArray *pois);
typedef void (^CategoriesSavedCompletionHandler)(NSArray *pois);

//typedef void (^SaveCatToPOICompletionHandler)(POICategory *currCat);

@interface BLSDataSource : NSObject <MKMapViewDelegate>
//add private mutable array
@property (nonatomic, strong) NSMutableArray *categories;

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
@property (nonatomic, strong) NSMutableArray<PointOfInterest*> *filteredArrayOfPOIs;
@property (nonatomic, strong) NSMutableArray<PointOfInterest*> *hiddenArrayOfPOIs;
@property (nonatomic, strong) NSMutableArray<POICategory*> *arrayOfCategories;
@property (nonatomic, strong) NSMutableArray<POICategory*> *filteredArrayOfCategories;
@property (atomic, strong) PointOfInterest* currentPOI;
@property (atomic, strong) POICategory* currentCategory;


-(void)loadSavedData:(MarkersSavedCompletionHandler)completionHandler;
//-(void)loadFilteredData:(MarkersSavedCompletionHandler)completionHandler;

- (void)convertMapItemsToPOI:(NSArray<MKMapItem *> *)mapItemsToSave;
- (void)convertPointAnnotationsToPOI:(NSArray<MKPointAnnotation *> *)pointAnnotationsToSave;

- (void) removeObjectFromArrayOfPOIsAtIndex:(NSUInteger)index;
-(void)saveNoteToPOI:(PointOfInterest*)note;
-(void)saveCategoryToPOI:(POICategory *)cat;
-(void)savePOIToCategory:(PointOfInterest*)poi;

//-(void)saveFilteredData:(MKLocalSearchCompletionHandler)completionHandler;


-(void)savePOIAndThen:(MKLocalSearchCompletionHandler)completionHandler;
-(void)saveData;
-(void) savePOI:(NSArray<MKMapItem *> *)mapItemsToSave andThen:(MKLocalSearchCompletionHandler)completionHandler;
-(void)searchMap:(NSString*)searchText andThen:(MKLocalSearchCompletionHandler)completionHandler;
-(void) deletePOIItem:(PointOfInterest *)item;
-(void)deleteCategory:(POICategory *)cat;
@end
