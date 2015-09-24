//
//  ViewController.m
//  TipCalculatorPro
//
//  Created by Kunpeng Liu on 9/22/15.
//  Copyright © 2015 Kunpeng Liu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *mainView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *tipControl;
@property (weak, nonatomic) IBOutlet UITextView *tipView;

- (IBAction)onChange:(id)sender;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.mainView becomeFirstResponder];
    self.mainView.text = @"$";
    self.mainView.textColor = [UIColor lightGrayColor];
    [self.tipView setHidden:YES];
    self.title = @"Tip Caculator";
    [self.mainView addTarget:self
                    action:@selector(textFieldDidChange:)
          forControlEvents:UIControlEventEditingChanged];
    [self readSavedValue];
}

- (void)viewWillDisappear:(BOOL)animated {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.mainView.text forKey:@"last_bill_amount"];
    [defaults setObject:[NSDate date] forKey:@"last_bill_date"];
    [defaults setInteger:self.tipControl.selectedSegmentIndex forKey:@"last_tip_segment_index"];
    [defaults synchronize];
    [super viewWillDisappear:animated];
}

- (void)readSavedValue {
    // Get the date at which the application last became inactive
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSDate* lastBillDate = [defaults valueForKey:@"last_bill_date"];
    NSDate* now = [NSDate date];
    
    // Figure out how long it's been since the application became inactive last
    NSTimeInterval interval = [now timeIntervalSinceDate:lastBillDate];
    
    // If it's been less than 10 minutes, resume the last bill amount and tip percentage.
    // Otherwise, clear the bill amount field.
    if (interval < 600) {
        self.mainView.text = [defaults valueForKey:@"last_bill_amount"];
        self.tipControl.selectedSegmentIndex = [defaults integerForKey:@"last_tip_segment_index"];
        [self textFieldDidChange:self.mainView];
    } else {
        self.mainView.text = @"";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) textFieldDidChange:(UITextField *)textField {
    if (textField.text.length == 0) {
        textField.textColor = [UIColor lightGrayColor];
        textField.text = @"$";
        [self.tipView setHidden:YES];
    } else {
        textField.textColor = [UIColor blackColor];
        [self.tipView setHidden:NO];
        [self updateTotalAmount];
    }
}

- (void) updateTotalAmount {
    if ([self.mainView.text length] == 0) {
        return;
    }
    float billAmount = [[self.mainView.text substringFromIndex:1] floatValue];
    NSArray *tipValues = @[@(0.1), @(0.15), @(0.2)];
    float tipAmount = billAmount * [tipValues[self.tipControl.selectedSegmentIndex] floatValue];
    float totalAmount = billAmount + tipAmount;
    NSString *amounts = [NSString stringWithFormat:@"+ $%0.2f \n= $%0.2f", tipAmount, totalAmount];
    self.tipView.selectable = YES;
    [self.tipView setText:amounts];
    self.tipView.selectable = NO;
    
}

- (IBAction)onChange:(id)sender {
    [self updateTotalAmount];
}

- (void)viewWillAppear:(BOOL)animated
{
    // Set the default tip percentage from the user settings
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int defaultTipSegmentIndex = [defaults integerForKey:@"default_tip_segment_index"];
    [self.tipControl setSelectedSegmentIndex:defaultTipSegmentIndex];
    
    // Update values since the tip percentage may have changed
    [self updateTotalAmount];
    
    [self.mainView becomeFirstResponder];
    
    [super viewWillAppear:animated];
}
@end
