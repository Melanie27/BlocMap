//
//  Category.h
//  BlocSpot
//
//  Created by MELANIE MCGANNEY on 9/27/16.
//  Copyright © 2016 Bloc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIkit/UIkit.h>

@interface Category : NSObject <NSCoding>

@property (nonatomic, strong) NSString *uuid;
@property (nonatomic, strong) NSString *categoryName;

@property  BOOL inCategoryList;
@property (nonatomic, strong) NSMutableOrderedSet *categories;
@property (nonatomic, strong) UIColor *categoryColor;

//custom class method 
+ (Category *)createCategoryWithName:(NSString *)categoryName andColor:(UIColor *)categoryColor;

//+ (Category *)createCategoryWithName:(NSString *)categoryName;
//+ (Category *)saveColorToCategory:(UIColor*)categoryColor;

@end
