//
//  DetailViewCell.h
//  testApp031105
//
//  Created by 中山桂一 on 2014/03/11.
//  Copyright (c) 2014年 Pocket Solution Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BannerListViewCell : UITableViewCell
@property (weak,nonatomic) IBOutlet UILabel *title;
@property (weak,nonatomic) IBOutlet UILabel *condition;
@property (weak,nonatomic) IBOutlet UILabel *point;
@property (weak,nonatomic) IBOutlet UIImageView *bnr_image;
@property (weak,nonatomic) IBOutlet UIImageView *obi_image;


@end
