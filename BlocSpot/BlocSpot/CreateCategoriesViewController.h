//
//  CreateCategoriesViewController.h
//  BlocSpot
//
//  Created by MELANIE MCGANNEY on 9/30/16.
//  Copyright © 2016 Bloc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateCategoriesViewController : UIViewController
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *categoryLabels;
- (IBAction)addCategory:(id)sender;

@end
