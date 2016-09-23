//
//  SearchResultsTableViewCell.h
//  BlocSpot
//
//  Created by MELANIE MCGANNEY on 9/22/16.
//  Copyright © 2016 Bloc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SearchResultsTableViewCell;

@protocol SearchResultsTableViewCellDelegate <NSObject>


@end

@interface SearchResultsTableViewCell : UITableViewCell

@property (nonatomic, weak) id <SearchResultsTableViewCellDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIButton *categoryIcon;
@property (strong, nonatomic) IBOutlet UILabel *entryTitle;
@property (strong, nonatomic) IBOutlet UILabel *entrySubtitle;

@end
