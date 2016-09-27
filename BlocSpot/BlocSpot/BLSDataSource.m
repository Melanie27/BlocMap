//
//  BLSDataSource.m
//  BlocSpot
//
//  Created by MELANIE MCGANNEY on 9/20/16.
//  Copyright © 2016 Bloc. All rights reserved.
//

#import "BLSDataSource.h"
#import "SearchResultsTableViewCell.h"
#import "PointOfInterest.h"


@implementation BLSDataSource

MKLocalSearch *localSearch;

+(instancetype) sharedInstance {
    //the dispatch_once function ensures we only create a single instance of this class. function takes a block of code and runs it only the first time it is called
    static dispatch_once_t once;
    
    //a static variable "sharedInstance" holds the shared instance
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
        //read the saved files at launch so saved pins appear
        
        
        
        
        
    });
    return sharedInstance;
}

-(instancetype) init {
    self = [super init];
    
    if(self) {
        
        //TODO Unarchive the saved map data here
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSString *fullPath = [self pathForFilename:@"mapItems.poi"];
            NSLog(@"fullpath saved items %@", fullPath);
            //get the saved map items
            NSArray *storedMapItems = [NSKeyedUnarchiver unarchiveObjectWithFile:fullPath];
            NSLog(@"stored map items %@", storedMapItems);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if(storedMapItems.count > 0) {
                    NSLog(@"number of stored map items %lu", (unsigned long)storedMapItems.count);
                    MKMapItem *mapItem = [[MKMapItem alloc] init];
                    PointOfInterest *item = [[PointOfInterest alloc] initWithMKMapItem:mapItem];
                    
                    //add the markers for the saved items
                    
                    
                    
                    
                    for (int i=0; i<[storedMapItems count]; i++) {
                       MKMapItem *mapItem = storedMapItems[i];
                        MKMapItem *itemPOI = storedMapItems[i];
                        NSLog(@"mapitem %@", mapItem);
                        NSLog(@"itemPOI %@", itemPOI);
                        //MKPlacemark *annotation = [[MKPlacemark alloc] initWithPlacemark:mapItem.placemark];
                         //MKPlacemark *annotation = [[MKPlacemark alloc] initWithPlacemark:itemPOI.placemark];
                        //NSLog(@"anno %@", annotation);
                        //MKPointAnnotation *marker = [MKPointAnnotation new];
                        //marker.coordinate = CLLocationCoordinate2DMake(annotation.coordinate.latitude, annotation.coordinate.longitude);
                        //marker.title = itemPOI.placemark.name;
                        //marker.subtitle = itemPOI.phoneNumber;
                        
                        //[self.mapView addAnnotation:marker];
                        
                    }
                
                }
            
            
            });
            
        });
            
       
    }
    
    return self;
}

#pragma saving to disc
- (NSString *) pathForFilename:(NSString *) filename {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject];
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:filename];
    return dataPath;
}

- (void) savePOI {
   
    //if (response.mapItems.count > 0) {
     // Write the changes to disk
    
     localSearch = [[MKLocalSearch alloc] initWithRequest:self.latestSearchRequest];
    [localSearch startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error){
        NSMutableArray *arrayOfPOIs = [[NSMutableArray alloc] init];
        for (MKMapItem *mapItem in response.mapItems) {
            PointOfInterest *item = [[PointOfInterest alloc] initWithMKMapItem:mapItem];
            // add if it's been clicked here
            //BOOL itemWasClicked
            if (1) {
                [arrayOfPOIs addObject:item];
            }
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSUInteger numberOfItemsToSave = MIN(arrayOfPOIs.count, 50);
            NSArray *mapItemsToSave = [arrayOfPOIs subarrayWithRange:NSMakeRange(0, numberOfItemsToSave)];
            
            
            NSLog(@"map items to save %@", mapItemsToSave);
            NSString *fullPath = [self pathForFilename:@"mapItems.poi"];
            NSLog(@"fullpath %@", fullPath);
            NSData *mapItemData = [NSKeyedArchiver archivedDataWithRootObject:mapItemsToSave];

     
            NSError *dataError;
            BOOL wroteSuccessfully = [mapItemData writeToFile:fullPath options:NSDataWritingAtomic | NSDataWritingFileProtectionCompleteUnlessOpen error:&dataError];
            NSLog(@"map item data %@", mapItemData);
            if (!wroteSuccessfully) {
                NSLog(@"Couldn't write file: %@", dataError);
            }
            
        
        });
            
    }];

    
}



-(void)searchMap:(NSString *)searchText andThen:(MKLocalSearchCompletionHandler)completionHandler {
    //cancel previous searches
    //[localSearch cancel];
    
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
        

                completionHandler(response, error);

       
         }];
    
    //[self.srtvc.tableView reloadData];
}

@end
