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
NSString *const kPinCoordinateLatitudeKey = @"kPinCoordinateLatitudeKey";
NSString *const kPinCoordinateLongitudeKey = @"kPinCoordinateLongitudeKey";
@synthesize address = _address, coordinate = _coordinate, identifier = _indentifier;

- (instancetype)initWithMKMapItem:(MKMapItem*)mapItem {
    NSString *address = @"";
    NSString *name = mapItem.name;
    NSString *subtitle = mapItem.phoneNumber;
    NSNumber *identifier = @0;
    CLLocationCoordinate2D coord = mapItem.placemark.location.coordinate;
    return [self initWithAddress:address coordinate:coord title:name identifier:identifier];
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
          identifier:(NSNumber *)ident {
    self = [super init];
    
    if (self) {
        _address = [address copy];
        _coordinate = coordinate;
        _indentifier = ident;
       
        
        [self setTitle:t];
        
        NSDate *theDate = [NSDate date];
        
        _subtitle = [NSDateFormatter localizedStringFromDate:theDate
                                                  dateStyle:NSDateFormatterShortStyle
                                                  timeStyle:NSDateFormatterShortStyle];
    }
    return self;
}
    



- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:_address forKey:@"address"];
    
    [aCoder encodeDouble:_coordinate.latitude forKey:@"latitude"];
    [aCoder encodeDouble:_coordinate.longitude forKey:@"longitude"];
    [aCoder encodeObject:_title forKey:@"title"];
    [aCoder encodeObject:_indentifier forKey:@"identifier"];
    
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.subtitle = [aDecoder decodeObjectForKey:@"subtitle"];
        [self setAddress:[aDecoder decodeObjectForKey:@"address"]];
        CLLocationDegrees latitude = [aDecoder decodeDoubleForKey:kPinCoordinateLatitudeKey];
        CLLocationDegrees longitude = [aDecoder decodeDoubleForKey:kPinCoordinateLongitudeKey];
        _coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        
    }
    return self;
    
}
@end
