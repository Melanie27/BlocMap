//
//  SearchResultsTableViewCell.m
//  BlocSpot
//
//  Created by MELANIE MCGANNEY on 9/22/16.
//  Copyright © 2016 Bloc. All rights reserved.
//

#import "SearchResultsTableViewCell.h"
#import "BLSDataSource.h"
#import "PointOfInterest.h"

@implementation SearchResultsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)savePointOfInterest:(id)sender {
    /*[[BLSDataSource sharedInstance] savePOI:(NSArray<MKMapItem *> *) andThen:^(MKLocalSearchResponse * _Nullable response, NSError * _Nullable error) {
        
    };*/
    NSLog(@"this should save the POI to the data source");
}
@end
