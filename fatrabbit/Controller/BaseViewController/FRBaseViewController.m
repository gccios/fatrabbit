//
//  FRBaseViewController.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/8/19.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRBaseViewController.h"

@interface FRBaseViewController ()

@end

@implementation FRBaseViewController

- (instancetype)init
{
    if (self = [super init]) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createVCForFBViewController];
}

- (void)createVCForFBViewController
{
    
}

- (void)createViews
{
    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
