//
//  PointOfInterest.h
//  BlocSpot
//
//  Created by MELANIE MCGANNEY on 9/20/16.
//  Copyright © 2016 Bloc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mapkit/Mapkit.h>
    
@interface PointOfInterest : NSObject <NSCoding, MKAnnotation>

- (id)initWithAddress:(NSString*)address
           coordinate:(CLLocationCoordinate2D)coordinate
                title:(NSString *)t
                subtitle:(NSString *)s
           identifier:(NSNumber *)ident;

- (instancetype)initWithMKMapItem:(MKMapItem*)mapItem;

- (MKMapItem*)mapItem;

//This is an optional property from MKAnnotataion
@property (nonatomic, copy) NSString *title;

//@property (nonatomic, copy) NSValue *placemark;
@property (nonatomic, readonly, copy) NSString *subtitle;
@property (nonatomic) BOOL animatesDrop;
@property (nonatomic) BOOL canShowCallout;
@property (nonatomic) BOOL itemSelected;

@property (copy) NSString *address;
@property (assign, nonatomic) CLLocationCoordinate2D coordinate;
@property (copy) NSNumber *identifier;
@property (nonatomic, copy) NSString *imageKey;
@property (nonatomic, copy) UIImage *image;



@end
