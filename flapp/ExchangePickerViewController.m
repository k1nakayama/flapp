//
//  ExchangePickerViewController.m
//  flapp
//
//  Created by 中山桂一 on 2014/04/02.
//  Copyright (c) 2014年 Pocket Solution Inc. All rights reserved.
//

#import "ExchangePickerViewController.h"

@interface ExchangePickerViewController ()

@end

@implementation ExchangePickerViewController

@synthesize selectFieldTag;
@synthesize selectedValue;

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
    self.picker.delegate = self;
    self.picker.dataSource = self;

    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, -44, 320, 44)];
    toolBar.barStyle = UIBarStyleDefault;
    [toolBar sizeToFit];
    
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithTitle:@"完了" style:UIBarButtonItemStyleDone target:self action:@selector(closePickerView:)];
    
    NSArray *items = [NSArray arrayWithObjects:spacer,done, nil];
    [toolBar setItems:items animated:YES];
    [self.picker addSubview:toolBar];
    
    [self.picker selectRow:selectedValue inComponent:0 animated:NO];
    
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    [self.delegate applySelectedString:[NSString stringWithFormat:@"%ld",(long)row] selectFieldTag:self.selectFieldTag];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 10;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [NSString stringWithFormat:@"%ld",(long)row];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closePickerView:(id)sender {
    [self.delegate closePickerView:self];
}

@end
