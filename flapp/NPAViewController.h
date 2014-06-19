//
//  NPAViewController.h
//
//  Created by Thanh  Ta on 5/19/14.
//  Copyright (c) 2014 BeetSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NPAItem.h"

@protocol NPAViewControllerDelegate;

@interface NPAViewController : UIViewController<NPAItemDelegate> {
    NSMutableArray *_arrayItems;
    UIImage *_background;
    UIImage *_bg_animation;
    UIView *_subView;
    UIView *_resultView;
    UIToolbar *_toolbar;
    UIImageView *_imgResult;
    NPAItem *_itemChoosed;
}
@property (nonatomic, assign) id<NPAViewControllerDelegate> delegate;
@property (nonatomic, assign) NSInteger numOfItems;

/**
 *	@brief  method to show Event's view, that will cover the entire screen
 *
 *	@param 	rootViewController 	is Root view controller of window
 *
 *	@return	void
 */
- (void)showEventControllerAt:(UIViewController*)rootViewController;


@end

@protocol NPAViewControllerDelegate <NSObject>

- (void)didFinishEvents:(NPAItemType)itemType;


@end
