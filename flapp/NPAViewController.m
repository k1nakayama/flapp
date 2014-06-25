//
//  NPAViewController.m
//
//  Created by Thanh  Ta on 5/19/14.
//  Copyright (c) 2014 BeetSoft. All rights reserved.
//

#import "NPAViewController.h"
#import "NPALoadImage.h"

#ifdef NSFoundationVersionNumber_iOS_6_1
#define IsIOS7()                                                               \
	(floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
#else
#define IsIOS7() NO
#endif

// determine screen retina 4 inches
#define IS_WIDESCREEN                                                          \
	(fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)568) <    \
	 DBL_EPSILON)

#define STATUS_BAR_HIDDEN [UIApplication sharedApplication].statusBarHidden

#define DISTANCE 35
#define IMAGE_SIZE [UIImage imageNamed:@"Single_Box.png"].size
#define SCREEN_SIZE [UIScreen mainScreen].bounds.size
#define HEIGHT_OF_TOOLBAR 50
#define OFFSET (IS_WIDESCREEN ? (STATUS_BAR_HIDDEN ? (IsIOS7()?60:100) : (IsIOS7()?80:120)) : (STATUS_BAR_HIDDEN ? (IsIOS7()?55:95) : (IsIOS7()?75:115)))

#define IMAGE_NO_MONEY_TAG 33
#define IMAGE_MONEY_TAG 44

@interface NPAViewController ()

@end

@implementation NPAViewController

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		// Custom initialization
	}
	return self;
}

- (id)init {
	if (self = [super init]) {
		[self setUpDefault];
        
		return self;
	}

	return nil;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

/*
   #pragma mark - Navigation

   // In a storyboard-based application, you will often want to do a little
   preparation before navigation
   - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
   {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
   }
 */

#pragma mark - set up

- (void)setUpDefault {
	// set background
	_arrayItems = [NSMutableArray array];

	UIImageView *bg = [[UIImageView alloc]
	                   initWithImage:[NPALoadImage imageNamed:@"bg" isWideScreen:IS_WIDESCREEN]];
    if (!IsIOS7()) {
        CGSize sizeBg = bg.frame.size;
        CGPoint originBg = bg.frame.origin;
        
        [bg setFrame:CGRectMake(originBg.x, originBg.y - 30 , sizeBg.width, sizeBg.height)];
    }
	[self.view addSubview:bg];

	// Add text
	UIImageView *textImg =
	    [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"text2.png"]];
	[textImg
	 setFrame:CGRectMake(160 - textImg.image.size.width * 0.5,
                         (IS_WIDESCREEN ? (STATUS_BAR_HIDDEN ? (IsIOS7()? 80:50) : (IsIOS7()?60:30)) : ( STATUS_BAR_HIDDEN ? (IsIOS7()?60:30) : (IsIOS7()?40:10))), textImg.image.size.width,
	                     textImg.image.size.height)];
    NSLog(@"%f",textImg.frame.origin.y);

	[self.view addSubview:textImg];

	// creat sub view
	_subView = [[UIView alloc] initWithFrame:self.view.frame];
	[_subView setBackgroundColor:[UIColor whiteColor]];
	_subView.alpha = 0.0f;
    
    if (!IsIOS7()) {
        CGSize sizeResult = _subView.frame.size;
        CGPoint pointResult = _subView.frame.origin;
        
        [_subView setFrame:CGRectMake(pointResult.x, pointResult.y - 80, sizeResult.width, sizeResult.height)];
    }
    
	[self.view addSubview:_subView];

	_resultView = [[UIView alloc] initWithFrame:self.view.frame];
    
    if (!IsIOS7()) {
        CGSize sizeResult = _resultView.frame.size;
        CGPoint pointResult = _resultView.frame.origin;
        
        [_resultView setFrame:CGRectMake(pointResult.x, pointResult.y - 60, sizeResult.width, sizeResult.height)];
    }

	UIImageView *imgViewMoney = [[UIImageView alloc]
	                             initWithImage:[NPALoadImage imageNamed:@"animation_money"
	                                                       isWideScreen:IS_WIDESCREEN]];
	[imgViewMoney setTag:IMAGE_MONEY_TAG];

	UIImageView *imgViewNoMoney = [[UIImageView alloc]
	                               initWithImage:[NPALoadImage imageNamed:@"animation_no_money"
	                                                         isWideScreen:IS_WIDESCREEN]];
	[imgViewNoMoney setTag:IMAGE_NO_MONEY_TAG];

	[_resultView addSubview:imgViewNoMoney];
	[_resultView addSubview:imgViewMoney];

	[self.view addSubview:_resultView];

	[_resultView setHidden:YES];

	[self.view setUserInteractionEnabled:YES];
}

- (void)setNumOfItems:(NSInteger)numOfItems {
	NSAssert(numOfItems > 0, @"require num of item is larger than 0");
    NSAssert(self.dataSource, @"instance sent method -itemForIndex: unrecognize");

	[self setUpMe:numOfItems];
}

- (void)setUpMe:(NSInteger)num {
	CGFloat dx = (SCREEN_SIZE.width - DISTANCE) * 0.5 - IMAGE_SIZE.width;
	CGFloat dy =
	    (SCREEN_SIZE.height - HEIGHT_OF_TOOLBAR - IMAGE_SIZE.height) * 0.5 -
    OFFSET;

	for (int i = 0; i < num; i++) {
        if ([self.dataSource respondsToSelector:@selector(itemForIndex:)]) {
            NPAItem *item = [self.dataSource itemForIndex:i];
            item.delegate = self;
            item.image = [UIImage imageNamed:@"Single_Box.png"];
            
            CGFloat tx = 0;
            CGFloat ty = 0;
            
            if (i == 0) {
                tx = dx;
                ty = dy;
            }
            else {
                if (i % 2 == 0) {
                    dx -= DISTANCE + IMAGE_SIZE.width;
                    dy += DISTANCE + IMAGE_SIZE.height;
                }
                else {
                    dx += DISTANCE + IMAGE_SIZE.width;
                }
                
                tx = dx;
                ty = dy;
            }
            
            item.position = CGPointMake(tx, ty);
            [item setFrame:CGRectMake(tx, ty, IMAGE_SIZE.width, IMAGE_SIZE.height)];
            
            [item setUserInteractionEnabled:YES];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                           initWithTarget:self
                                           action:@selector(eventHandlerTouch:)];
            [item addGestureRecognizer:tap];
            
            [self.view addSubview:item];
            [self.view bringSubviewToFront:item];
            
            [_arrayItems addObject:item];
        }
	}
}

- (void)hiddenOthersItemExcept:(NPAItem *)item {
	for (NPAItem *_it in _arrayItems) {
		if (_it != item) {
			[_it setHidden:YES];
		}
	}
}

#pragma mark - animation

- (NSArray *)makeAnimationMoney {
	return @[
	    [UIImage imageNamed:@"animation_money_1.png"],
	    [UIImage imageNamed:@"animation_money_2.png"],
	    [UIImage imageNamed:@"animation_money_3.png"],
	    [UIImage imageNamed:@"animation_money_4.png"]
	];
}

- (NSArray *)makeAnimationNoMoney {
	return @[
	    [UIImage imageNamed:@"animation_nomoney_1.png"],
	    [UIImage imageNamed:@"animation_nomoney_2.png"],
	    [UIImage imageNamed:@"animation_nomoney_3.png"],
	    [UIImage imageNamed:@"animation_nomoney_4.png"]
	];
}

- (void)startAnimation:(NSArray *)arr forImageView:(UIImageView *)imageView {
	[imageView setAnimationImages:arr];
	[imageView setAnimationRepeatCount:0];
	[imageView setAnimationDuration:0.5f];

	[imageView startAnimating];
    
    if (_autoHidden) {
        NSLog(@"animationStart");
        //[self startTimer];
        if ([self.delegate respondsToSelector:@selector(didFinishEvents:)]) {
            [self.delegate didFinishEvents:_itemChoosed.itemType];
        }
    }
}

- (void)stopAnimation:(UIImageView *)imageView {
	[imageView stopAnimating];
}

#pragma mark - Timer

- (void)startTimer {
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:3.0f
                                                  target:self
                                                selector:@selector(done)
                                                userInfo:nil
                                                 repeats:NO];
    }
}

- (void)stopTimer {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

#pragma mark - Handler event click

- (void)eventHandlerTouch:(UITapGestureRecognizer *)tap {
	NPAItem *item = (NPAItem *)tap.view;
	_itemChoosed = item;
	[self hiddenOthersItemExcept:item];

	[item moveToPosition:CGPointMake(SCREEN_SIZE.width * 0.5,
	                                 SCREEN_SIZE.height * 0.5 - (IsIOS7()?0:item.frame.size.height*0.47))
	              atView:self.view];
}

- (void)done {
    [self.view setUserInteractionEnabled:NO];
    [UIView beginAnimations:@"Face In" context:nil];
    [UIView animateWithDuration:1.0f
                          delay:0.0f
                        options:UIViewAnimationOptionShowHideTransitionViews
                     animations:^{
                         self.view.alpha = 0.0f;
                     }
                     completion:^(BOOL finished) {
                         [self stopTimer];
                         [_imgResult stopAnimating];
                         _imgResult = nil;
                         
                         if ([self.delegate respondsToSelector:@selector(didFinishEvents:)]) {
                             [self.delegate didFinishEvents:_itemChoosed.itemType];
                         }
                         
                         [self.view removeFromSuperview];
                     }];
    [UIView commitAnimations];
}

#pragma mark -

- (void)setAutoHidden:(BOOL)autoHidden {
    //NSLog(@"autoHidden %hhd",_autoHidden);
    _autoHidden = autoHidden;
}

- (void)showEventControllerAt:(UIViewController *)rootViewController {
    self.view.alpha = 0.0;
    [self.view setUserInteractionEnabled:NO];
    [rootViewController.view addSubview:self.view];
    [UIView beginAnimations:@"Face In" context:nil];
    [UIView animateWithDuration:1.0f
                          delay:0.0f
                        options:UIViewAnimationOptionShowHideTransitionViews
                     animations:^{
                         self.view.alpha = 1.0f;
                     }
                     completion:^(BOOL finished) {
                        [self.view setUserInteractionEnabled:YES];
                     }];
    [UIView commitAnimations];
}

- (void)hiddenEventController {
    [self.view setUserInteractionEnabled:NO];
    [UIView beginAnimations:@"Face In" context:nil];
    [UIView animateWithDuration:1.0f
                          delay:0.0f
                        options:UIViewAnimationOptionShowHideTransitionViews
                     animations:^{
                         self.view.alpha = 0.0f;
                     }
                     completion:^(BOOL finished) {
                         [_imgResult stopAnimating];
                         /*
                         if ([self.delegate respondsToSelector:@selector(didFinishEvents:)]) {
                             [self.delegate didFinishEvents:_itemChoosed.itemType];
                         }
                         */
                         [self.view removeFromSuperview];
                     }];
    [UIView commitAnimations];
}

#pragma mark -
#pragma mark NPAItemDelegate

- (void)finishAnimation:(NSString *)name withItem:(NPAItem *)item {
	if ([name isEqualToString:@"Move"]) {
		[UIView beginAnimations:@"Fade" context:nil];

		[UIView animateWithDuration:0.5f
		                      delay:0.1f
		                    options:UIViewAnimationOptionShowHideTransitionViews
		                 animations: ^{
		    _subView.alpha = 1.0f;
		}

		                 completion: ^(BOOL finish) {
		    if (finish) {
		        [UIView animateWithDuration:0.5f
		                              delay:0.1f
		                            options:UIViewAnimationOptionShowHideTransitionViews
		                         animations: ^{
		            _subView.alpha = 0.0f;
				}

		                         completion: ^(BOOL finish) {
		            // TODO: show result
		            [item setHidden:YES];

		            [_resultView setHidden:NO];

		            _imgResult = nil;

		            if (item.itemType == kItemNone) {
		                [[_resultView viewWithTag:IMAGE_MONEY_TAG]
		                 setHidden:YES];

		                _imgResult = [[UIImageView alloc]
		                              initWithImage:
		                              [UIImage imageNamed:@"animation_nomoney_1.png"]];
		                [_imgResult
		                 setFrame:
		                 CGRectMake(
		                     SCREEN_SIZE.width * 0.5 -
		                     _imgResult.image.size
		                     .width *
		                     0.5,
                            ( !IS_WIDESCREEN ? 0 : 59), _imgResult.image.size.width,
		                     _imgResult.image.size.height)];

		                [_resultView addSubview:_imgResult];

		                UIImageView *text1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"text1.png"]];
		                UIImageView *text2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"text3.png"]];

		                [text1 setFrame:CGRectMake(160 - text1.image.size.width * 0.5, (IS_WIDESCREEN ? (IsIOS7()?100:60) : (IsIOS7()?75:35)), text1.image.size.width, text1.image.size.height)];
		                [text2 setFrame:CGRectMake(160 - text2.image.size.width * 0.5, (IS_WIDESCREEN ? (IsIOS7()?100:60) : (IsIOS7()?75:35)) + text1.image.size.height + (IS_WIDESCREEN ? 20 : 15), text2.image.size.width, text2.image.size.height)];

		                [self.view addSubview:text1];
		                [self.view addSubview:text2];

		                [self startAnimation:
		                 [self makeAnimationNoMoney]
		                        forImageView:_imgResult];
					}
		            else {
		                [[_resultView
		                  viewWithTag:IMAGE_NO_MONEY_TAG]
		                 setHidden:YES];

		                UIImageView *coin = nil;

		                switch (item.itemType) {
							case kItem10: {
								coin = [[UIImageView alloc]
								        initWithImage:
								        [UIImage
								         imageNamed:
								         [ArrayItemName
								          objectAtIndex:
								          kItem10 - 1]]];
							} break;

							case kItem50: {
								coin = [[UIImageView alloc]
								        initWithImage:
								        [UIImage
								         imageNamed:
								         [ArrayItemName
								          objectAtIndex:
								          kItem50 - 1]]];
							} break;

							case kItem100: {
								coin = [[UIImageView alloc]
								        initWithImage:
								        [UIImage
								         imageNamed:
								         [ArrayItemName
								          objectAtIndex:
								          kItem100 - 1]]];
							} break;

							case kItem500: {
								coin = [[UIImageView alloc]
								        initWithImage:
								        [UIImage
								         imageNamed:
								         [ArrayItemName
								          objectAtIndex:
								          kItem500 - 1]]];
							} break;

							case kItem1000: {
								coin = [[UIImageView alloc]
								        initWithImage:
								        [UIImage
								         imageNamed:
								         [ArrayItemName
								          objectAtIndex:
								          kItem1000 - 1]]];
							} break;

							case kItem10000: {
								coin = [[UIImageView alloc]
								        initWithImage:
								        [UIImage imageNamed:
								         [ArrayItemName
								          objectAtIndex:
								          kItem10000 -
								          1]]];
							} break;

							default:
								break;
						}

		                [coin setFrame:
		                 CGRectMake(
		                     SCREEN_SIZE.width * 0.5 -
		                     coin.image.size.width *
		                     0.5,
                            ( !IS_WIDESCREEN ? SCREEN_SIZE.height * 0.49 : SCREEN_SIZE.height * 0.52),
		                     coin.image.size.width,
		                     coin.image.size.height)];
		                [_resultView addSubview:coin];

		                _imgResult = [[UIImageView alloc]
		                              initWithImage:
		                              [UIImage
		                               imageNamed:
		                               @"animation_money_1.png"]];
		                [_imgResult
		                 setFrame:
		                 CGRectMake(
		                     SCREEN_SIZE.width * 0.52 -
		                     _imgResult.image.size
		                     .width *
		                     0.5,
                            ( !IS_WIDESCREEN ? -SCREEN_SIZE.height * 0.05 : SCREEN_SIZE.height * 0.03),
		                     _imgResult.image.size.width,
		                     _imgResult.image.size.height)];

		                [_resultView addSubview:_imgResult];

		                [self startAnimation:
		                 [self makeAnimationMoney]
		                        forImageView:_imgResult];
					}

		            [self.view bringSubviewToFront:_toolbar];
				}];
			}
		}];

		[UIView commitAnimations];
	}
}

@end
