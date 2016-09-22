//
//  BLSDataSource.m
//  BlocSpot
//
//  Created by MELANIE MCGANNEY on 9/20/16.
//  Copyright © 2016 Bloc. All rights reserved.
//

#import "BLSDataSource.h"

@implementation BLSDataSource

MKLocalSearch *localSearch;

+(instancetype) sharedInstance {
    //the dispatch_once function ensures we only create a single instance of this class. function takes a block of code and runs it only the first time it is called
    static dispatch_once_t once;
    
    //a static variable "sharedInstance" holds the shared instance
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
        
    });
    return sharedInstance;
}

-(instancetype) init {
    self = [super init];
    
    if(self) {
        
    }
    
    return self;
}
-(void)searchMap:(NSString *)searchText andThen:(MKLocalSearchCompletionHandler)completionHandler {
    //cancel previous searches
    [localSearch cancel];
    
    self.latestSearchRequest = [[MKLocalSearchRequest alloc] init];
    self.latestSearchRequest.naturalLanguageQuery = searchText;
    
    //set the region - make the region narrower?
    CLLocationCoordinate2D laLocation= CLLocationCoordinate2DMake(34.0195, -118.4912);
    self.mapView.region = MKCoordinateRegionMakeWithDistance(laLocation, 1000000, 1000000);
    
    //CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(43.62862, -79.331245);
    //[self.mapView setRegion:MKCoordinateRegionMake(coordinate, MKCoordinateSpanMake(0.01f, 0.01f))];
    self.latestSearchRequest.region = self.mapView.region;
    
    
    localSearch = [[MKLocalSearch alloc] initWithRequest:self.latestSearchRequest];
    
    [localSearch startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error){
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        if (error != nil) {
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Map Error",nil)
                                        message:[error localizedDescription]
                                       delegate:nil
                              cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil] show];
            return;
        }
        
        if ([response.mapItems count] == 0) {
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No Results",nil)
                                        message:nil
                                       delegate:nil
                              cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil] show];
            return;
        }
        
        self.results = response;
        NSLog(@"map items %@", response.mapItems );
        NSLog(@"BLSresponse %@", response );
        
        completionHandler(response, error);
        //[self.searchDisplayController.searchResultsTableViewController reloadData];*/
         }];
}

@end
