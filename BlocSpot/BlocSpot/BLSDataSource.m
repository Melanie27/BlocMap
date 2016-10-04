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
NSMutableArray *arrayOfPOIs;
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
        
        
            
       
    }
    
    return self;
}

#pragma load up all the saved mapitems


-(void)loadSavedMarkers:(MarkersSavedCompletionHandler)completionHandler {
    NSLog(@"load saved markers");
    //TODO Create an array where everything is stored show it shows up again on launch
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *fullPath = [self pathForFilename:@"mapItems.poi"];
        NSMutableArray<PointOfInterest*> *storedMapItems = [NSKeyedUnarchiver unarchiveObjectWithFile:fullPath];
        
        self.arrayOfPOIs = storedMapItems;
        completionHandler(storedMapItems);
        /*
        //NEED TO GET ALL THE ELEMENTS OF THESE STORED MAP ITEMS SO CAN CREATE PLACEMARK
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(storedMapItems.count > 0) {
                NSLog(@"number of stored map items %lu", (unsigned long)storedMapItems.count);
                
                //For each stored map item put a pin on the map!
                for (int i=0; i<[storedMapItems count]; i++) {
                    PointOfInterest *mapItem = storedMapItems[i];
                    
                    //NSLog(@"map item %@", mapItem);
                    //NSLog(@"map item title %@", mapItem.title);
                    //NSLog(@"map item subtitle %@", mapItem.subtitle);
                    //NSLog(@"map item indentifier %@", mapItem.identifier);
                    //NSLog(@"map item coordinate %f,%f", mapItem.coordinate.latitude,mapItem.coordinate.longitude);
                    
                    
                    //ADDING THE ANNOTATIONS
                    
                    MKPointAnnotation *marker = [MKPointAnnotation new];
                    marker.coordinate = CLLocationCoordinate2DMake(mapItem.coordinate.latitude, mapItem.coordinate.longitude);
                    
                    marker.title = mapItem.title;
                    marker.subtitle = mapItem.subtitle;
                    [arrayOfPOIs addObject:marker];
                    NSLog(@"map view %@",arrayOfPOIs);
                    //map does not exist here - move things around
                   
                    [self.mvc loadView];
                    [self.mapView addAnnotation:marker];
                    
                    
                }
            }
            
        });
        */
    });
}

#pragma saving to disc
- (NSString *) pathForFilename:(NSString *) filename {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject];
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:filename];
    return dataPath;
}

- (void) savePOI:(NSArray<MKMapItem *> *)mapItemsToSave andThen:(MKLocalSearchCompletionHandler)completionHandler{
   
        NSMutableArray *arrayOfPOIs = [[NSMutableArray alloc] init];

            MKMapItem *mapItem = [[MKMapItem alloc] init];
            //only want the result that has been clicked
            PointOfInterest *item = [[PointOfInterest alloc] initWithMKMapItem:mapItem];
            NSLog(@"item to save %@", mapItemsToSave);
                        [arrayOfPOIs addObject:item];

    
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSUInteger numberOfItemsToSave = MIN(arrayOfPOIs.count, 50);
            NSArray *mapItemsToSave = [arrayOfPOIs subarrayWithRange:NSMakeRange(0, numberOfItemsToSave)];
            NSString *fullPath = [self pathForFilename:@"mapItems.poi"];
            NSData *mapItemData = [NSKeyedArchiver archivedDataWithRootObject:mapItemsToSave];
        
            NSError *dataError;
            BOOL wroteSuccessfully = [mapItemData writeToFile:fullPath options:NSDataWritingAtomic | NSDataWritingFileProtectionCompleteUnlessOpen error:&dataError];
            NSLog(@"map item data %@", mapItemData);
            if (!wroteSuccessfully) {
                NSLog(@"Couldn't write file: %@", dataError);
            }
            
        
        });
 
}



-(void)searchMap:(NSString *)searchText andThen:(MKLocalSearchCompletionHandler)completionHandler {
    //cancel previous searches
    //[localSearch cancel];
    
    self.latestSearchRequest = [[MKLocalSearchRequest alloc] init];
    self.latestSearchRequest.naturalLanguageQuery = searchText;
    self.latestSearchRequest.region = self.mapView.region;
    
    localSearch = [[MKLocalSearch alloc] initWithRequest:self.latestSearchRequest];
    
    [localSearch startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error){
    NSMutableArray *arrayOfPOIs = [NSMutableArray arrayWithObjects:response.mapItems, nil];
    NSLog(@"pois, %@", arrayOfPOIs);
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
        NSLog(@"response, %@", response);
       
        
        NSMutableArray *placemarks = [NSMutableArray array];
        for (MKMapItem *mapItem in response.mapItems) {
            [placemarks addObject:mapItem.placemark];
            NSLog(@"placemarks %@", placemarks);
        }
        
        NSMutableArray *phoneNumbers = [NSMutableArray array];
       
            for (MKMapItem *mapItem in response.mapItems) {
                if(mapItem.phoneNumber) {
                    [phoneNumbers addObject:mapItem.phoneNumber];
                    NSLog(@"phone numbers %@", phoneNumbers);
                } else {
                    mapItem.phoneNumber = nil;
                }
            }
        
        
        for (MKMapItem *item in response.mapItems) {
            NSString *name = item.name;
            NSLog(@"%@",name);
            [arrayOfPOIs addObject:name];
        }
    
                completionHandler(response, error);

         }];
    
    
}


@end
