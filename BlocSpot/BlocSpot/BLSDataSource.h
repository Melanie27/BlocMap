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

@interface BLSDataSource : NSObject


//use singleton pattern so that any code needing to use this class can share the single instance
+(instancetype) sharedInstance;

@property (nonatomic, strong) MKLocalSearchRequest *latestSearchRequest;




-(void)searchMap:(NSString*)searchText andThen:(MKLocalSearchCompletionHandler)completionHandler;
@end
