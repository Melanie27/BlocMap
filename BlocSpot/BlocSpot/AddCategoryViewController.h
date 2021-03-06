//
//  AddCategoryViewController.h
//  BlocSpot
//
//  Created by MELANIE MCGANNEY on 9/30/16.
//  Copyright © 2016 Bloc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
//#import "CategoryListViewController.h"
#import "POICategory.h"
#import "PointOfInterest.h"


//forward protocol declaration
@protocol AddCategoryViewControllerDelegate;

@interface AddCategoryViewController : ViewController


@property (weak) id<AddCategoryViewControllerDelegate> delegate;
@property IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UIButton *colorButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *save;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *colorButtonCollection;
@property (atomic, strong) PointOfInterest* currentPOI;
@property (atomic, strong) POICategory* currentCategory;


- (IBAction)grabColorFromButton:(UIButton*)sender;


@end


@protocol AddCategoryViewControllerDelegate <NSObject>
- (void)controller:(AddCategoryViewController *)controller didSaveCategoryWithName:(NSString *)name andColor:(UIColor*)color;



@end

