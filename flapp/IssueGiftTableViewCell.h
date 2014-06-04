//
//  IssueGiftTableViewCell.h
//  flapp
//
//  Created by 中山桂一 on 2014/03/26.
//  Copyright (c) 2014年 Pocket Solution Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IssueGiftTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *gift_desc_label;
@property (weak, nonatomic) IBOutlet UILabel *gift_code_label;
@property (weak, nonatomic) IBOutlet UILabel *manage_label;

@end
