//
//  FRTabBarController.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/8/20.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRTabBarController.h"
#import "FRTabbar.h"
#import "FRNavigationController.h"
#import "FRHomePageViewController.h"
#import "FRStorePageViewController.h"
#import "FRMessagePageViewController.h"
#import "FRMyViewController.h"

@interface FRTabBarController ()

@end

@implementation FRTabBarController

- (instancetype)init
{
    if (self = [super init]) {
        [self createFRTabBarController];
    }
    return self;
}

- (void)createFRTabBarController
{
    [self setValue:[[FRTabbar alloc] init] forKey:@"tabBar"];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : KThemeColor, NSFontAttributeName: kPingFangRegular(9)} forState:UIControlStateSelected];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : UIColorFromRGB(0x333333), NSFontAttributeName: kPingFangRegular(9)} forState:UIControlStateNormal];
    
    NSMutableArray * vcArray = [[NSMutableArray alloc] init];
    
    FRHomePageViewController * home = [[FRHomePageViewController alloc] init];
    FRNavigationController * homeNav = [[FRNavigationController alloc] initWithRootViewController:home];
    UITabBarItem * homeItem = [self tabBarItemWithImageName:@"home" selectName:@"homeSelect" title:@"首页"];
    [homeNav setTabBarItem:homeItem];
    [vcArray addObject:homeNav];
    
    FRStorePageViewController * store = [[FRStorePageViewController alloc] init];
    FRNavigationController * storeNav = [[FRNavigationController alloc] initWithRootViewController:store];
    UITabBarItem * homeStore = [self tabBarItemWithImageName:@"store" selectName:@"storeSelect" title:@"商城"];
    [storeNav setTabBarItem:homeStore];
    [vcArray addObject:storeNav];
    
    FRMessagePageViewController * message = [[FRMessagePageViewController alloc] init];
    FRNavigationController * messageNav = [[FRNavigationController alloc] initWithRootViewController:message];
    UITabBarItem * messageItem = [self tabBarItemWithImageName:@"message" selectName:@"messageSelect" title:@"消息"];
    [messageNav setTabBarItem:messageItem];
    [vcArray addObject:messageNav];
    
    FRMyViewController * my = [[FRMyViewController alloc] init];
    FRNavigationController * myNav = [[FRNavigationController alloc] initWithRootViewController:my];
    UITabBarItem * myItem = [self tabBarItemWithImageName:@"homeMy" selectName:@"homeMy" title:@"我的"];
    [myNav setTabBarItem:myItem];
    [vcArray addObject:myNav];
    
    [self setViewControllers:vcArray];
}

- (UITabBarItem *)tabBarItemWithImageName:(NSString *)name selectName:(NSString *)selectName title:(NSString *)title
{
    UIImage * image = [[UIImage imageNamed:name] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIImage * selectImage = [[UIImage imageNamed:selectName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UITabBarItem * item = [[UITabBarItem alloc] initWithTitle:title image:image selectedImage:selectImage];
    if (KIsiPhoneX) {
        item.titlePositionAdjustment = UIOffsetMake(0, 2);
    }else{
        item.titlePositionAdjustment = UIOffsetMake(0, -2);
    }
    
    return item;
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

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
