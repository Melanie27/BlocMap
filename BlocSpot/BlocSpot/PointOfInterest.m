//
//  PointOfInterest.m
//  BlocSpot
//
//  Created by MELANIE MCGANNEY on 9/20/16.
//  Copyright © 2016 Bloc. All rights reserved.
//

#import "PointOfInterest.h"


@implementation PointOfInterest

@synthesize title, subtitle, animatesDrop, canShowCallout, imageKey, image;
@synthesize address = _address, coordinate = _coordinate, identifier = _indentifier;

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
        
        subtitle = [NSDateFormatter localizedStringFromDate:theDate
                                                  dateStyle:NSDateFormatterShortStyle
                                                  timeStyle:NSDateFormatterShortStyle];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:_address forKey:@"address"];
    
    
    [aCoder encodeObject:title forKey:@"title"];
    [aCoder encodeObject:_indentifier forKey:@"identifier"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        [self setAddress:[aDecoder decodeObjectForKey:@"address"]];
        
    }
    return self;
    
}
@end
