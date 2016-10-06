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
    NSString *categoryName = @"not set";
    //POICategory *category = @"not set";
    CLLocationCoordinate2D coord = mapItem.placemark.location.coordinate;
    return [self initWithAddress:address coordinate:coord title:name subtitle:subtitle identifier:identifier categoryName:categoryName];
}

- (instancetype)initWithMKPointAnnotation:(MKPointAnnotation *)annotation {
    NSString *address = @"";
    NSString *name = annotation.title;
    NSString *subtitle = annotation.subtitle;
    NSNumber *identifier = @10;
    NSString *categoryName = @"not set";
    //POICategory *category = category;
    CLLocationCoordinate2D coord = annotation.coordinate;
    return [self initWithAddress:address coordinate:coord title:name subtitle:subtitle identifier:identifier categoryName:categoryName];
}

-(instancetype)initWithPOICategory:(POICategory *)POIcategory {
    NSString *categoryName = POIcategory.categoryName;
    return [self initWithCategoryName:categoryName];
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

-(id)initWithAddress:(NSString *)address
          coordinate:(CLLocationCoordinate2D)coordinate
               title:(NSString *)t
            subtitle:(NSString *)s
          identifier:(NSNumber *)ident
        categoryName:(NSString *)n {
    self = [super init];
    
    if (self) {
        _address = [address copy];
        _coordinate = coordinate;
        _identifier = ident;
       
        //[self setPlacemark:_coordinate];
        [self setTitle:t];
         [self setSubtitle:s];
        [self setCategoryName:n];
        
        
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
        
    }
    return self;
    
}
@end
