//
//  CategoryViewController.h
//  BlocSpot
//
//  Created by MELANIE MCGANNEY on 9/27/16.
//  Copyright © 2016 Bloc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Interactor;

@interface CategoryViewController : UIViewController
//@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *categoryLables;
//@property (strong, nonatomic) IBOutlet UIView *categoryContainerView;


-(instancetype)initWithInteractor:(Interactor *)interactor;

@end
