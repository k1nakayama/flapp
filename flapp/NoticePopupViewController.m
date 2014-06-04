//
//  NoticePopupViewController.m
//  flapp
//
//  Created by 中山桂一 on 2014/03/25.
//  Copyright (c) 2014年 Pocket Solution Inc. All rights reserved.
//

#import "NoticePopupViewController.h"


@interface NoticePopupViewController ()


@end

@implementation NoticePopupViewController
@synthesize delegate;
@synthesize notice;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)pressOkButton:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(okButtonClicked:)]) {
        [self.delegate okButtonClicked:self];
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.noticeLabel.text = notice;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
