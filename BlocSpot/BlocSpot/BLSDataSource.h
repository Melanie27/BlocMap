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

@class SearchResultsTableViewController;

@interface BLSDataSource : NSObject <MKMapViewDelegate>


//use singleton pattern so that any code needing to use this class can share the single instance
+(instancetype) sharedInstance;

@property (nonatomic, strong) MKLocalSearchRequest *latestSearchRequest;
@property (nonatomic, strong) MKLocalSearchResponse *results;
@property (strong, nonatomic) MKMapView *mapView;
@property (strong, nonatomic) MKAnnotationView *view;
@property(nonatomic, assign) MKCoordinateRegion region;
@property (nonatomic, weak) SearchResultsTableViewController *srtvc;
@property (retain, nonatomic) NSMutableArray *annotations;
@property (nonatomic) BOOL itemSelected;


-(void)savePOI:(MKAnnotationView *)view;
-(void)searchMap:(NSString*)searchText andThen:(MKLocalSearchCompletionHandler)completionHandler;
@end
