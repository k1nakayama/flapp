//
//  ExchangeInputViewController.h
//  flapp
//
//  Created by 中山桂一 on 2014/03/20.
//  Copyright (c) 2014年 Pocket Solution Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "ExchangePickerViewController.h"

@interface ExchangeInputViewController : UIViewController <MBProgressHUDDelegate,UITableViewDataSource,UITableViewDelegate,ExchangePickerViewDelegate>{
    MBProgressHUD *_progress;
}
@property (nonatomic, assign) NSDictionary *giftDetail;
@property (strong, nonatomic) ExchangePickerViewController *exchangePickerVC;

@end
