//
//  BannerDetailViewController.h
//  flapp
//
//  Created by 中山桂一 on 2014/04/04.
//  Copyright (c) 2014年 Pocket Solution Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BannerDetailViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, assign) NSDictionary *bannerDetail;
@property (nonatomic, assign) NSDictionary *userInfo;
@end
