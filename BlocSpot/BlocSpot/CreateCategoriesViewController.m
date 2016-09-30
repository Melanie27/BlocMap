//
//  CreateCategoriesViewController.m
//  BlocSpot
//
//  Created by MELANIE MCGANNEY on 9/30/16.
//  Copyright © 2016 Bloc. All rights reserved.
//

#import "CreateCategoriesViewController.h"

@implementation CreateCategoriesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}



- (IBAction)addCategory:(id)sender {
    
   
    //place to add category name and select color
    //Connect to data source here
}



-(void) updateUI {
    //add the new label to the UI
    for(UIButton *categoryLabel in self.categoryLabels) {
        //int labelIndex = [self.categoryLabels indexOfObject:labelIndex];
        [categoryLabel setTitle:@"new category" forState:UIControlStateNormal];
        //[categoryLabel setTintColor:(UIColor* blueColor)];
    }
}
@end
