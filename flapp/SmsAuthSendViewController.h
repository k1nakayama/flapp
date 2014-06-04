//
//  smsAuthSendViewController.h
//  flapp
//
//  Created by 中山桂一 on 2014/03/23.
//  Copyright (c) 2014年 Pocket Solution Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@protocol smsAuthSendViewDelegate <NSObject>
-(void) closeSmsAuthView;

@end

@interface SmsAuthSendViewController : UIViewController<UIGestureRecognizerDelegate,UITextFieldDelegate,MBProgressHUDDelegate>{
    MBProgressHUD *_progress;
    id delegate;
}

@property (nonatomic,retain) id delegate;
-(void)closeView;

@end
