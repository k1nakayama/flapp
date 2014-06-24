//
//  AuthCodeViewController.m
//  flapp
//
//  Created by 中山桂一 on 2014/03/24.
//  Copyright (c) 2014年 Pocket Solution Inc. All rights reserved.
//

#import "AuthCodeViewController.h"
#import "AppApiUtil.h"
#import "UIViewController+MJPopupViewController.h"
#import "NoticePopupViewController.h"
#import "OHAttributedLabel.h"

@interface AuthCodeViewController () <NoticePopupDelegate>
@property (weak, nonatomic) IBOutlet UITextField *authcode;
- (IBAction)didEndAuthCode:(id)sender;
@property (nonatomic,strong) UITapGestureRecognizer *singleTap;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
- (IBAction)pressSubmitButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *labelview;


@end

@implementation AuthCodeViewController{
    NSDictionary *authResult;
}

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
    self.singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSingleTap:)];
    self.singleTap.delegate = self;
    self.singleTap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:self.singleTap];
    self.authcode.delegate = self;

    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    toolBar.barStyle = UIBarStyleDefault;
    [toolBar sizeToFit];
    
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithTitle:@"完了" style:UIBarButtonItemStyleDone target:self action:@selector(closeKeybord:)];
    NSArray *items = [NSArray arrayWithObjects:spacer,done, nil];
    [toolBar setItems:items animated:YES];
    
    self.authcode.inputAccessoryView = toolBar;
    
    self.navigationItem.title = @"認証コード送信完了";
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:1.0 green:0.398 blue:0 alpha:1.0];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:1.0 green:0.398 blue:0 alpha:1.0];
    
    NSString *txt = @"SMSでお送りした認証コードを下記の欄へ入力してください。\n\n認証コードの書かれたSMSが3分ほど経っても届かない場合は、こちらから電話発信による認証をお試しください。電話での認証が成功した場合は、認証コードは入力せずに「認証する」ボタンを押してください。";
    NSMutableAttributedString *attrStr = [NSMutableAttributedString attributedStringWithString:txt];
    NSRange range = [txt rangeOfString:@"こちら"];
    UIColor *color = [UIColor colorWithRed:135.0f / 255.0f green: 206.0f / 255.0f blue: 235.0f / 255.0f alpha:1.f];
    //NSURL *linkUrl = [NSURL URLWithString:@"http://www.yahoo.co.jp/"];
    NSURL *linkUrl = [NSURL URLWithString:@"tel:+16692313008"];
    
    [attrStr setLink:linkUrl range:range];
    [attrStr setTextColor:color range:range];
    
    OHAttributedLabel *sampleLabel = [[OHAttributedLabel alloc] initWithFrame:CGRectMake(0, 0, self.labelview.bounds.size.width, self.labelview.bounds.size.height)];
    sampleLabel.attributedText = attrStr;
    sampleLabel.font = [UIFont systemFontOfSize:15.0];
    [sampleLabel setUnderlineLinks:YES];
    [sampleLabel setLinkColor:color];
    [self.labelview addSubview:sampleLabel];

}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSMutableString *auth = [textField.text mutableCopy];
    [auth replaceCharactersInRange:range withString:string];
    return ([auth length] <= 4);
}

-(void)onSingleTap:(UITapGestureRecognizer *)recognizer {
    [self.authcode resignFirstResponder];
}

-(void)closeKeybord:(id)sender {
    [self.authcode resignFirstResponder];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if(gestureRecognizer == self.singleTap){
        //キーボード表示中のみ有効
        if (self.authcode.isFirstResponder) {
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

- (IBAction)didEndAuthCode:(id)sender {
    NSLog(@"didEndAuthCode start");
    AppApiUtil *apiUtil = [[AppApiUtil alloc] init];
    NSDictionary *userInfo = [apiUtil getUserInfo];
    if([[userInfo objectForKey:@"sms_status"]boolValue] == NO){
        authResult = [apiUtil checkAuthCode:self.authcode.text];
        [_progress hide:YES];
        
        NSDictionary *nullobj;
        nullobj = nil;
        if (authResult != nullobj) {
            NoticePopupViewController *noticePopupVC = [[NoticePopupViewController alloc] initWithNibName:@"NoticePopupViewController" bundle:nil];
            noticePopupVC.delegate = self;
            [noticePopupVC setNotice:@"本人認証が完了しました"];
            void (^afterDismissPopup)(void) = ^(void){
                NSLog(@"afterDismissPopup");
                [self closeView];
            };
            [self presentPopupViewController:noticePopupVC animationType:MJPopupViewAnimationFade dismissed:afterDismissPopup];
        }

    } else if([[userInfo objectForKey:@"sms_status"]boolValue] == YES){
        [_progress hide:YES];

        NoticePopupViewController *noticePopupVC = [[NoticePopupViewController alloc] initWithNibName:@"NoticePopupViewController" bundle:nil];
        noticePopupVC.delegate = self;
        [noticePopupVC setNotice:@"本人認証が完了しました"];
        void (^afterDismissPopup)(void) = ^(void){
            NSLog(@"afterDismissPopup");
            [self closeView];
        };
        [self presentPopupViewController:noticePopupVC animationType:MJPopupViewAnimationFade dismissed:afterDismissPopup];
    }
}

- (IBAction)pressSubmitButton:(id)sender {
    //ボタンを無効化
    self.submitButton.enabled = NO;
    
    //プログレス表示
    _progress = [[MBProgressHUD alloc] initWithView:self.view];
    _progress.labelText = @"読み込み中";
    [self.view addSubview:_progress];
    [_progress show:YES];
    
    if(self.authcode.isFirstResponder){
        [self.authcode resignFirstResponder];
    }
    [NSThread detachNewThreadSelector:@selector(didEndAuthCode:) toTarget:self withObject:sender];
}

-(void)hudWasHidden:(MBProgressHUD *)hud{
    [_progress removeFromSuperview];
}

- (void)okButtonClicked:(NoticePopupViewController *)noticePopupViewController
{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}

-(void)closeView {
    SmsAuthSendViewController *smsAuthSendVC = [self.navigationController.viewControllers objectAtIndex:0];
    [smsAuthSendVC closeView];
}
@end
