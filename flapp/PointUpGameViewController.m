//
//  PointUpGameViewController.m
//  flapp
//
//  Created by 中山桂一 on 2014/06/18.
//  Copyright (c) 2014年 Pocket Solution Inc. All rights reserved.
//

#import "PointUpGameViewController.h"
#import "NPAViewController.h"

@interface PointUpGameViewController ()

@end

@implementation PointUpGameViewController{
    NPAViewController *npavc;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UIImage *unselectImg = [[UIImage imageNamed:@"footer41"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage *selectImg = [[UIImage imageNamed:@"footer40"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"ゲーム" image:unselectImg tag:4];
        [self.tabBarItem setSelectedImage:selectImg];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    npavc = [[NPAViewController alloc] init];
    [npavc setNumOfItems:6];
    [npavc showEventControllerAt:self];
    //[self.view addSubview:npavc.view];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidAppear:(BOOL)animated{
    if([npavc.view isDescendantOfView:self.view]){
        NSLog(@"npavc exist");
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
