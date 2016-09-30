//
//  Category.m
//  BlocSpot
//
//  Created by MELANIE MCGANNEY on 9/27/16.
//  Copyright © 2016 Bloc. All rights reserved.
//

#import "Category.h"

@implementation Category

-(instancetype) initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    
    if(self) {
        self.categoryName = [aDecoder decodeObjectForKey:@"categoryName"];
        self.categoryColor = [aDecoder decodeObjectForKey:@"categoryName"];
    }
    
    return self;
}

-(void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.categoryName forKey:@"categoryName"];
    [aCoder encodeObject:self.categoryColor forKey:@"categoryColor"];
}

@end
