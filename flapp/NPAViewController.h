//
//  NPAViewController.h
//
//  Created by Thanh  Ta on 5/19/14.
//  Copyright (c) 2014 BeetSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NPAItem.h"

@protocol NPAViewControllerDelegate;
@protocol NPAViewControllerDataSource;

@interface NPAViewController : UIViewController<NPAItemDelegate> {
    NSMutableArray *_arrayItems;
    UIImage *_background;
    UIImage *_bg_animation;
    UIView *_subView;
    UIView *_resultView;
    UIToolbar *_toolbar;
    UIImageView *_imgResult;
    NPAItem *_itemChoosed;
    NSTimer *_timer;
    BOOL _autoHidden;
}
@property (nonatomic, weak) id<NPAViewControllerDelegate> delegate;
@property (nonatomic, weak) id<NPAViewControllerDataSource> dataSource;
@property (nonatomic, assign) NSInteger numOfItems;
@property (nonatomic, setter = setAutoHidden:) BOOL autoHidden;


/**
 *	@brief	If you want auto hidden animation after award is showed, you will set this to YES. <Defaults its is setted YES>
 *  If you set YES, the view hidden away after 3 seconds. End then, call back didFinishEvents: is invoked
 *  If you set NO, you will call hiddenEventController to hidden view.
 *
 *	@param 	autoHidden 	BOOL
 *
 */
- (void)setAutoHidden:(BOOL)autoHidden;


/**
 *	@brief  method to show Event's view, that will cover the entire screen
 *
 *	@param 	rootViewController 	is Root view controller of window
 *
 *	@return	void
 */
- (void)showEventControllerAt:(UIViewController*)rootViewController;

/**
 *	@brief	hidden event from super view
 *  If variable autoHidden is setted YES, you won't call this. Otherwise, you call this to hidden event view, end then call back didFinishEvents: is invoked
 */
- (void)hiddenEventController;

@end

@protocol NPAViewControllerDataSource <NSObject>
- (NPAItem*)itemForIndex:(NSInteger)index;
@end

@protocol NPAViewControllerDelegate <NSObject>
- (void)didFinishEvents:(NPAItemType)itemType;
@end
