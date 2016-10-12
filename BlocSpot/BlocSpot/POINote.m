//
//  POINote.m
//  BlocSpot
//
//  Created by MELANIE MCGANNEY on 10/12/16.
//  Copyright © 2016 Bloc. All rights reserved.
//

#import "POINote.h"

@implementation POINote

-(instancetype) initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    
    if(self) {
        self.noteText = [aDecoder decodeObjectForKey:@"noteText"];
        
    }
    
    return self;
}

-(void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.noteText forKey:@"noteText"];
    
}

@end
