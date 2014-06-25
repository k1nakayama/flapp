//
//  PointUpGameViewController.m
//  flapp
//
//  Created by 中山桂一 on 2014/06/18.
//  Copyright (c) 2014年 Pocket Solution Inc. All rights reserved.
//

#import "PointUpGameViewController.h"

@interface PointUpGameViewController (){
    NSTimer *timer;
}

@end

@implementation PointUpGameViewController

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

- (void) hiddenEvent{
    //[npaController hiddenEventController];
}

- (void) startTimer {
    if(timer == nil){
        timer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(hiddenEvent) userInfo:nil repeats:NO];
    }
}

- (void)stopTimer{
    if(timer){
        [timer invalidate];
        timer = nil;
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if(npaController == nil){
        npaController = [[NPAViewController alloc] init];
    } else {
        [npaController hiddenEventController];
        npaController = [[NPAViewController alloc] init];
    }
    NSLog(@"npaController %@",npaController);
    NSLog(@"setAutoHidden");
    [npaController setAutoHidden:YES];
    NSLog(@"setDelegate");
    [npaController setDelegate:self];
    NSLog(@"setDatasource");
    [npaController setDataSource:self];
    
    NSLog(@"setNumOfItems");
    [npaController setNumOfItems:6];
    NSLog(@"setEventControllerAt");
    [npaController showEventControllerAt:self];
    /*
    if(![npaController autoHidden]){
        [self startTimer];
    }
     */

}

- (void)viewDidLoad
{
    [super viewDidLoad];

    //[self.view addSubview:npavc.view];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidAppear:(BOOL)animated{
    /*
    [npaController hiddenEventController];
    npaController = nil;
    [super viewDidAppear:animated];
     */
}

-(NPAItem *)itemForIndex:(NSInteger)index{
    if(index == 0){
        return [[NPAItem alloc] itemWithType:kItem10];
    } else if(index == 1){
        return [[NPAItem alloc] itemWithType:kItem500];
    } else if(index == 2){
        return [[NPAItem alloc] itemWithType:kItem10000];
    } else if(index == 3){
        return [[NPAItem alloc] itemWithType:kItem100];
    } else if(index == 4){
        return [[NPAItem alloc] itemWithType:kItem50];
    } else if(index == 5){
        return [[NPAItem alloc] itemWithType:kItemNone];
    } else {
        return [[NPAItem alloc] itemWithType:kItem1000];
    }
}

-(void)didFinishEvents:(NPAItemType)itemType{
    NSLog(@"didFinishEvent");
    //[self hiddenEvent];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
