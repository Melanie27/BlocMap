//
//  AddCategoryViewController.m
//  BlocSpot
//
//  Created by MELANIE MCGANNEY on 9/30/16.
//  Copyright © 2016 Bloc. All rights reserved.
//

#import "AddCategoryViewController.h"

@interface AddCategoryViewController ()

@end

@implementation AddCategoryViewController
UIColor *categoryColor;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    categoryColor = [UIColor redColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
   
}

- (IBAction)save:(id *)sender {
    NSString *categoryName = [self.nameTextField text];
    [self.delegate controller:self didSaveCategoryWithName:categoryName andColor:categoryColor ];
   
    [self.navigationController popViewControllerAnimated:YES];
    
    
}

 -(IBAction)grabColorFromButton:(UIButton*)sender {
    
    categoryColor = sender.backgroundColor;
    //TODO update ui of selected category
     
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/







@end
