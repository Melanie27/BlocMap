//
//  Category.h
//  BlocSpot
//
//  Created by MELANIE MCGANNEY on 9/27/16.
//  Copyright © 2016 Bloc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIkit/UIkit.h>

@class PointOfInterest;

@interface POICategory : NSObject <NSCoding>

@property (nonatomic, strong) NSString *uuid;
@property (nonatomic, strong) NSString *categoryName;

@property  BOOL inCategoryList;
@property (nonatomic, strong) NSMutableOrderedSet *categories;
@property (nonatomic, strong) UIColor *categoryColor;
@property (nonatomic, strong) NSMutableArray *pointsOfInterest;

//custom class method 
+ (POICategory *)createCategoryWithName:(NSString *)categoryName andColor:(UIColor *)categoryColor;

+ (POICategory *)addPointOfInterest:(PointOfInterest *)pointOfInterest;

@end