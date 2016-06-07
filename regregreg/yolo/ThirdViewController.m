//
//  ThirdViewController.m
//  Regression
//
//  Created by Vikram Mullick on 11/8/15.
//  Copyright © 2015 Vikram Mullick. All rights reserved.
//
#import "AppDelegate.h"
#import "ThirdViewController.h"

@interface ThirdViewController ()
@property (weak, nonatomic) IBOutlet UILabel *rsquaredtext;
@property AppDelegate *appDelegate;
@property (weak, nonatomic) IBOutlet UITextView *EquationScroll;
@property (weak, nonatomic) IBOutlet UILabel *EquationLabel;
@property (weak, nonatomic) IBOutlet UITabBar *tabbar;


@end

@implementation ThirdViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewDidLoad];
    
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.rsquaredtext.text=_appDelegate.rsquared;
    self.EquationLabel.text=_appDelegate.EquationForThirdView;
    self.EquationScroll.text=_appDelegate.ScrollEquationForThirdView;

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
