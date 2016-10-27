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


- (instancetype)initWithMKMapItem:(MKMapItem*)mapItem;
- (instancetype)initWithMKPlacemark:(MKPlacemark*)placemark;
- (instancetype)initWithMKPointAnnotation:(MKPointAnnotation*)pointAnnotation;



- (MKMapItem*)mapItem;
//adding a note to a poi when it's selected
@property (nonatomic, strong) NSString *noteText;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *subtitle;
//@property (nonatomic, strong) POICategory *poi;
@property (nonatomic, strong) POICategory *category;
@property (nonatomic, strong) NSString *categoryName;
@property (nonatomic, strong) UIColor *categoryColor;
@property (nonatomic) BOOL itemSelected;
@property (copy) NSString *address;
@property (assign, nonatomic) CLLocationCoordinate2D coordinate;
@property (copy) NSNumber *identifier;

//@property (nonatomic, copy) NSString *imageKey;
//@property (nonatomic, copy) UIImage *image;
//@property (nonatomic) BOOL animatesDrop;
//@property (nonatomic) BOOL canShowCallout;



@end
