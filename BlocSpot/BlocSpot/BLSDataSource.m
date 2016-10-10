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

@interface BLSDataSource () {
    NSMutableArray *_arrayOfPOIs;
}
@end

@implementation BLSDataSource
NSMutableArray *arrayOfPOIs;
NSMutableArray *arrayOfCategories;
MKLocalSearch *localSearch;
//NSMutableArray *arrayOfCategories;

+(instancetype) sharedInstance {
    //the dispatch_once function ensures we only create a single instance of this class. function takes a block of code and runs it only the first time it is called
    static dispatch_once_t once;
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


#pragma mark - Key/Value Observing


- (NSUInteger) countOfArrayOfCategories {
    return self.arrayOfCategories.count;
}

- (id) objectInArrayOfCategoriesAtIndex:(NSUInteger)index {
    return [self.arrayOfCategories objectAtIndex:index];
}

- (NSArray *) arrayOfCategoriesAtIndexes:(NSIndexSet *)indexes {
    return [self.arrayOfCategories objectsAtIndexes:indexes];
}

- (void) insertObject:(PointOfInterest *)object inArrayOfCategoriesAtIndex:(NSUInteger)index {
    [_arrayOfCategories insertObject:object atIndex:index];
}

- (void) removeObjectFromArrayOfCategoriesAtIndex:(NSUInteger)index {
    [_arrayOfCategories removeObjectAtIndex:index];
}

- (void) replaceObjectInArrayOfCategoriesAtIndex:(NSUInteger)index withObject:(id)object {
    [_arrayOfCategories replaceObjectAtIndex:index withObject:object];
}



#pragma load up all the saved mapitems

-(void) loadSavedCategories:(CategoriesSavedCompletionHandler)completionHandler {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *fullPath = [self pathForFilename:@"categories.poi"];
        NSMutableArray<PointOfInterest*> *storedCategories = [[NSKeyedUnarchiver unarchiveObjectWithFile:fullPath] mutableCopy];
        
         self.arrayOfCategories = storedCategories;
        NSLog(@"load saved categories %@", storedCategories);
        completionHandler(storedCategories);
        
    });
}

-(void)loadSavedMarkers:(MarkersSavedCompletionHandler)completionHandler {
    //NSLog(@"load saved markers");
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *fullPath = [self pathForFilename:@"mapItems.poi"];
        NSMutableArray<PointOfInterest*> *storedMapItems = [[NSKeyedUnarchiver unarchiveObjectWithFile:fullPath] mutableCopy];
        
        self.arrayOfPOIs = storedMapItems;
        completionHandler(storedMapItems);
        
    });
}

#pragma saving to disc
- (NSString *) pathForFilename:(NSString *) filename {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject];
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:filename];
    return dataPath;
}


- (void)convertMapItemsToPOI:(NSArray<MKMapItem *> *)mapItemsToSave {
    
    NSMutableArray *newArrayOfPOIs = [[NSMutableArray alloc] init];
    if (newArrayOfPOIs == nil) {
        newArrayOfPOIs = [NSMutableArray arrayWithCapacity:100];
    }

    for (MKMapItem *mapItem in mapItemsToSave) {
        PointOfInterest *item = [[PointOfInterest alloc] initWithMKMapItem:mapItem];
        [newArrayOfPOIs addObject:item];
    }
    self.arrayOfPOIs = newArrayOfPOIs;
}

- (void)saveCategoryToPOI:(NSArray<POICategory *> *)poiCategoriesToSave {
    
    NSMutableArray *arrayOfCategories = [[NSMutableArray alloc] init];
    
    for (POICategory *poiCategory in poiCategoriesToSave) {
        PointOfInterest *itemCategory = [[PointOfInterest alloc] initWithPOICategory:poiCategory];
        NSLog(@"item category %@", itemCategory);
       
        _currentPOI.categoryName = itemCategory.categoryName;
        [arrayOfCategories addObject:itemCategory];
        
    }
    //NSLog(@"current poi cat name %@", _currentPOI.categoryName);
    NSLog(@"array of cats %@", self.arrayOfCategories);
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *fullPath = [self pathForFilename:@"categories.poi"];
        NSData *poiCategoryData = [NSKeyedArchiver archivedDataWithRootObject:_currentPOI.categoryName];
        
        NSError *dataError;
        BOOL wroteSuccessfully = [poiCategoryData writeToFile:fullPath options:NSDataWritingAtomic | NSDataWritingFileProtectionCompleteUnlessOpen error:&dataError];
        NSLog(@"category data %@",  poiCategoryData);
        if (!wroteSuccessfully) {
            NSLog(@"Couldn't write file: %@", dataError);
        }
        
     });
                   
}
  


- (void)convertPointAnnotationsToPOI:(NSArray<MKPointAnnotation *> *)pointAnnotationsToSave {
    //init this array with already stored items
    NSString *fullPath = [self pathForFilename:@"mapItems.poi"];
    NSMutableArray<PointOfInterest*> *newArrayOfPOIs = [[NSKeyedUnarchiver unarchiveObjectWithFile:fullPath] mutableCopy];
    if (newArrayOfPOIs == nil) {
        newArrayOfPOIs = [NSMutableArray arrayWithCapacity:100];
    }
   
    
    for (MKPointAnnotation *pointAnnotation in pointAnnotationsToSave) {
        PointOfInterest *item = [[PointOfInterest alloc] initWithMKPointAnnotation:pointAnnotation];
        [newArrayOfPOIs addObject:item];
    }
    self.arrayOfPOIs = newArrayOfPOIs;
    NSLog(@"new array %@", newArrayOfPOIs);
}

- (void) savePOIAndThen:(MKLocalSearchCompletionHandler)completionHandler{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       
        
        
        NSString *fullPath = [self pathForFilename:@"mapItems.poi"];
        NSData *mapItemData = [NSKeyedArchiver archivedDataWithRootObject:self.arrayOfPOIs];
        
        NSError *dataError;
        BOOL wroteSuccessfully = [mapItemData writeToFile:fullPath options:NSDataWritingAtomic | NSDataWritingFileProtectionCompleteUnlessOpen error:&dataError];
        NSLog(@"map item data %@", self.arrayOfPOIs);
        if (!wroteSuccessfully) {
            NSLog(@"Couldn't write file: %@", dataError);
        }
        
        completionHandler(nil,nil);
        //self.arrayOfPOIs = newArrayOfPOIs;
    });
}




- (void) savePOI:(NSArray<MKMapItem *> *)mapItemsToSave andThen:(MKLocalSearchCompletionHandler)completionHandler{
   
    [self convertMapItemsToPOI:mapItemsToSave];
    [self savePOIAndThen:completionHandler];
}



-(void)searchMap:(NSString *)searchText andThen:(MKLocalSearchCompletionHandler)completionHandler {
    //cancel previous searches
    [localSearch cancel];
    //remove unsaved annotations?
    
    self.latestSearchRequest = [[MKLocalSearchRequest alloc] init];
    self.latestSearchRequest.naturalLanguageQuery = searchText;
    self.latestSearchRequest.region = self.mapView.region;
    
    localSearch = [[MKLocalSearch alloc] initWithRequest:self.latestSearchRequest];
    
    [localSearch startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error){
    NSMutableArray *responsePOIs = [NSMutableArray arrayWithObjects:response.mapItems, nil];
    NSLog(@"pois, %@", responsePOIs);
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
       
        
        
        for (MKMapItem *item in response.mapItems) {
            NSString *name = item.name;
            NSLog(@"%@",name);
            PointOfInterest *poi = [[PointOfInterest alloc] initWithMKMapItem:item];
            [self.arrayOfPOIs addObject:poi];
        }
    
                completionHandler(response, error);

         }];
    
    
}


@end
