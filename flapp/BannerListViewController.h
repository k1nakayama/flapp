//
//  BannerListViewController.h
//  flapp
//
//  Created by 中山桂一 on 2014/03/18.
//  Copyright (c) 2014年 Pocket Solution Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BannerListViewCell.h"
#import "MBProgressHUD.h"

@interface BannerListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate>{
    MBProgressHUD *_progress;
}

@end
