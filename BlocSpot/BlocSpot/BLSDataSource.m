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

    self.latestSearchRequest.region = self.mapView.region;
    
    NSMutableArray *arrayOfPOIs = [[NSMutableArray alloc] init];
   
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
        
        
        NSMutableArray *placemarks = [NSMutableArray array];
        for (MKMapItem *mapItem in response.mapItems) {
            [placemarks addObject:mapItem.placemark];
            NSLog(@"placemarks %@", placemarks);
        }
        
        NSMutableArray *phoneNumbers = [NSMutableArray array];
        for (MKMapItem *mapItem in response.mapItems) {
            [phoneNumbers addObject:mapItem.phoneNumber];
            NSLog(@"phone numbers %@", phoneNumbers);
        }
        
        for (MKMapItem *item in response.mapItems) {
            NSString *name = item.name;
            NSLog(@"%@",name);
            [arrayOfPOIs addObject:name];
        }
        
        
        
         //[self.mapView loadTheDataAgain];
        
        //NSLog(@"BLSresponse bounding region %@", response.mapItems.boundingRegion.center.latitude );
        
        completionHandler(response, error);
        //[self.searchDisplayController.searchResultsTableViewController reloadData];*/
         }];
}

@end
