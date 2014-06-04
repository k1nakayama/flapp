//
//  AuthCodeViewController.h
//  flapp
//
//  Created by 中山桂一 on 2014/03/24.
//  Copyright (c) 2014年 Pocket Solution Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "SmsAuthSendViewController.h"

@interface AuthCodeViewController : UIViewController<UIGestureRecognizerDelegate,UITextFieldDelegate,MBProgressHUDDelegate>{
    MBProgressHUD *_progress;
}

@end
