//
//  MyAnnotation.h
//  BlocSpot
//
//  Created by MELANIE MCGANNEY on 9/20/16.
//  Copyright © 2016 Bloc. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MyAnnotation : MKPointAnnotation

@property (nonatomic, strong) NSString *contactInformation;

//init method contains setup code
-(id)initWithCoordinate:(CLLocationCoordinate2D)coord title:(NSString*)title subtitle:(NSString *)subtitle contactInformation:(NSString *)contactInfo;

@end
