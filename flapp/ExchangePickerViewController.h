//
//  ExchangePickerViewController.h
//  flapp
//
//  Created by 中山桂一 on 2014/04/02.
//  Copyright (c) 2014年 Pocket Solution Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ExchangePickerViewDelegate;

@interface ExchangePickerViewController : UIViewController<UIPickerViewDelegate,UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UIPickerView *picker;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) id<ExchangePickerViewDelegate> delegate;
@property (assign,nonatomic) NSInteger selectFieldTag;
@property (assign,nonatomic) NSInteger selectedValue;

- (IBAction)closePickerView:(id)sender;
@end

@protocol ExchangePickerViewDelegate <NSObject>

-(void)applySelectedString:(NSString *)str selectFieldTag:(NSInteger)tag;
-(void)closePickerView:(ExchangePickerViewController *)controller;

@end

