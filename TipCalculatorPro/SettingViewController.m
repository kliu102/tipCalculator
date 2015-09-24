//
//  SettingViewController.m
//  TipCalculatorPro
//
//  Created by Kunpeng Liu on 9/22/15.
//  Copyright © 2015 Kunpeng Liu. All rights reserved.
//

#import "SettingViewController.h"
#import "ViewController.h"

@interface SettingViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *defaultTipControl;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self updateDefaultTip];
    [super viewWillDisappear:animated];
}

- (void)updateDefaultTip {
    // Save the default tip percentage
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:self.defaultTipControl.selectedSegmentIndex forKey:@"default_tip_segment_index"];
    [defaults synchronize];
}

@end
