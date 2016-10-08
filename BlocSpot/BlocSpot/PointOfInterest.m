//
//  PointOfInterest.m
//  BlocSpot
//
//  Created by MELANIE MCGANNEY on 9/20/16.
//  Copyright © 2016 Bloc. All rights reserved.
//

#import "PointOfInterest.h"
#import <AddressBook/AddressBook.h>

@interface PointOfInterest ()
@property (nonatomic, copy) NSString *subtitle;


@end

@implementation PointOfInterest


- (instancetype)initWithMKMapItem:(MKMapItem*)mapItem {
    NSString *address = @"";
    NSString *name = mapItem.name;
    NSString *subtitle = mapItem.phoneNumber;
    NSNumber *identifier = @10;
    CLLocationCoordinate2D coord = mapItem.placemark.location.coordinate;
    return [self initWithAddress:address coordinate:coord title:name subtitle:subtitle identifier:identifier];
}

- (instancetype)initWithMKPointAnnotation:(MKPointAnnotation *)annotation {
    NSString *address = @"";
    NSString *name = annotation.title;
    NSString *subtitle = annotation.subtitle;
    NSNumber *identifier = @10;
   CLLocationCoordinate2D coord = annotation.coordinate;
    return [self initWithAddress:address coordinate:coord title:name subtitle:subtitle identifier:identifier];
}

-(instancetype)initWithPOICategory:(POICategory *)POIcategory {
    NSString *categoryName = POIcategory.categoryName;
    UIColor *categoryColor = POIcategory.categoryColor;
    //NSLog(@"category name %@", categoryName);
    //NSLog(@"category color %@", categoryColor);
    return [self initWithCategoryName:categoryName categoryColor:categoryColor];
}

- (MKMapItem*)mapItem {
    NSDictionary *addrDict = @{
                            
                               };
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:self.coordinate addressDictionary:addrDict];
    
    MKMapItem *item = [[MKMapItem alloc] initWithPlacemark:placemark];
    item.name = self.title;
    item.phoneNumber = self.subtitle;
    
    
    return item;
}

-(id)initWithCategoryName:(NSString *)categoryName
            categoryColor:(UIColor *)categoryColor{
    self = [super init];
    
    if (self) {
        _categoryName = categoryName;
        _categoryColor = categoryColor;
    }
    
    return self;
}

-(id)initWithAddress:(NSString *)address
          coordinate:(CLLocationCoordinate2D)coordinate
               title:(NSString *)t
            subtitle:(NSString *)s
          identifier:(NSNumber *)ident {
    
    self = [super init];
    
    if (self) {
        _address = [address copy];
        _coordinate = coordinate;
        _identifier = ident;
       
        //[self setPlacemark:_coordinate];
        [self setTitle:t];
         [self setSubtitle:s];
       

    }
    return self;
}
    



- (void)encodeWithCoder:(NSCoder *)aCoder {
   
    [aCoder encodeObject:_address forKey:@"address"];
    [aCoder encodeDouble:_coordinate.latitude forKey:@"latitude"];
    [aCoder encodeDouble:_coordinate.longitude forKey:@"longitude"];
    [aCoder encodeObject:_title forKey:@"title"];
    [aCoder encodeObject:_subtitle forKey:@"subtitle"];
    [aCoder encodeObject:_identifier forKey:@"identifier"];
    [aCoder encodeObject:_categoryName forKey:@"categoryName"];
    [aCoder encodeObject:_categoryColor forKey:@"categoryColor"];
    
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.subtitle = [aDecoder decodeObjectForKey:@"subtitle"];
        [self setAddress:[aDecoder decodeObjectForKey:@"address"]];
        CLLocationDegrees latitude = [aDecoder decodeDoubleForKey:@"latitude"];
        CLLocationDegrees longitude = [aDecoder decodeDoubleForKey:@"longitude"];
        _coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        _identifier = [aDecoder decodeObjectForKey:@"identifier"];
        _categoryName = [aDecoder decodeObjectForKey:@"categoryName"];
        _categoryColor = [aDecoder decodeObjectForKey:@"categoryColor"];
        
    }
    return self;
    
}
@end
