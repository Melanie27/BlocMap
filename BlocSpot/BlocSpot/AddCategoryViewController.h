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
#import "Category.h"


@protocol AddCategoryViewControllerDelegate;
//forward protocol declaration



@interface AddCategoryViewController : ViewController

//@property (weak) id<AddCategoryViewControllerDelegate> delegate;

@property IBOutlet UITextField *nameTextField;
@property IBOutlet UITextField *colorTextField;

- (IBAction)createCategoryWithColorFromButton:(UIButton *)sender;



@property (strong, nonatomic) IBOutlet UIBarButtonItem *save;



@end


/*@protocol AddCategoryViewControllerDelegate <NSObject>
- (void)controller:(AddCategoryViewController *)controller didSaveItemWithName:(NSString *)name andColor:(NSString *)color;
@end*/

