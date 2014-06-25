//
//  PointUpGameViewController.h
//  flapp
//
//  Created by 中山桂一 on 2014/06/18.
//  Copyright (c) 2014年 Pocket Solution Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NPAViewController.h"

@interface PointUpGameViewController : UIViewController <NPAViewControllerDataSource,NPAViewControllerDelegate>{
    NPAViewController *npaController;
}

@end
