//
//  IssueGiftViewController.h
//  flapp
//
//  Created by 中山桂一 on 2014/03/26.
//  Copyright (c) 2014年 Pocket Solution Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IssueGiftTableViewCell.h"

@interface IssueGiftViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, copy) NSDictionary *exchangeInfo;

@end
