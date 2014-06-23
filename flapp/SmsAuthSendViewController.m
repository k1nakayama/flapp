//
//  smsAuthSendViewController.m
//  flapp
//
//  Created by 中山桂一 on 2014/03/23.
//  Copyright (c) 2014年 Pocket Solution Inc. All rights reserved.
//

#import "SmsAuthSendViewController.h"
#import "AppApiUtil.h"
#import "AuthCodeViewController.h"
#import "UIViewController+MJPopupViewController.h"
#import "ConfirmPopupViewController.h"

@interface SmsAuthSendViewController () <ConfirmPopupDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phonenumber;
- (IBAction)didEndPhonenumber:(id)sender;
@property (nonatomic,strong) UITapGestureRecognizer *singleTap;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
- (IBAction)pressSubmitButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
- (IBAction)pressCloseButton:(id)sender;

@end

@implementation SmsAuthSendViewController
@synthesize delegate;

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
    self.navigationItem.title = @"本人認証";
    //self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:1 green:0.96078437566757202 blue:0.79607850313186646 alpha:1];
    //self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:1 green:0.96078437566757202 blue:0.79607850313186646 alpha:1];
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:1.0 green:0.398 blue:0 alpha:1.0];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:1.0 green:0.398 blue:0 alpha:1.0];
    
    self.singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSingleTap:)];
    self.singleTap.delegate = self;
    self.singleTap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:self.singleTap];
    self.phonenumber.delegate = self;
    
    
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSMutableString *pnumber = [textField.text mutableCopy];
    [pnumber replaceCharactersInRange:range withString:string];
    return ([pnumber length] <= 11);
}

-(void)onSingleTap:(UITapGestureRecognizer *)recognizer {
    [self.phonenumber resignFirstResponder];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if(gestureRecognizer == self.singleTap){
        //キーボード表示中のみ有効
        if (self.phonenumber.isFirstResponder) {
            return YES;
        } else {
            return NO;
        }
    }
    return YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didEndPhonenumber:(id)sender {
    AppApiUtil *apiUtil = [[AppApiUtil alloc] init];
    NSDictionary *userInfo = [apiUtil getUserInfo];
    if([[userInfo objectForKey:@"sms_status"]boolValue] == NO){
        NSLog(@"phonenumber: %@",self.phonenumber.text);
        NSDictionary *authRequest = [apiUtil sendAuthCode:self.phonenumber.text];
        NSLog(@"authRequest: %@",authRequest);
        //[NSThread sleepForTimeInterval:3.0f];
        [_progress hide:YES];
        AuthCodeViewController *authCodeVC = [[AuthCodeViewController alloc] init];
        NSLog(@"didEndPhonenumber3");
        [self.navigationController pushViewController:authCodeVC animated:YES];
    }
}

- (IBAction)pressSubmitButton:(id)sender {
    if(self.phonenumber.isFirstResponder){
        [self.phonenumber resignFirstResponder];
    }
    
    ConfirmPopupViewController *confirmPopupVC = [[ConfirmPopupViewController alloc] initWithNibName:@"ConfirmPopupViewController" bundle:nil];
    confirmPopupVC.delegate = self;
    [confirmPopupVC setConfirm:[NSString stringWithFormat:@"%@ にSMSを送信します。\n間違いはございませんか？",self.phonenumber.text]];
    [confirmPopupVC setOkLabel:@"送信"];
    [confirmPopupVC setCancelLabel:@"キャンセル"];
    [self presentPopupViewController:confirmPopupVC animationType:MJPopupViewAnimationFade];
}

-(void)hudWasHidden:(MBProgressHUD *)hud{
    [_progress removeFromSuperview];
}
- (IBAction)pressCloseButton:(id)sender {
    NSLog(@"pressCloseButton");
    [self closeView];
}
-(void)closeView{
    [delegate closeSmsAuthView];
}
-(void)okButtonClicked:(ConfirmPopupViewController *)popupViewController{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
    
    //ボタンを無効化
    self.submitButton.enabled = NO;
    
    //プログレス表示
    _progress = [[MBProgressHUD alloc] initWithView:self.view];
    _progress.labelText = @"読み込み中";
    [self.view addSubview:_progress];
    [_progress show:YES];
    

    [NSThread detachNewThreadSelector:@selector(didEndPhonenumber:) toTarget:self withObject:popupViewController];
}
-(void)cancelButtonClicked:(ConfirmPopupViewController *)popupViewController{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}
@end
