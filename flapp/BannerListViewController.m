//
//  BannerListViewController.m
//  flapp
//
//  Created by 中山桂一 on 2014/03/18.
//  Copyright (c) 2014年 Pocket Solution Inc. All rights reserved.
//

#import "BannerListViewController.h"
#import "AppApiUtil.h"
#import "JDFlipNumberView.h"
#import "BannerDetailViewController.h"
#import "NewPointViewController.h"
#import "UIImageView+WebCache.h"

@interface BannerListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *charaImage;
@property (weak, nonatomic) IBOutlet UIView *pointStatusView;
@property (weak, nonatomic) IBOutlet UILabel *nextStageLabel;
@property (weak, nonatomic) IBOutlet UIButton *popupBtn;

@end

@implementation BannerListViewController{
    NSArray *bannerInfo;
    NSArray *viewBannerInfo;
    NSArray *recommendInfo;
    NSDictionary *userInfo;
    //UISegmentedControl *segment1;
    //UISegmentedControl *segment2;
    UILabel *gradeup_label;
    NewPointViewController *newPointView;
    UIButton *filteringBtn1;
    UIButton *filteringBtn2;
    UIButton *filteringBtn3;
    UIButton *sortBtn1;
    UIButton *sortBtn2;
    int filteringStatus;
    int sortStatus;
    AppApiUtil *apiUtil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"貯める" image:[UIImage imageNamed:@"money"] tag:1];
        NSLog(@"exec nibNameOrNil");
        UIImage *unselectImg = [[UIImage imageNamed:@"footer11"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage *selectImg = [[UIImage imageNamed:@"footer10"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"貯める" image:unselectImg tag:1];
        [self.tabBarItem setSelectedImage:selectImg];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSLog(@"exec viewDidLoad");

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    //self.navigationItem.title = @"ポイント忍者くん";
    //UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320,44)];
    //[navigationBar sizeToFit];
    
    UIImageView *navigationTitle = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title_type02_2.png"]];

    //UIView *titleview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    //titleview.opaque = NO;
    //self.navigationItem.titleView = titleview;
    self.navigationItem.titleView = navigationTitle;
    
    //UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 195, 20)];
    //titlelabel.text = @"test";
    //[titleview addSubview:titlelabel];
    
    //self.navigationController.navigationBar.backgroundColor = [UIColor orangeColor];
    //self.navigationController.navigationBar.barTintColor = [UIColor orangeColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:1.0 green:0.398 blue:0 alpha:1.0];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:1.0 green:0.398 blue:0 alpha:1.0];
    
    //self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:1.0 green:0.597 blue:0.199 alpha:1.0];
    //self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:1.0 green:0.597 blue:0.199 alpha:1.0];
    
    //self.charaImage.image = [UIImage imageNamed:@"funassi.png"];
    
    //self.charaImage.image = [UIImage imageNamed:@"ninja3-01.png"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"BannerListViewCell" bundle:nil] forCellReuseIdentifier:@"BannerCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"RecommendedListViewCell" bundle:nil] forCellReuseIdentifier:@"RecommendedCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"BannerListCategoryViewCell" bundle:nil] forCellReuseIdentifier:@"CategoryCell"];

    if(filteringBtn1 == nil){
        filteringBtn1 = [[UIButton alloc] initWithFrame:CGRectMake(10, 8, 100, 40)];
        [filteringBtn1 setTag:1];
        [filteringBtn1 setBackgroundImage:[UIImage imageNamed:@"button1.png"] forState:UIControlStateNormal];
        [filteringBtn1 addTarget:self action:@selector(segmentDidChange:) forControlEvents:UIControlEventTouchDown];
    }
    if(filteringBtn2 == nil){
        filteringBtn2 = [[UIButton alloc] initWithFrame:CGRectMake(110, 8, 100, 40)];
        [filteringBtn2 setTag:2];
        [filteringBtn2 setBackgroundImage:[UIImage imageNamed:@"button3.png"] forState:UIControlStateNormal];
        [filteringBtn2 addTarget:self action:@selector(segmentDidChange:) forControlEvents:UIControlEventTouchDown];
    }
    if(filteringBtn3 == nil){
        filteringBtn3 = [[UIButton alloc] initWithFrame:CGRectMake(210, 8, 100, 40)];
        [filteringBtn3 setTag:3];
        [filteringBtn3 setBackgroundImage:[UIImage imageNamed:@"button2.png"] forState:UIControlStateNormal];
        [filteringBtn3 addTarget:self action:@selector(segmentDidChange:) forControlEvents:UIControlEventTouchDown];
    }
    if(sortBtn1 == nil){
        sortBtn1 = [[UIButton alloc] initWithFrame:CGRectMake(40, 50, 110, 40)];
        [sortBtn1 setTag:4];
        [sortBtn1 setBackgroundImage:[UIImage imageNamed:@"Segment2.png"] forState:UIControlStateNormal];
        [sortBtn1 addTarget:self action:@selector(segmentDidChange:) forControlEvents:UIControlEventTouchDown];
    }
    if(sortBtn2 == nil){
        sortBtn2 = [[UIButton alloc] initWithFrame:CGRectMake(160, 50, 110, 40)];
        [sortBtn2 setTag:5];
        [sortBtn2 setBackgroundImage:[UIImage imageNamed:@"Segment1.png"] forState:UIControlStateNormal];
        [sortBtn2 addTarget:self action:@selector(segmentDidChange:) forControlEvents:UIControlEventTouchDown];
    }
    
    /*
    if(segment1 == nil){
        NSArray *items = [NSArray arrayWithObjects:@"アプリDL",@"登録案件",@"その他",nil];
        segment1 = [[UISegmentedControl alloc] initWithItems:items];
        segment1.selectedSegmentIndex = 0;
        segment1.frame = CGRectMake(20, 7, 280, 29);
        [segment1 addTarget:self action:@selector(segmentDidChange:) forControlEvents:UIControlEventValueChanged];
    }
    
    if(segment2 == nil){
        NSArray *items2 = [NSArray arrayWithObjects:@"新着順",@"獲得ポイント順",nil];
        segment2 = [[UISegmentedControl alloc] initWithItems:items2];
        segment2.selectedSegmentIndex = 0;
        segment2.frame = CGRectMake(20, 43, 280, 29);
        [segment2 addTarget:self action:@selector(segmentDidChange:) forControlEvents:UIControlEventValueChanged];
    }
    */
     
}
-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"exec viewWillAppear");
    _progress = [[MBProgressHUD alloc] initWithView:self.view];
    _progress.labelText = @"読み込み中";
    [self.view addSubview:_progress];
    [_progress show:YES];
     
    apiUtil = [[AppApiUtil alloc] init];

    /*
    recommendInfo = [apiUtil getRecommended];
    bannerInfo = [apiUtil getBanner];
    */
    recommendInfo = nil;
    bannerInfo = nil;
    //[self.tableView reloadData];
    
    userInfo = [apiUtil getUserInfo];
    //NSLog(@"userInfo:%@",userInfo);
    JDFlipNumberView *flipNumberView = [[JDFlipNumberView alloc] initWithDigitCount:7];
    flipNumberView.value = [[userInfo objectForKey:@"point"] integerValue];
    flipNumberView.frame = CGRectMake(80, 2, 200, 60);
    [self.pointStatusView addSubview:flipNumberView];
    /*
    if([[userInfo objectForKey:@"grade"] isEqualToString:@"GRADE-B"]){
        self.tableView.backgroundColor = [UIColor colorWithRed:0.749 green:0.784 blue:0.756 alpha:1.0];
    } else if([[userInfo objectForKey:@"grade"] isEqualToString:@"GRADE-C"]){
        self.tableView.backgroundColor = [UIColor colorWithRed:0.941 green:0.776 blue:0.286 alpha:1.0];
    } else if([[userInfo objectForKey:@"grade"] isEqualToString:@"GRADE-D"]){
        self.tableView.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
    } else if([[userInfo objectForKey:@"grade"] isEqualToString:@"GRADE-E"]){
        self.tableView.backgroundColor = [UIColor colorWithRed:0.725 green:0.949 blue:1.0 alpha:1.0];
    } else {
        //self.tableView.backgroundColor = [UIColor colorWithRed:0.592 green:0.419 blue:0.184 alpha:1.0];
        self.tableView.backgroundColor = [UIColor yellowColor];
    }
    */
    if([[userInfo objectForKey:@"grade"] isEqualToString:@"中忍"]){
        self.charaImage.image = [UIImage imageNamed:@"ninja3-02.png"];
    } else if([[userInfo objectForKey:@"grade"] isEqualToString:@"上忍"]){
        self.charaImage.image = [UIImage imageNamed:@"ninja3-03.png"];
    } else if([[userInfo objectForKey:@"grade"] isEqualToString:@"達忍"]){
        self.charaImage.image = [UIImage imageNamed:@"ninja3-04.png"];
    } else if([[userInfo objectForKey:@"grade"] isEqualToString:@"超忍"]){
        self.charaImage.image = [UIImage imageNamed:@"ninja3-05.png"];
    } else {
        self.charaImage.image = [UIImage imageNamed:@"ninja3-01.png"];
    }
    
    self.tableView.backgroundColor = [UIColor orangeColor];
    
    if(gradeup_label == nil){
        NSMutableString *gradeup_str = [NSMutableString string];
        [gradeup_str appendString:@"あと"];
        [gradeup_str appendString:[NSString stringWithFormat:@"%d",[[userInfo objectForKey:@"grade_up_point"] intValue]]];
        [gradeup_str appendString:@"Gで来月『"];
        [gradeup_str appendString:[userInfo objectForKey:@"next_grade"]];
        [gradeup_str appendString:@"』ランク確定"];
        //gradeup_label = [[UILabel alloc] initWithFrame:CGRectMake(20, 4, 280, 30)];
        self.nextStageLabel.text = gradeup_str;
        self.nextStageLabel.font = [UIFont systemFontOfSize:15.0f];
        self.nextStageLabel.textAlignment = NSTextAlignmentCenter;
        self.nextStageLabel.backgroundColor = [UIColor whiteColor];
    }
    
    //[self segmentDidChange:nil];
    
    //NSLog(@"bannerInfo: %lu",(unsigned long)[bannerInfo count]);
}
-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"exec viewDidAppear");
    [self segmentDidChange:nil];

    //新着ポイントをチェック
    NSDictionary *newPointResult = [apiUtil checkNewPoint];
    if([[newPointResult objectForKey:@"detail_code"] isEqualToString:@"00"]){
        //NEWPOINT表示
        NSLog(@"NewPoint: %d",[[newPointResult objectForKey:@"new_point"] intValue]);
        [self popupNewPointView:[newPointResult objectForKey:@"new_point"]];
    }
    
    [_progress hide:YES];
}
-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    NSLog(@"exec didSelectViewController");
    if(apiUtil == nil){
        apiUtil = [[AppApiUtil alloc] init];
    }
    recommendInfo = [apiUtil getRecommended];
    NSString *category = @"DL";
    NSString *sort = @"NEW";
    bannerInfo = [apiUtil getBanner:category sort:sort];
}

-(void)hudWasHidden:(MBProgressHUD *)hud{
    //NSLog(@"exec hudWasHidden");
    [_progress removeFromSuperview];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //NSLog(@"exec numberOfSectionsInTableView");
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //NSLog(@"exec numberOfRowsInSection");
    switch (section) {
        case 0:
            return recommendInfo.count;
            break;
        case 1:
            //return bannerInfo.count+1;
            return viewBannerInfo.count+1;
        default:
            break;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSLog(@"exec cellForRowAtIndexPath");

    NSString *identifier;
    if(indexPath.section == 0){
        identifier = @"RecommendedCell";
    } else {
        if(indexPath.row <= 0){
            identifier = @"CategoryCell";
        } else {
            identifier = @"BannerCell";
        }
    }
    BannerListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if(indexPath.section == 0){
        int banner_row = (int)indexPath.row;
        NSDictionary *banner = [recommendInfo objectAtIndex:banner_row];
        
        cell.backgroundColor = [UIColor clearColor];
        
        
        cell.title.text = [banner objectForKey:@"title"];
        cell.condition.text = [banner objectForKey:@"affiliate_condition"];
        cell.point.text = [NSString stringWithFormat:@"%@G",[banner objectForKey:@"point"]];

        if([banner objectForKey:@"image_url"] != [NSNull null] && [[banner objectForKey:@"image_url"] length] > 0 ){
            
            NSURL *bnrImgUrl = [NSURL URLWithString:[banner objectForKey:@"image_url"]];
            UIImage *placeholderImage = [UIImage imageNamed:@"nowprinting.png"];
            [cell.bnr_image sd_setImageWithURL:bnrImgUrl placeholderImage:placeholderImage options:SDWebImageCacheMemoryOnly];
            
            /*
             dispatch_queue_t q_global = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
             dispatch_queue_t q_main = dispatch_get_main_queue();
             
             cell.bnr_image.image = nil;
             
             dispatch_async(q_global, ^{
             NSURL *bnrImgUrl = [NSURL URLWithString:[banner objectForKey:@"image_url"]];
             NSData *bnrImgData = [NSData dataWithContentsOfURL:bnrImgUrl];
             UIImage *bnrImage = [UIImage imageWithData:bnrImgData];
             
             dispatch_async(q_main, ^{
             cell.bnr_image.image = bnrImage;
             });
             });
             */
        } else {
            UIImage *placeholderImage = [UIImage imageNamed:@"nowprinting.png"];
            cell.bnr_image.image = placeholderImage;
        }
        /*
        if([banner objectForKey:@"image_url"] != [NSNull null] && [[banner objectForKey:@"image_url"] length] > 0 ){
            
            dispatch_queue_t q_global = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_queue_t q_main = dispatch_get_main_queue();
            
            cell.bnr_image.image = nil;
            
            dispatch_async(q_global, ^{
                NSURL *bnrImgUrl = [NSURL URLWithString:[banner objectForKey:@"image_url"]];
                NSData *bnrImgData = [NSData dataWithContentsOfURL:bnrImgUrl];
                UIImage *bnrImage = [UIImage imageWithData:bnrImgData];
                
                dispatch_async(q_main, ^{
                    cell.bnr_image.image = bnrImage;
                });
            });
        }
        */

        if([[banner objectForKey:@"is_high"] intValue] == 1){
            cell.obi_image.image = [UIImage imageNamed:@"high.png"];
        } else if([[banner objectForKey:@"is_free"] intValue] == 1){
            cell.obi_image.image = [UIImage imageNamed:@"free.png"];
        } else if([[banner objectForKey:@"is_new"] intValue] == 1){
            cell.obi_image.image = [UIImage imageNamed:@"new.png"];
        }
        
        cell.category_image1.image = nil;
        cell.category_image2.image = nil;
        cell.category_image3.image = nil;
        
        NSMutableArray *category_array = [[NSMutableArray alloc] init];
        if([[banner objectForKey:@"is_limit"] intValue] == 1){
            [category_array addObject:@"is_limit"];
        }
        if([[banner objectForKey:@"is_up"] intValue] == 1){
            [category_array addObject:@"is_up"];
        }
        if([[banner objectForKey:@"is_exclusive"] intValue] == 1){
            [category_array addObject:@"is_exclusive"];
        }
        if([[banner objectForKey:@"is_revival"] intValue] == 1){
            [category_array addObject:@"is_revival"];
        }
        int c = 1;
        for(NSString *category_key in category_array){
            
            if([category_key isEqualToString:@"is_limit"]){
                switch (c) {
                    case 1:
                        cell.category_image1.image = [UIImage imageNamed:@"lable1.png"];
                        c++;
                        break;
                    case 2:
                        cell.category_image2.image = [UIImage imageNamed:@"lable1.png"];
                        c++;
                        break;
                    case 3:
                        cell.category_image3.image = [UIImage imageNamed:@"lable1.png"];
                        c++;
                        break;
                    default:
                        break;
                }
            }
            if([category_key isEqualToString:@"is_up"]){
                switch (c) {
                    case 1:
                        cell.category_image1.image = [UIImage imageNamed:@"lable4.png"];
                        c++;
                        break;
                    case 2:
                        cell.category_image2.image = [UIImage imageNamed:@"lable4.png"];
                        c++;
                        break;
                    case 3:
                        cell.category_image3.image = [UIImage imageNamed:@"lable4.png"];
                        c++;
                        break;
                    default:
                        break;
                }
            }
            if([category_key isEqualToString:@"is_exclusive"]){
                switch (c) {
                    case 1:
                        cell.category_image1.image = [UIImage imageNamed:@"lable3.png"];
                        c++;
                        break;
                    case 2:
                        cell.category_image2.image = [UIImage imageNamed:@"lable3.png"];
                        c++;
                        break;
                    case 3:
                        cell.category_image3.image = [UIImage imageNamed:@"lable3.png"];
                        c++;
                        break;
                    default:
                        break;
                }
            }
            if([category_key isEqualToString:@"is_revival"]){
                switch (c) {
                    case 1:
                        cell.category_image1.image = [UIImage imageNamed:@"lable2.png"];
                        c++;
                        break;
                    case 2:
                        cell.category_image2.image = [UIImage imageNamed:@"lable2.png"];
                        c++;
                        break;
                    case 3:
                        cell.category_image3.image = [UIImage imageNamed:@"lable2.png"];
                        c++;
                        break;
                    default:
                        break;
                }
            }
            
        }
        
    } else {
        switch (indexPath.row) {
            /*
            case 0:
            {
                cell.backgroundColor = [UIColor colorWithRed:1 green:0.96078437566757202 blue:0.79607850313186646 alpha:1];
                [cell.contentView addSubview:gradeup_label];
                break;
            }
            */
            case 0:{
                cell.backgroundColor = [UIColor colorWithRed:1 green:0.96078437566757202 blue:0.79607850313186646 alpha:1];
                //[cell.contentView addSubview:segment1];
                //[cell.contentView addSubview:segment2];
                [cell.contentView addSubview:filteringBtn1];
                [cell.contentView addSubview:filteringBtn2];
                [cell.contentView addSubview:filteringBtn3];
                [cell.contentView addSubview:sortBtn1];
                [cell.contentView addSubview:sortBtn2];
                break;
            }
            default:
            {
                int banner_row = (int)indexPath.row - 1;
                NSDictionary *banner = [viewBannerInfo objectAtIndex:banner_row];
                //NSDictionary *banner = [bannerInfo objectAtIndex:banner_row];
                
                cell.backgroundColor = [UIColor clearColor];
                
                
                cell.title.text = [banner objectForKey:@"title"];
                cell.condition.text = [banner objectForKey:@"affiliate_condition"];
                cell.point.text = [NSString stringWithFormat:@"%@G",[banner objectForKey:@"point"]];
                
                if([banner objectForKey:@"image_url"] != [NSNull null] && [[banner objectForKey:@"image_url"] length] > 0 ){
                    
                    NSURL *bnrImgUrl = [NSURL URLWithString:[banner objectForKey:@"image_url"]];
                    UIImage *placeholderImage = [UIImage imageNamed:@"nowprinting.png"];
                    [cell.bnr_image sd_setImageWithURL:bnrImgUrl placeholderImage:placeholderImage options:SDWebImageCacheMemoryOnly];

                    /*
                    dispatch_queue_t q_global = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                    dispatch_queue_t q_main = dispatch_get_main_queue();
                    
                    cell.bnr_image.image = nil;
                    
                    dispatch_async(q_global, ^{
                        NSURL *bnrImgUrl = [NSURL URLWithString:[banner objectForKey:@"image_url"]];
                        NSData *bnrImgData = [NSData dataWithContentsOfURL:bnrImgUrl];
                        UIImage *bnrImage = [UIImage imageWithData:bnrImgData];
                        
                        dispatch_async(q_main, ^{
                            cell.bnr_image.image = bnrImage;
                        });
                    });
                    */
                } else {
                    UIImage *placeholderImage = [UIImage imageNamed:@"nowprinting.png"];
                    cell.bnr_image.image = placeholderImage;
                }

                
                if([[banner objectForKey:@"is_high"] intValue] == 1){
                    cell.obi_image.image = [UIImage imageNamed:@"high.png"];
                } else if([[banner objectForKey:@"is_free"] intValue] == 1){
                    cell.obi_image.image = [UIImage imageNamed:@"free.png"];
                } else if([[banner objectForKey:@"is_new"] intValue] == 1){
                    cell.obi_image.image = [UIImage imageNamed:@"new.png"];
                }

                cell.category_image1.image = nil;
                cell.category_image2.image = nil;
                cell.category_image3.image = nil;
                
                NSMutableArray *category_array = [[NSMutableArray alloc] init];
                if([[banner objectForKey:@"is_limit"] intValue] == 1){
                    [category_array addObject:@"is_limit"];
                }
                if([[banner objectForKey:@"is_up"] intValue] == 1){
                    [category_array addObject:@"is_up"];
                }
                if([[banner objectForKey:@"is_exclusive"] intValue] == 1){
                    [category_array addObject:@"is_exclusive"];
                }
                if([[banner objectForKey:@"is_revival"] intValue] == 1){
                    [category_array addObject:@"is_revival"];
                }
                int c = 1;
                for(NSString *category_key in category_array){
                    
                    if([category_key isEqualToString:@"is_limit"]){
                        switch (c) {
                            case 1:
                                cell.category_image1.image = [UIImage imageNamed:@"lable1.png"];
                                c++;
                                break;
                            case 2:
                                cell.category_image2.image = [UIImage imageNamed:@"lable1.png"];
                                c++;
                                break;
                            case 3:
                                cell.category_image3.image = [UIImage imageNamed:@"lable1.png"];
                                c++;
                                break;
                            default:
                                break;
                        }
                    }
                    if([category_key isEqualToString:@"is_up"]){
                        switch (c) {
                            case 1:
                                cell.category_image1.image = [UIImage imageNamed:@"lable4.png"];
                                c++;
                                break;
                            case 2:
                                cell.category_image2.image = [UIImage imageNamed:@"lable4.png"];
                                c++;
                                break;
                            case 3:
                                cell.category_image3.image = [UIImage imageNamed:@"lable4.png"];
                                c++;
                                break;
                            default:
                                break;
                        }
                    }
                    if([category_key isEqualToString:@"is_exclusive"]){
                        switch (c) {
                            case 1:
                                cell.category_image1.image = [UIImage imageNamed:@"lable3.png"];
                                c++;
                                break;
                            case 2:
                                cell.category_image2.image = [UIImage imageNamed:@"lable3.png"];
                                c++;
                                break;
                            case 3:
                                cell.category_image3.image = [UIImage imageNamed:@"lable3.png"];
                                c++;
                                break;
                            default:
                                break;
                        }
                    }
                    if([category_key isEqualToString:@"is_revival"]){
                        switch (c) {
                            case 1:
                                cell.category_image1.image = [UIImage imageNamed:@"lable2.png"];
                                c++;
                                break;
                            case 2:
                                cell.category_image2.image = [UIImage imageNamed:@"lable2.png"];
                                c++;
                                break;
                            case 3:
                                cell.category_image3.image = [UIImage imageNamed:@"lable2.png"];
                                c++;
                                break;
                            default:
                                break;
                        }
                    }
                    
                }
                
                break;
            }
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] init];
    backButton.title = @"戻る";
    self.navigationItem.backBarButtonItem = backButton;
    
    switch (indexPath.section) {
        case 0:
        {
            int banner_row = (int)indexPath.row;
            NSDictionary *banner = [recommendInfo objectAtIndex:banner_row];
            BannerDetailViewController *bannerDetailVC = [[BannerDetailViewController alloc] init];
            [bannerDetailVC setBannerDetail:banner];
            [bannerDetailVC setUserInfo:userInfo];
            [self.navigationController pushViewController:bannerDetailVC animated:YES];
            break;
        }
        case 1:
        {
            if(indexPath.row > 0){
                int banner_row = (int)indexPath.row - 1;
                //NSDictionary *banner = [bannerInfo objectAtIndex:banner_row];
                NSDictionary *banner = [viewBannerInfo objectAtIndex:banner_row];
                BannerDetailViewController *bannerDetailVC = [[BannerDetailViewController alloc] init];
                [bannerDetailVC setBannerDetail:banner];
                [bannerDetailVC setUserInfo:userInfo];
                [self.navigationController pushViewController:bannerDetailVC animated:YES];
            }
            break;
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSLog(@"exec heightForRowAtIndexPath");
    if(indexPath.section == 1 && indexPath.row == 0){
        return 95;
    }
    switch (indexPath.section) {
        case 0:
            return 100;
            break;
        default:
            return 80;
            break;
    }
    return 80;
}

-(void)segmentDidChange:(id)sender{
    /*
    _progress = [[MBProgressHUD alloc] initWithView:self.view];
    _progress.labelText = @"読み込み中";
    [self.view addSubview:_progress];
    [_progress show:YES];
    */
    if(sender != nil){
        switch ([sender tag]) {
            case 1:
                filteringStatus = 1;
                break;
            case 2:
                filteringStatus = 2;
                break;
            case 3:
                filteringStatus = 3;
            case 4:
                sortStatus = 1;
                break;
            case 5:
                sortStatus = 2;
                break;
            default:
                break;
        }
    }
    
    NSLog(@"didChangeSegment filterlingStatus %d",filteringStatus);
    if(filteringStatus == 0 || filteringStatus > 3 || filteringStatus < 0){
        filteringStatus = 1;
    }
    if (sortStatus == 0 || sortStatus > 2 || sortStatus < 0) {
        sortStatus = 1;
    }
    
    NSString *category = @"DL";
    NSString *sort = @"NEW";
    
    switch (filteringStatus) {
        case 1:
            category = @"DL";
            [filteringBtn1 setBackgroundImage:[UIImage imageNamed:@"button1-2.png"] forState:UIControlStateNormal];
            [filteringBtn2 setBackgroundImage:[UIImage imageNamed:@"button3.png"] forState:UIControlStateNormal];
            [filteringBtn3 setBackgroundImage:[UIImage imageNamed:@"button2.png"] forState:UIControlStateNormal];
            break;
        case 2:
            category = @"HIGH";
            [filteringBtn1 setBackgroundImage:[UIImage imageNamed:@"button1.png"] forState:UIControlStateNormal];
            [filteringBtn2 setBackgroundImage:[UIImage imageNamed:@"button3-3.png"] forState:UIControlStateNormal];
            [filteringBtn3 setBackgroundImage:[UIImage imageNamed:@"button2.png"] forState:UIControlStateNormal];
            break;
        case 3:
            category = @"OTHER";
            [filteringBtn1 setBackgroundImage:[UIImage imageNamed:@"button1.png"] forState:UIControlStateNormal];
            [filteringBtn2 setBackgroundImage:[UIImage imageNamed:@"button3.png"] forState:UIControlStateNormal];
            [filteringBtn3 setBackgroundImage:[UIImage imageNamed:@"button2-2.png"] forState:UIControlStateNormal];
            break;
        default:
            category = @"DL";
            [filteringBtn1 setBackgroundImage:[UIImage imageNamed:@"button1-2.png"] forState:UIControlStateNormal];
            [filteringBtn2 setBackgroundImage:[UIImage imageNamed:@"button3.png"] forState:UIControlStateNormal];
            [filteringBtn3 setBackgroundImage:[UIImage imageNamed:@"button2.png"] forState:UIControlStateNormal];
            break;
    }
    switch (sortStatus) {
        case 1:
            sort = @"NEW";
            [sortBtn1 setBackgroundImage:[UIImage imageNamed:@"Segment2-2.png"] forState:UIControlStateNormal];
            [sortBtn2 setBackgroundImage:[UIImage imageNamed:@"Segment1.png"] forState:UIControlStateNormal];
            break;
        case 2:
            sort = @"POINT";
            [sortBtn1 setBackgroundImage:[UIImage imageNamed:@"Segment2.png"] forState:UIControlStateNormal];
            [sortBtn2 setBackgroundImage:[UIImage imageNamed:@"Segment1-2.png"] forState:UIControlStateNormal];
            break;
        default:
            sort = @"NEW";
            [sortBtn1 setBackgroundImage:[UIImage imageNamed:@"Segment2-2.png"] forState:UIControlStateNormal];
            [sortBtn2 setBackgroundImage:[UIImage imageNamed:@"Segment1.png"] forState:UIControlStateNormal];
            break;
    }
    
    //apiUtil = [[AppApiUtil alloc] init];
    NSLog(@"didChangeSegment recommendInfo %@",recommendInfo);
    if(recommendInfo == nil){
        recommendInfo = [apiUtil getRecommended];
    }
    if(bannerInfo == nil){
        bannerInfo = [apiUtil getBanner:category sort:sort];
    }
    viewBannerInfo =[self bannerFilteringAndSort];
    //bannerInfo = nil;
    [self.tableView reloadData];
    
    //[_progress hide:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)popupNewPointView:(NSString *) point {
    newPointView = [[NewPointViewController alloc] init];
    [self.tabBarController.view addSubview:newPointView.view];
    NSLog(@"newpointview");
    newPointView.PointLabel.text = point;
    
    [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(hideNewPointView:) userInfo:nil repeats:NO];
    
    
}
- (void)hideNewPointView:(NSTimer *)timer {
    NSLog(@"hideNewPoint");
    [newPointView.view removeFromSuperview];
}

- (NSArray *) bannerFilteringAndSort{
    if(filteringStatus == 0 || filteringStatus > 3 || filteringStatus < 0){
        sortStatus = 1;
    }
    if (sortStatus == 0 || sortStatus > 2 || sortStatus < 0) {
        sortStatus = 1;
    }
    NSString *filtering;
    switch (filteringStatus) {
        case 1:
            filtering = @"DL";
            break;
        case 2:
            filtering = @"REG";
            break;
        case 3:
            filtering = @"OTHER";
            break;
    }
    NSMutableArray *pickup_banner = [NSMutableArray array];
    for (NSDictionary *banner in  bannerInfo) {
        if([[banner objectForKey:@"category"] isEqualToString:filtering]){
            [pickup_banner addObject:banner];
        }
    }
    
    if(sortStatus == 1){
        return pickup_banner;
    } else {
        NSSortDescriptor *sortDescNumber = [[NSSortDescriptor alloc] initWithKey:@"point" ascending:NO];
        NSArray *sortDescArray = [NSArray arrayWithObjects:sortDescNumber, nil];
        return [pickup_banner sortedArrayUsingDescriptors:sortDescArray];
    }
    return pickup_banner;
}

@end
