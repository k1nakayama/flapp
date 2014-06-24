//
//  ExchangeInputViewController.m
//  flapp
//
//  Created by 中山桂一 on 2014/03/20.
//  Copyright (c) 2014年 Pocket Solution Inc. All rights reserved.
//

#import "ExchangeInputViewController.h"
#import "AppApiUtil.h"
#import "SmsAuthSendViewController.h"
#import "UIViewController+MJPopupViewController.h"
#import "ConfirmPopupViewController.h"
#import "NoticePopupViewController.h"
#import "IssueGiftViewController.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"

@interface ExchangeInputViewController ()<ConfirmPopupDelegate,NoticePopupDelegate,UIWebViewDelegate,UITextFieldDelegate>{
    NSDictionary *userInfo;
    AppApiUtil *apiUtil;
    NSMutableArray *row_list;
    NSMutableArray *giftNumList;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *totalPointLabel;
@property (strong, nonatomic) IBOutlet UILabel *remainPointLabel;
@property (strong, nonatomic) IBOutlet UIButton *exchange_button;

@end

@implementation ExchangeInputViewController

@synthesize giftDetail;

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
    //self.exchange_title.text = [giftDetail objectForKey:@"gift_title"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    row_list = [NSMutableArray array];
    giftNumList = [NSMutableArray array];
    [self initRowList];
    apiUtil = [[AppApiUtil alloc] init];
    
    for (int i=0; i<=[[giftDetail objectForKey:@"gift_detail"] count]; i++) {
        [giftNumList insertObject:@"0" atIndex:i];
    }

    
}
-(void)viewWillAppear:(BOOL)animated{
    _progress = [[MBProgressHUD alloc] initWithView:self.view];
    _progress.labelText = @"読み込み中";
    [self.view addSubview:_progress];
    [_progress show:YES];

    userInfo = [apiUtil getUserInfo];
    if([[userInfo objectForKey:@"sms_status"]boolValue] == NO){
        [self.exchange_button setTitle:@"本人認証を行う" forState:UIControlStateNormal];
        [self.exchange_button setBackgroundColor:[UIColor blueColor]];
    } else {
        [self.exchange_button setTitle:@"この内容で交換する" forState:UIControlStateNormal];
        [self.exchange_button setBackgroundColor:[UIColor redColor]];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [_progress hide:YES];
}
-(void)hudWasHidden:(MBProgressHUD *)hud{
    [_progress removeFromSuperview];
}

-(void)initRowList{
    int i = 0;
    [row_list insertObject:@"title_image" atIndex:i];
    i++;
    
    if(![[giftDetail objectForKey:@"upper_introduction"] isEqual:[NSNull null]]){
        [row_list insertObject:@"upper_introduction" atIndex:i];
        i++;
    }
    for (int j=0;j<[[giftDetail objectForKey:@"gift_detail"] count];j++) {
        [row_list insertObject:[NSString stringWithFormat:@"gift_input_%d",j] atIndex:i];
        i++;
    }
    [row_list insertObject:@"total" atIndex:i];
    i++;
    [row_list insertObject:@"submit" atIndex:i];
    i++;
    if(![[giftDetail objectForKey:@"under_introduction"] isEqual:[NSNull null]]){
        [row_list insertObject:@"under_introduction" atIndex:i];
        i++;
    }
    NSLog(@"row_list %@",row_list);
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //return row_list.count;
    return row_list.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    //if(cell == nil){
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    //}
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSString *cell_type = [row_list objectAtIndex:indexPath.row];
    if([cell_type isEqualToString:@"title_image"]){
        UIImageView *titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 5, 280, 80)];
        titleImageView.center = CGPointMake(160, 45);

        NSURL *titleUrl = [NSURL URLWithString:[giftDetail objectForKey:@"title_image"]];
        //NSData *titleImgData = [NSData dataWithContentsOfURL:titleUrl];
        //UIImage *titleImage = [UIImage imageWithData:titleImgData];
        [titleImageView sd_setImageWithURL:titleUrl];
        //titleImageView.image = titleImage;
        titleImageView.contentMode = UIViewContentModeScaleAspectFit;
        [cell.contentView addSubview:titleImageView];
    } else if([cell_type isEqualToString:@"upper_introduction"]){
        UIWebView *upperIntroductionView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320,[[giftDetail objectForKey:@"upper_height"] intValue])];
        upperIntroductionView.center = CGPointMake(160, [[giftDetail objectForKey:@"upper_height"] intValue]/2);
        upperIntroductionView.scalesPageToFit = NO;
        upperIntroductionView.scrollView.scrollEnabled = NO;
        upperIntroductionView.delegate = self;
        [cell.contentView addSubview:upperIntroductionView];
        
        [upperIntroductionView loadHTMLString:[giftDetail objectForKey:@"upper_introduction"] baseURL:nil];
        
    } else if ([cell_type isEqualToString:@"total"]){
        UIView *totalView = [[UIView alloc] initWithFrame:CGRectMake(20, 5, 280, 80)];
        totalView.center = CGPointMake(160, 45);

        UILabel *totalPointDescLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, 141, 21)];
        totalPointDescLabel.text = @"交換ゴールド合計：";
        totalPointDescLabel.font = [UIFont systemFontOfSize:15.0f];
        totalPointDescLabel.adjustsFontSizeToFitWidth = YES;
        totalPointDescLabel.textAlignment = NSTextAlignmentRight;
        [totalView addSubview:totalPointDescLabel];
        
        UILabel *remainPointDescLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 53, 141, 21)];
        remainPointDescLabel.text = @"残ゴールド：";
        remainPointDescLabel.font = [UIFont systemFontOfSize:15.0f];
        remainPointDescLabel.adjustsFontSizeToFitWidth = YES;
        remainPointDescLabel.textAlignment = NSTextAlignmentRight;
        [totalView addSubview:remainPointDescLabel];

        UILabel *borderLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 31, 270, 21)];
        borderLabel.text = @"------------------------------------------------------------------------";
        borderLabel.font = [UIFont systemFontOfSize:9.0f];
        borderLabel.adjustsFontSizeToFitWidth = YES;
        borderLabel.textAlignment = NSTextAlignmentLeft;
        [totalView addSubview:borderLabel];

        self.totalPointLabel = [[UILabel alloc] initWithFrame:CGRectMake(169, 16, 107, 21)];
        self.totalPointLabel.text = [NSString stringWithFormat:@"0%@",POINT_UNIT];
        self.totalPointLabel.font = [UIFont systemFontOfSize:17.0f];
        self.totalPointLabel.textColor = [UIColor redColor];
        self.totalPointLabel.adjustsFontSizeToFitWidth = YES;
        self.totalPointLabel.textAlignment = NSTextAlignmentRight;
        [totalView addSubview:self.totalPointLabel];

        self.remainPointLabel = [[UILabel alloc] initWithFrame:CGRectMake(169, 53, 107, 21)];
        
        int intRemainPoint = [[userInfo objectForKey:@"point"] intValue];
        NSNumber *remainPoint = [[NSNumber alloc] initWithInt:intRemainPoint];
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [formatter setGroupingSeparator:@","];
        [formatter setGroupingSize:3];
        
        self.remainPointLabel.text = [NSString stringWithFormat:@"%@%@",[formatter stringFromNumber:remainPoint],POINT_UNIT];
        self.remainPointLabel.font = [UIFont systemFontOfSize:17.0f];
        self.remainPointLabel.textColor = [UIColor redColor];
        self.remainPointLabel.adjustsFontSizeToFitWidth = YES;
        self.remainPointLabel.textAlignment = NSTextAlignmentRight;
        [totalView addSubview:self.remainPointLabel];

        //totalView.backgroundColor = [UIColor yellowColor];
        [cell.contentView addSubview:totalView];
        [self updateTotal];
    } else if([cell_type isEqualToString:@"under_introduction"]){
        UIWebView *underIntroductionView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, [[giftDetail objectForKey:@"under_height"] intValue]+10)];
        underIntroductionView.center = CGPointMake(160, [[giftDetail objectForKey:@"under_height"] intValue] /2 );
        underIntroductionView.scalesPageToFit = NO;
        underIntroductionView.scrollView.scrollEnabled = NO;
        underIntroductionView.delegate = self;
        [cell.contentView addSubview:underIntroductionView];
        
        [underIntroductionView loadHTMLString:[giftDetail objectForKey:@"under_introduction"] baseURL:nil];
        
    } else if([cell_type isEqualToString:@"submit"]){
        /*
        UIButton *submitButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 5, 280, 30)];
        submitButton.center = CGPointMake(160, 30);
        [submitButton setTitle:@"この内容で交換する" forState:UIControlStateNormal];
        [submitButton setBackgroundColor:[UIColor redColor]];
        [submitButton addTarget:self action:@selector(pressExchangeButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.contentView addSubview:submitButton];
        */
        self.exchange_button = [[UIButton alloc] initWithFrame:CGRectMake(20, 5, 280, 30)];
        self.exchange_button.center = CGPointMake(160, 30);
        if([[userInfo objectForKey:@"sms_status"]boolValue] == NO){
            [self.exchange_button setTitle:@"本人認証を行う" forState:UIControlStateNormal];
            [self.exchange_button setBackgroundColor:[UIColor blueColor]];
        } else {
            
            [self.exchange_button setTitle:[giftDetail objectForKey:@"button_title"] forState:UIControlStateNormal];
            [self.exchange_button setBackgroundColor:[UIColor redColor]];
        }
        [self.exchange_button addTarget:self action:@selector(pressExchangeButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.contentView addSubview:self.exchange_button];

    } else {
        if([[cell_type substringToIndex:10] isEqualToString:@"gift_input"]){
            int gift_index = [[cell_type substringFromIndex:11] intValue];
            NSDictionary *gift = [[giftDetail objectForKey:@"gift_detail"] objectAtIndex:gift_index];
            

            NSLog(@"giftNumList: %@ at: %d",[giftNumList objectAtIndex:gift_index+1],gift_index+1);
            
            UIView *giftUnitView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, 280, 90)];
            giftUnitView.backgroundColor = [UIColor yellowColor];
            giftUnitView.center = CGPointMake(160, 45);
            
            UILabel *giftDescLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 280, 20)];
            giftDescLabel.text = [gift objectForKey:@"gift_desc"];
            giftDescLabel.font = [UIFont systemFontOfSize:17.0];
            [giftUnitView addSubview:giftDescLabel];
            
            UILabel *giftUnitLabel = [[UILabel alloc] initWithFrame:CGRectMake(28, 26, 48, 21)];
            giftUnitLabel.text = @"ゴールド";
            giftUnitLabel.font = [UIFont systemFontOfSize:12.0];
            giftUnitLabel.adjustsFontSizeToFitWidth = YES;
            giftUnitLabel.textAlignment = NSTextAlignmentCenter;
            [giftUnitView addSubview:giftUnitLabel];
            
            UILabel *giftUnitNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(33, 48, 55, 30)];
            giftUnitNumLabel.text = [gift objectForKey:@"exchange_point"];
            giftUnitNumLabel.backgroundColor = [UIColor yellowColor];
            giftUnitNumLabel.font = [UIFont systemFontOfSize:17.0];
            giftUnitNumLabel.textAlignment = NSTextAlignmentCenter;
            giftUnitNumLabel.adjustsFontSizeToFitWidth = YES;
            [giftUnitView addSubview:giftUnitNumLabel];

            UILabel *ptLabel = [[UILabel alloc] initWithFrame:CGRectMake(92, 60, 28, 21)];
            ptLabel.text = POINT_UNIT;
            ptLabel.font = [UIFont systemFontOfSize:17.0];
            ptLabel.adjustsFontSizeToFitWidth = YES;
            ptLabel.textAlignment = NSTextAlignmentCenter;
            [giftUnitView addSubview:ptLabel];
            
            UILabel *batsuLabel = [[UILabel alloc] initWithFrame:CGRectMake(119, 45, 42, 36)];
            batsuLabel.text = @"×";
            batsuLabel.textColor = [UIColor redColor];
            batsuLabel.font = [UIFont systemFontOfSize:45.0];
            batsuLabel.textAlignment = NSTextAlignmentCenter;
            batsuLabel.adjustsFontSizeToFitWidth = YES;
            [giftUnitView addSubview:batsuLabel];
            
            UILabel *giftNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(177, 26, 42, 21)];
            giftNumLabel.text = @"数量";
            giftNumLabel.font = [UIFont systemFontOfSize:12.0];
            giftNumLabel.adjustsFontSizeToFitWidth = YES;
            giftNumLabel.textAlignment = NSTextAlignmentCenter;
            [giftUnitView addSubview:giftNumLabel];
            
            UITextField *giftNum = [[UITextField alloc] initWithFrame:CGRectMake(177, 48, 60, 30)];
            giftNum.keyboardType = UIKeyboardTypeNumberPad;
            giftNum.textAlignment = NSTextAlignmentCenter;
            giftNum.backgroundColor = [UIColor whiteColor];
            giftNum.font = [UIFont systemFontOfSize:23.0];
            giftNum.text = [giftNumList objectAtIndex:gift_index+1];
            giftNum.tag = gift_index+1;
            giftNum.delegate = self;
            [giftUnitView addSubview:giftNum];
            
            [cell.contentView addSubview:giftUnitView];
            
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cell_type = [row_list objectAtIndex:indexPath.row];
    if([cell_type isEqualToString:@"title_image"]){
        return 90;
    } else if([cell_type isEqualToString:@"upper_introduction"]){
        return [[giftDetail objectForKey:@"upper_height"] intValue];
    } else if ([cell_type isEqualToString:@"total"]){
        return 84;
    } else if([cell_type isEqualToString:@"under_introduction"]){
        return [[giftDetail objectForKey:@"under_height"] intValue];
    } else if([cell_type isEqualToString:@"submit"]){
        return 60;
    } else {
        if([[cell_type substringToIndex:10] isEqualToString:@"gift_input"]){
            return 90;
        }
    }
    return 90;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pressExchangeButton:(id)sender {
    if([[userInfo objectForKey:@"sms_status"]boolValue] == NO){
        SmsAuthSendViewController *smsAuthVC = [[SmsAuthSendViewController alloc] init];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:smsAuthVC];
        smsAuthVC.delegate = self;
        [self presentViewController:navigationController animated:YES completion:nil];
    } else {
        ConfirmPopupViewController *confirmPopupVC = [[ConfirmPopupViewController alloc] initWithNibName:@"ConfirmPopupViewController" bundle:nil];
        confirmPopupVC.delegate = self;
        [confirmPopupVC setConfirm:@"この内容で交換してよろしいですか？"];
        [confirmPopupVC setOkLabel:@"はい"];
        [confirmPopupVC setCancelLabel:@"いいえ"];
        confirmPopupVC.title = @"exchange_confirm";
        [self presentPopupViewController:confirmPopupVC animationType:MJPopupViewAnimationFade];
    }
}
-(void) closeSmsAuthView{
    NSLog(@"closeSmsAuthView");
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)okButtonClicked:(ConfirmPopupViewController *)popupViewController{
    if([popupViewController.title isEqualToString:@"exchange_confirm"]){
        [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
        
        //プログレス表示
        _progress = [[MBProgressHUD alloc] initWithView:self.view];
        _progress.labelText = @"読み込み中";
        [self.view addSubview:_progress];
        [_progress show:YES];
        
        [NSThread detachNewThreadSelector:@selector(doExchange:) toTarget:self withObject:popupViewController];
    } else if([popupViewController.title isEqualToString:@"exchange_finished"]){
        [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
        NSLog(@"exchange_finished okButton");
    } else {
        NSLog(@"aaaaa");
    }
}
-(void)cancelButtonClicked:(ConfirmPopupViewController *)popupViewController{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}

-(void)doExchange:(id)popupViewController{
    [NSThread sleepForTimeInterval:3.0f];
    NSDictionary *gift_detail = [NSDictionary dictionaryWithObjectsAndKeys:@"pex1000",@"gift_name",@"2",@"gift_num",nil];
    NSArray *exchange_detail = [NSArray arrayWithObjects:gift_detail,nil];
    NSDictionary *exchangeResult = [apiUtil orderExchange:exchange_detail];
    NSLog(@"exchange_result %@",exchangeResult);

    [_progress hide:YES];
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
    NoticePopupViewController *noticePopupVC = [[NoticePopupViewController alloc] initWithNibName:@"NoticePopupViewController" bundle:nil];
    noticePopupVC.delegate = self;
    [noticePopupVC setNotice:@"交換が完了しました！"];
    void (^afterDismissPopup)(void) = ^(void){
        NSLog(@"afterDismissPopup");
        IssueGiftViewController *issueGiftVC = [[IssueGiftViewController alloc] init];
        [issueGiftVC setExchangeInfo:exchangeResult];
        [self.navigationController pushViewController:issueGiftVC animated:YES];
        //[self closeView];
    };
    noticePopupVC.title = @"exchange_finished";
    [self presentPopupViewController:noticePopupVC animationType:MJPopupViewAnimationFade dismissed:afterDismissPopup];
    NSLog(@"doExchangeFinished");
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType {
	NSString* scheme = [[request URL] scheme];
	if([scheme compare:@"about"] == NSOrderedSame) {
		return YES;
	}
	if([scheme compare:@"http"] == NSOrderedSame) {
		[[UIApplication sharedApplication] openURL: [request URL]];
	}
	return NO;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    NSLog(@"textfiled %@",textField);
    self.exchangePickerVC = [[ExchangePickerViewController alloc] init];
    self.exchangePickerVC.delegate = self;
    

    [self.exchangePickerVC setSelectFieldTag:textField.tag];
    [self.exchangePickerVC setSelectedValue:[[giftNumList objectAtIndex:textField.tag] intValue]];
    
    UIView *pickerView = self.exchangePickerVC.view;
    CGPoint middleCenter = pickerView.center;
    
    UIWindow *mainWindow = (((AppDelegate *)[UIApplication sharedApplication].delegate).window);
    CGSize offSize = [UIScreen mainScreen].bounds.size;
    CGPoint offScreenCenter = CGPointMake(offSize.width/2.0, offSize.height * 1.5);
    pickerView.center = offScreenCenter;

    [mainWindow addSubview:pickerView];

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    pickerView.center = middleCenter;
    [UIView commitAnimations];
    
    return NO;
}

-(void)applySelectedString:(NSString *)str selectFieldTag:(NSInteger)tag{
    
    //最初のギフト数入力セルの位置
    NSInteger inputNumRows = 2;
    NSInteger atRow = inputNumRows+tag-1;
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:atRow inSection:0]];
    UITextField *numField = (UITextField *)[cell viewWithTag:tag];
    //NSLog(@"numField %@",numField);
    numField.text = str;
    [giftNumList replaceObjectAtIndex:tag withObject:str];
    NSLog(@"before updateTotal %@",giftNumList);
    [self updateTotal];
    
}

-(void)updateTotal{
    int totalPoint = 0;
    for (int i=0;i<row_list.count;i++) {
        NSString *cell_type = [row_list objectAtIndex:i];
        if([cell_type length] >= 10){
            if([[cell_type substringToIndex:10] isEqualToString:@"gift_input"]){
                int gift_index = [[cell_type substringFromIndex:11] intValue];
                NSDictionary *gift = [[giftDetail objectForKey:@"gift_detail"] objectAtIndex:gift_index];
                
                /*
                NSInteger inputNumRows = 2;
                NSInteger atRow = inputNumRows+gift_index;
                UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:atRow inSection:0]];
                UITextField *numField = (UITextField *)[cell viewWithTag:gift_index+1];
                int num = [numField.text intValue];
                */
                int num = [[giftNumList objectAtIndex:gift_index+1] intValue];
                int giftUnit = [[gift objectForKey:@"exchange_point"] intValue];
                int subTotal = num * giftUnit;
                totalPoint = totalPoint + subTotal;
            }
        }
    }
    NSNumber *toPoint = [[NSNumber alloc] initWithInteger:totalPoint];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setGroupingSeparator:@","];
    [formatter setGroupingSize:3];
    
    self.totalPointLabel.text = [NSString stringWithFormat:@"%@%@",[formatter stringFromNumber:toPoint],POINT_UNIT];
    
    int intRemainPoint = [[userInfo objectForKey:@"point"] intValue];
    intRemainPoint = intRemainPoint - totalPoint;
    NSNumber *remainPoint = [[NSNumber alloc] initWithInteger:intRemainPoint];
    self.remainPointLabel.text = [NSString stringWithFormat:@"%@%@",[formatter stringFromNumber:remainPoint],POINT_UNIT];
    
}

-(void)closePickerView:(ExchangePickerViewController *)controller{
    UIView *pickerView = controller.view;
    
    CGSize offSize = [UIScreen mainScreen].bounds.size;
    CGPoint offScreenCenter = CGPointMake(offSize.width/2.0, offSize.height * 1.5);
    
    [UIView beginAnimations:nil context:(void *)pickerView];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    pickerView.center = offScreenCenter;
    [UIView commitAnimations];
}
-(void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context{
    UIView *pickerView = (__bridge UIView *)context;
    [pickerView removeFromSuperview];
}
@end
