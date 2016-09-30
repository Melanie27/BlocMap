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

@property (nonatomic, strong) NSString *categoryName;
@property (nonatomic, strong) UIColor *categoryColor;
@property (nonatomic, strong) NSMutableOrderedSet *categories;


+ (instancetype)orderedSetWithArray:(NSArray<Category *> *)array;
@end
