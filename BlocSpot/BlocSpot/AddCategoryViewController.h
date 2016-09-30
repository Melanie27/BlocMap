//
//  AddCategoryViewController.h
//  BlocSpot
//
//  Created by MELANIE MCGANNEY on 9/30/16.
//  Copyright © 2016 Bloc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@interface AddCategoryViewController : ViewController

@property IBOutlet UITextField *nameTextField;
@property IBOutlet UITextField *colorTextField;

//TODO make a bunch of color swatches they can select from?

@property (strong, nonatomic) IBOutlet UIBarButtonItem *save;



@end
