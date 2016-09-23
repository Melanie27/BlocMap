//
//  PointOfInterest.h
//  BlocSpot
//
//  Created by MELANIE MCGANNEY on 9/20/16.
//  Copyright © 2016 Bloc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PointOfInterest : NSObject <NSCoding>

@property NSString *poiName;
@property NSString *poiAddress;
@property NSString *poiPhoneNumber;
@property NSString *poiNote;
@property NSURL *poiUrl;
@property NSSet *poiCategories;
@property NSString *poiCategory;

@end
