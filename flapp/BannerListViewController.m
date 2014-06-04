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

@interface BannerListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *charaImage;
@property (weak, nonatomic) IBOutlet UIView *pointStatusView;
@property (weak, nonatomic) IBOutlet UILabel *nextStageLabel;

@end

@implementation BannerListViewController{
    NSArray *bannerInfo;
    NSArray *recommendInfo;
    NSDictionary *userInfo;
    UISegmentedControl *segment1;
    UISegmentedControl *segment2;
    UILabel *gradeup_label;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"貯める" image:[UIImage imageNamed:@"money"] tag:1];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.navigationItem.title = @"ポイント忍者くん";
    //self.navigationController.navigationBar.backgroundColor = [UIColor orangeColor];
    //self.navigationController.navigationBar.barTintColor = [UIColor orangeColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:1.0 green:0.398 blue:0 alpha:1.0];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:1.0 green:0.398 blue:0 alpha:1.0];
    //self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:1.0 green:0.597 blue:0.199 alpha:1.0];
    //self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:1.0 green:0.597 blue:0.199 alpha:1.0];
    
    //self.charaImage.image = [UIImage imageNamed:@"funassi.png"];
    
    self.charaImage.image = [UIImage imageNamed:@"chara.png"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"BannerListViewCell" bundle:nil] forCellReuseIdentifier:@"BannerCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"RecommendedListViewCell" bundle:nil] forCellReuseIdentifier:@"RecommendedCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"BannerListCategoryViewCell" bundle:nil] forCellReuseIdentifier:@"CategoryCell"];

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
}
-(void)viewWillAppear:(BOOL)animated{
    _progress = [[MBProgressHUD alloc] initWithView:self.view];
    _progress.labelText = @"読み込み中";
    [self.view addSubview:_progress];
    [_progress show:YES];
     
    AppApiUtil *apiUtil = [[AppApiUtil alloc] init];
    recommendInfo = [apiUtil getRecommended];
    bannerInfo = [apiUtil getBanner];
    [self.tableView reloadData];
    
    userInfo = [apiUtil getUserInfo];
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
    self.tableView.backgroundColor = [UIColor orangeColor];
    
    if(gradeup_label == nil){
        NSMutableString *gradeup_str = [NSMutableString string];
        [gradeup_str appendString:@"あと"];
        [gradeup_str appendString:[NSString stringWithFormat:@"%d",[[userInfo objectForKey:@"grade_up_point"] intValue]]];
        [gradeup_str appendString:@"G獲得で来月"];
        [gradeup_str appendString:[userInfo objectForKey:@"next_grade"]];
        [gradeup_str appendString:@"確定!"];
        //gradeup_label = [[UILabel alloc] initWithFrame:CGRectMake(20, 4, 280, 30)];
        self.nextStageLabel.text = gradeup_str;
        self.nextStageLabel.font = [UIFont systemFontOfSize:15.0f];
        self.nextStageLabel.textAlignment = NSTextAlignmentCenter;
        self.nextStageLabel.backgroundColor = [UIColor whiteColor];
    }
    
    //新着ポイントをチェック
    NSDictionary *newPointResult = [apiUtil checkNewPoint];
    if([[newPointResult objectForKey:@"detail_code"] isEqualToString:@"00"]){
        //NEWPOINT表示
        NSLog(@"NewPoint: %d",[[newPointResult objectForKey:@"new_point"] intValue]);
    }
    
    //NSLog(@"bannerInfo: %lu",(unsigned long)[bannerInfo count]);
}
-(void)viewDidAppear:(BOOL)animated{
    [_progress hide:YES];
}
-(void)hudWasHidden:(MBProgressHUD *)hud{
    [_progress removeFromSuperview];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return recommendInfo.count;
            break;
        case 1:
            return bannerInfo.count+1;
        default:
            break;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

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
                [cell.contentView addSubview:segment1];
                [cell.contentView addSubview:segment2];
                break;
            }
            default:
            {
                int banner_row = (int)indexPath.row - 1;
                NSDictionary *banner = [bannerInfo objectAtIndex:banner_row];
                
                cell.backgroundColor = [UIColor clearColor];
                
                
                cell.title.text = [banner objectForKey:@"title"];
                cell.condition.text = [banner objectForKey:@"affiliate_condition"];
                cell.point.text = [NSString stringWithFormat:@"%@G",[banner objectForKey:@"point"]];
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

                break;
            }
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
                NSDictionary *banner = [bannerInfo objectAtIndex:banner_row];
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
    _progress = [[MBProgressHUD alloc] initWithView:self.view];
    _progress.labelText = @"読み込み中";
    [self.view addSubview:_progress];
    [_progress show:YES];
    
    NSString *category = @"DL";
    NSString *sort = @"NEW";
    switch (segment1.selectedSegmentIndex) {
        case 0:
            category = @"DL";
            break;
        case 1:
            category = @"HIGH";
            break;
        case 2:
            category = @"OTHER";
            break;
        default:
            category = @"DL";
            break;
    }
    switch (segment2.selectedSegmentIndex) {
        case 0:
            sort = @"NEW";
            break;
        case 1:
            sort = @"POINT";
            break;
        default:
            sort = @"NEW";
            break;
    }
    
    AppApiUtil *apiUtil = [[AppApiUtil alloc] init];
    bannerInfo = [apiUtil getBanner:category sort:sort];
    [self.tableView reloadData];
    
    [_progress hide:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
