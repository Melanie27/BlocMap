//
//  PointOfInterest.h
//  BlocSpot
//
//  Created by MELANIE MCGANNEY on 9/20/16.
//  Copyright © 2016 Bloc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mapkit/Mapkit.h>
#import "POICategory.h"
    
@interface PointOfInterest : NSObject <NSCoding, MKAnnotation>

- (id)initWithAddress:(NSString*)address
           coordinate:(CLLocationCoordinate2D)coordinate
                title:(NSString *)t
                subtitle:(NSString *)s
           identifier:(NSNumber *)ident;


-(id)initWithCategoryName:(NSString *)categoryName;



- (instancetype)initWithMKMapItem:(MKMapItem*)mapItem;
- (instancetype)initWithMKPointAnnotation:(MKPointAnnotation*)pointAnnotation;
-(instancetype)initWithPOICategory:(POICategory *)poiCategory;



- (MKMapItem*)mapItem;


@property (nonatomic, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *subtitle;
@property (nonatomic, strong) POICategory *category;
@property (nonatomic, strong) NSString *categoryName;
//@property (nonatomic, strong) UIColor *categorycolor;
//@property (nonatomic) BOOL animatesDrop;
@property (nonatomic) BOOL canShowCallout;
@property (nonatomic) BOOL itemSelected;

@property (copy) NSString *address;
@property (assign, nonatomic) CLLocationCoordinate2D coordinate;
@property (copy) NSNumber *identifier;
@property (nonatomic, copy) NSString *imageKey;
@property (nonatomic, copy) UIImage *image;



@end
