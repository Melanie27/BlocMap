//
//  CategoryViewController.m
//  BlocSpot
//
//  Created by MELANIE MCGANNEY on 9/27/16.
//  Copyright © 2016 Bloc. All rights reserved.
//


#import "CategoryViewController.h"
#import "Interactor.h"

@interface CategoryViewController ()

@property (nonatomic, strong) Interactor *interactor;

@end

@implementation CategoryViewController

-(instancetype)initWithInteractor:(Interactor *)interactor
{
    if (self = [super init])
    {
        _interactor = interactor;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    self.view.alpha = .6;
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.translatesAutoresizingMaskIntoConstraints = NO;
    [closeButton setTitle:@"X" forState:UIControlStateNormal];
    closeButton.titleLabel.font = [UIFont systemFontOfSize:24];
    [closeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeButton];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[closeButton(40)]-(10)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(closeButton)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(22)-[closeButton(40)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(closeButton)]];
    
    UIImageView *imageView = [UIImageView new];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    imageView.image = [UIImage imageNamed:@"mabelFlip.jpg"];
    [self.view addSubview:imageView];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[imageView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(imageView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[imageView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(imageView)]];
    
    UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(userDidPinch:)];
    [self.view addGestureRecognizer:pinchRecognizer];
}

-(void)userDidPinch:(UIPinchGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan)
    {
        self.interactor.isInteractive = YES;
        self.interactor.isPresenting = NO;
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged)
    {
        if (recognizer.scale <= 1)
        {
            [self.interactor updateInteractiveTransition:recognizer.scale];
        }
    }
    else if ((recognizer.state == UIGestureRecognizerStateEnded) ||
             (recognizer.state == UIGestureRecognizerStateCancelled))
    {
        (recognizer.scale < 0.5) ? [self.interactor finishInteractiveTransition] : [self.interactor cancelInteractiveTransition];
    }
}

-(void)closeButtonPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
 // Pass the selected object to the new view controller.
 }
 */

@end

