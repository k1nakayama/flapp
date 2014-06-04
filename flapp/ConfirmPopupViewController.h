//
//  ConfirmPopoupViewController.h
//  flapp
//
//  Created by 中山桂一 on 2014/03/25.
//  Copyright (c) 2014年 Pocket Solution Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ConfirmPopupDelegate;
@interface ConfirmPopupViewController : UIViewController

@property (assign, nonatomic) id <ConfirmPopupDelegate>delegate;
@property (nonatomic, assign) NSString *confirm;
@property (nonatomic, assign) NSString *okLabel;
@property (nonatomic, assign) NSString *cancelLabel;


@end

@protocol ConfirmPopupDelegate<NSObject>
@optional
- (void)okButtonClicked:(ConfirmPopupViewController *)popupViewController;
- (void)cancelButtonClicked:(ConfirmPopupViewController *)popupViewController;

@end