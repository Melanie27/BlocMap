//
//  SearchViewController.m
//  BlocSpot
//
//  Created by MELANIE MCGANNEY on 9/19/16.
//  Copyright © 2016 Bloc. All rights reserved.
//

#import "SearchViewController.h"
#import "MapViewController.h"
#import "BLSDataSource.h"

@interface SearchViewController () 

@end

@implementation SearchViewController

//MKLocalSearch *localSearch;
 //MKLocalSearchResponse *results;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.navigationItem.title = @"Search";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    
}
*/

- (IBAction)dismissSearchView:(id)sender {
    [self.mapVC loadSearchResults];
    [self.navigationController popViewControllerAnimated:YES];

}

- (IBAction)searchMap:(id)sender {
//-(void)searchMap:(NSString*)searchText andThen:(MKLocalSearchCompletionHandler)completionHandler;
    [[BLSDataSource sharedInstance] searchMap:self.searchText.text andThen:^(MKLocalSearchResponse * _Nullable response, NSError * _Nullable error) {
       
        [self.navigationController popViewControllerAnimated:YES];
    }];
   
   

}
@end
