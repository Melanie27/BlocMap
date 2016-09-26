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
           identifier:(NSNumber *)ident;


//This is an optional property from MKAnnotataion
@property (nonatomic, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *subtitle;
@property (nonatomic) BOOL animatesDrop;
@property (nonatomic) BOOL canShowCallout;

@property (copy) NSString *address;
@property (copy) NSNumber *identifier;
@property (nonatomic, copy) NSString *imageKey;
@property (nonatomic, copy) UIImage *image;


//THESE WERE MY properties that I may discard
@property NSString *poiName;
@property NSString *poiAddress;
@property NSString *poiPhoneNumber;
@property NSString *poiNote;
@property NSURL *poiUrl;
@property NSSet *poiCategories;
@property NSString *poiCategory;

@end
