//
//  FRNavigationController.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/8/20.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRNavigationController.h"
#import "UIImage+Additional.h"

@interface FRNavigationController ()

@end

@implementation FRNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //设置标题颜色和字体
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : UIColorFromRGB(0xFFFFFF), NSFontAttributeName : [UIFont boldSystemFontOfSize:17]}];
    
    UIImage *image = [UIImage imageWithColor:KThemeColor size:CGSizeMake(kMainBoundsWidth, kNaviBarHeight + kStatusBarHeight)];
    [[UINavigationBar appearanceWhenContainedIn:[UINavigationController class], nil] setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
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
