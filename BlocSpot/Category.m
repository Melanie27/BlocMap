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
        self.uuid = [aDecoder decodeObjectForKey:@"uuid"];
        self.categoryName = [aDecoder decodeObjectForKey:@"categoryName"];
        self.categoryColor = [aDecoder decodeObjectForKey:@"categoryName"];
        self.inCategoryList = [aDecoder decodeBoolForKey:@"inCategoryList"];
    }
    
    return self;
}

-(void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.uuid forKey:@"uuid"];
    [aCoder encodeObject:self.categoryName forKey:@"categoryName"];
    [aCoder encodeObject:self.categoryColor forKey:@"categoryColor"];
    [aCoder encodeBool:self.inCategoryList forKey:@"inCategoryList"];
}

+(Category *)createCategoryWithName:(NSString *)categoryName andColor:(UIColor *)categoryColor {
    
    //init category
    Category *category = [[Category alloc]init];
    
    //Config
    [category setCategoryName:categoryName];
    [category setCategoryColor:categoryColor];
    [category setInCategoryList:NO];
    [category setUuid:[[NSUUID UUID] UUIDString]];
    
    return category;
}

@end
