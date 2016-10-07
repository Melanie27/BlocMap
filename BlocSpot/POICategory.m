//
//  Category.m
//  BlocSpot
//
//  Created by MELANIE MCGANNEY on 9/27/16.
//  Copyright © 2016 Bloc. All rights reserved.
//

#import "POICategory.h"

@implementation POICategory

-(instancetype) initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    
    if(self) {
        self.uuid = [aDecoder decodeObjectForKey:@"uuid"];
        self.categoryName = [aDecoder decodeObjectForKey:@"categoryName"];
        self.inCategoryList = [aDecoder decodeBoolForKey:@"inCategoryList"];
        self.categoryColor = [aDecoder decodeObjectForKey:@"categoryColor"];
    }
    
    return self;
}

-(void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.uuid forKey:@"uuid"];
    [aCoder encodeObject:self.categoryName forKey:@"categoryName"];
    [aCoder encodeBool:self.inCategoryList forKey:@"inCategoryList"];
    [aCoder encodeObject:self.categoryColor forKey:@"categoryColor"];
}

+ (POICategory *)createCategoryWithName:(NSString *)categoryName andColor:(UIColor *)categoryColor {
    
    //init category
    POICategory *category = [[POICategory alloc]init];
    
    //Config
    [category setCategoryName:categoryName];
    [category setInCategoryList:NO];
    [category setUuid:[[NSUUID UUID] UUIDString]];
    [category setCategoryColor:categoryColor];
    
    return category;
    
}

+ (POICategory *)addPointOfInterest:(PointOfInterest *)pointOfInterest {
    POICategory *category = [[POICategory alloc]init];
    
    
    return category;
}


@end
