//
//  PointOfInterest.m
//  BlocSpot
//
//  Created by MELANIE MCGANNEY on 9/20/16.
//  Copyright © 2016 Bloc. All rights reserved.
//

#import "PointOfInterest.h"


@implementation PointOfInterest

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if(self) {
        return nil;
    }
    
    self.poiName = [aDecoder decodeObjectForKey:@"name"];
    self.poiAddress = [aDecoder decodeObjectForKey:@"address"];
    self.poiPhoneNumber = [aDecoder decodeObjectForKey:@"phoneNumber"];
    self.poiNote = [aDecoder decodeObjectForKey:@"note"];
    self.poiUrl = [aDecoder decodeObjectForKey:@"url"];
    self.poiCategories = [aDecoder decodeObjectForKey:@"categories"];
    self.poiCategory = [aDecoder decodeObjectForKey:@"category"];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.poiName forKey:@"name"];
    [aCoder encodeObject:self.poiAddress forKey:@"address"];
    [aCoder encodeObject:self.poiPhoneNumber forKey:@"phoneNumber"];
    [aCoder encodeObject:self.poiNote forKey:@"note"];
    [aCoder encodeObject:self.poiUrl forKey:@"url"];
    [aCoder encodeObject:self.poiCategories forKey:@"categories"];
    [aCoder encodeObject:self.poiCategory forKey:@"category"];
    
}
@end
