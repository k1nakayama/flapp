//
//  BannerDetailViewController.m
//  flapp
//
//  Created by 中山桂一 on 2014/04/04.
//  Copyright (c) 2014年 Pocket Solution Inc. All rights reserved.
//

#import "BannerDetailViewController.h"
#import "AppApiUtil.h"

@interface BannerDetailViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation BannerDetailViewController{
    UILabel *copyLabel;
}

@synthesize bannerDetail;
@synthesize userInfo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSLog(@"bannerDetail: %@",bannerDetail);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.navigationController.navigationBar.backgroundColor = [UIColor orangeColor];
    self.navigationController.navigationBar.barTintColor = [UIColor orangeColor];
}

-(void)viewDidAppear:(BOOL)animated{
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
        self.tableView.backgroundColor = [UIColor colorWithRed:0.592 green:0.419 blue:0.184 alpha:1.0];
    }
    */
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //NSLog(@"count: %d",bannerInfo.count);
    return 6;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    switch (indexPath.row) {
        case 0:
        {
            UIImageView *titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
            NSURL *titleUrl = [NSURL URLWithString:[bannerDetail objectForKey:@"image_url"]];
            NSData *titleImgData = [NSData dataWithContentsOfURL:titleUrl];
            UIImage *titleImage = [UIImage imageWithData:titleImgData];
            titleImageView.image = titleImage;
            titleImageView.contentMode = UIViewContentModeScaleAspectFit;
            [cell.contentView addSubview:titleImageView];
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(68, 10, 235, 21)];
            titleLabel.text = [bannerDetail objectForKey:@"title"];
            titleLabel.font = [UIFont systemFontOfSize:16.0f];
            titleLabel.adjustsFontSizeToFitWidth = YES;
            titleLabel.textAlignment = NSTextAlignmentLeft;
            [cell.contentView addSubview:titleLabel];
            
            break;
        }
        case 1:
        {
            UILabel *costDescLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 72, 21)];
            costDescLabel.text = @"利用料金";
            costDescLabel.font = [UIFont systemFontOfSize:15.0f];
            costDescLabel.adjustsFontSizeToFitWidth = YES;
            costDescLabel.textAlignment = NSTextAlignmentLeft;
            [cell.contentView addSubview:costDescLabel];

            UILabel *costLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 11, 224, 21)];
            costLabel.text = [bannerDetail objectForKey:@"cost"];
            costLabel.font = [UIFont systemFontOfSize:15.0f];
            costLabel.adjustsFontSizeToFitWidth = YES;
            costLabel.textAlignment = NSTextAlignmentLeft;
            [cell.contentView addSubview:costLabel];

            UILabel *borderLabel = [[UILabel alloc] initWithFrame:CGRectMake(6, 25, 308, 21)];
            borderLabel.text = @"----------------------------------------------------------";
            borderLabel.font = [UIFont systemFontOfSize:13.0f];
            borderLabel.adjustsFontSizeToFitWidth = YES;
            borderLabel.textAlignment = NSTextAlignmentLeft;
            [cell.contentView addSubview:borderLabel];
            break;

        }
        case 2:
        {
            UILabel *returnDescLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 72, 21)];
            returnDescLabel.text = @"反映時間";
            returnDescLabel.font = [UIFont systemFontOfSize:15.0f];
            returnDescLabel.adjustsFontSizeToFitWidth = YES;
            returnDescLabel.textAlignment = NSTextAlignmentLeft;
            [cell.contentView addSubview:returnDescLabel];
            
            UILabel *returnLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 11, 224, 21)];
            returnLabel.text = [bannerDetail objectForKey:@"return_time"];
            returnLabel.font = [UIFont systemFontOfSize:15.0f];
            returnLabel.adjustsFontSizeToFitWidth = YES;
            returnLabel.textAlignment = NSTextAlignmentLeft;
            [cell.contentView addSubview:returnLabel];
            
            UILabel *borderLabel = [[UILabel alloc] initWithFrame:CGRectMake(6, 25, 308, 21)];
            borderLabel.text = @"----------------------------------------------------------";
            borderLabel.font = [UIFont systemFontOfSize:13.0f];
            borderLabel.adjustsFontSizeToFitWidth = YES;
            borderLabel.textAlignment = NSTextAlignmentLeft;
            [cell.contentView addSubview:borderLabel];
            break;
        }
        case 3:
        {
            UILabel *conditionDescLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 72, 21)];
            conditionDescLabel.text = @"成果条件";
            conditionDescLabel.font = [UIFont systemFontOfSize:15.0f];
            conditionDescLabel.adjustsFontSizeToFitWidth = YES;
            conditionDescLabel.textAlignment = NSTextAlignmentLeft;
            [cell.contentView addSubview:conditionDescLabel];
            
            UILabel *conditionLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 10, 224, 39)];
            NSLog(@"frame height: %f",conditionLabel.frame.size.height);
            conditionLabel.attributedText = [[NSAttributedString alloc] initWithString:[bannerDetail objectForKey:@"affiliate_condition"]];
            conditionLabel.font = [UIFont systemFontOfSize:14.0f];
            conditionLabel.numberOfLines = 0;
            
            CGRect frame2 = [conditionLabel.attributedText boundingRectWithSize:CGSizeMake(224, 500) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
            frame2.origin.x = 90;
            frame2.origin.y = 10;
            conditionLabel.frame = frame2;

            [cell.contentView addSubview:conditionLabel];
            break;
        }
        case 4:
        {
            /*
            copyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 39)];
            //NSLog(@"frame height: %f",conditionLabel.frame.size.height);
            copyLabel.attributedText = [[NSAttributedString alloc] initWithString:[bannerDetail objectForKey:@"description"]];
            copyLabel.font = [UIFont systemFontOfSize:14.0f];
            copyLabel.numberOfLines = 0;
            
            CGRect frame2 = [copyLabel.attributedText boundingRectWithSize:CGSizeMake(300, 500) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
            frame2.origin.x = 10;
            frame2.origin.y = 10;
            copyLabel.frame = frame2;
            */
            [cell.contentView addSubview:copyLabel];
            break;
        }
        case 5:
        {
            
            UIButton *actionButton = [[UIButton alloc] initWithFrame:CGRectMake(45, 15, 230, 30)];
            [actionButton setTitle:@"アプリをインストール" forState:UIControlStateNormal];
            [actionButton setBackgroundColor:[UIColor blueColor]];
            [actionButton addTarget:self action:@selector(didPushActionButton:) forControlEvents:UIControlEventTouchDown];
            [cell.contentView addSubview:actionButton];
            break;
        }
        default:
            break;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            return 74;
            break;
        case 1:
        case 2:
            return 38;
            break;
        case 3:
            return 62;
            break;
        case 4:
            copyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 39)];
            //NSLog(@"frame height: %f",conditionLabel.frame.size.height);
            copyLabel.attributedText = [[NSAttributedString alloc] initWithString:[bannerDetail objectForKey:@"description"]];
            copyLabel.font = [UIFont systemFontOfSize:14.0f];
            copyLabel.numberOfLines = 0;
            
            CGRect frame2 = [copyLabel.attributedText boundingRectWithSize:CGSizeMake(300, 500) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
            frame2.origin.x = 10;
            frame2.origin.y = 10;
            copyLabel.frame = frame2;
            return frame2.size.height+10;
            break;
        default:
            return 60;
            break;
    }
}

- (void)didPushActionButton:(UIButton *)button{
    NSLog(@"didPushActionButton");
    NSURL *url = [NSURL URLWithString:[bannerDetail objectForKey:@"action_url"]];
    [[UIApplication sharedApplication] openURL:url];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
