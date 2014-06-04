//
//  NoticePopupViewController.h
//  flapp
//
//  Created by 中山桂一 on 2014/03/25.
//  Copyright (c) 2014年 Pocket Solution Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NoticePopupDelegate;

@interface NoticePopupViewController : UIViewController

@property (assign, nonatomic) id <NoticePopupDelegate>delegate;
@property (weak, nonatomic) IBOutlet UILabel *noticeLabel;
@property (weak, nonatomic) IBOutlet UIButton *okButton;
@property (nonatomic, assign) NSString *notice;

@end

@protocol NoticePopupDelegate<NSObject>
@optional
- (void)okButtonClicked:(NoticePopupViewController *)popupViewController;
@end
