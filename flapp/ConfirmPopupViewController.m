//
//  ConfirmPopoupViewController.m
//  flapp
//
//  Created by 中山桂一 on 2014/03/25.
//  Copyright (c) 2014年 Pocket Solution Inc. All rights reserved.
//

#import "ConfirmPopupViewController.h"

@interface ConfirmPopupViewController ()
@property (weak, nonatomic) IBOutlet UILabel *confirmLabel;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@end

@implementation ConfirmPopupViewController
@synthesize delegate;
@synthesize confirm;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.confirmLabel.text = confirm;
    if([self.okLabel isEqual:[NSNull null]] || [self.okLabel length] == 0){
        self.okLabel = @"OK";
    }
    [self.submitButton setTitle:self.okLabel forState:UIControlStateNormal];
    if([self.cancelLabel isEqual:[NSNull null]] || [self.cancelLabel length] == 0){
        self.cancelLabel = @"キャンセル";
    }
    [self.cancelButton setTitle:self.cancelLabel forState:UIControlStateNormal];
}

- (IBAction)pressOkButton:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(okButtonClicked:)]) {
        [self.delegate okButtonClicked:self];
    }
    
}

- (IBAction)pressCancelButton:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelButtonClicked:)]) {
        [self.delegate cancelButtonClicked:self];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
