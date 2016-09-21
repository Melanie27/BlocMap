//
//  MyAnnotationView.m
//  BlocSpot
//
//  Created by MELANIE MCGANNEY on 9/20/16.
//  Copyright © 2016 Bloc. All rights reserved.
//

#import "MyAnnotationView.h"

@implementation MyAnnotationView

-(id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    if(self) {
        UIImage *redHeart = [UIImage imageNamed:@"redHeart@2x.png"];
        self.image = redHeart;
        self.frame = CGRectMake(0, 0, 40, 40);
        //use contentMode for best scaling
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.centerOffset = CGPointMake(0, -20);
    }
    
    return self;
}

@end
