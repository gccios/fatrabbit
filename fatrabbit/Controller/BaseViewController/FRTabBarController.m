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
    
    NSMutableArray * vcArray = [[NSMutableArray alloc] init];
    
    FRHomePageViewController * home = [[FRHomePageViewController alloc] init];
    FRNavigationController * homeNav = [[FRNavigationController alloc] initWithRootViewController:home];
     UITabBarItem * homeItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemHistory tag:0];
    [homeNav setTabBarItem:homeItem];
    [vcArray addObject:homeNav];
    
    FRStorePageViewController * store = [[FRStorePageViewController alloc] init];
    FRNavigationController * storeNav = [[FRNavigationController alloc] initWithRootViewController:store];
    UITabBarItem * homeStore = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemHistory tag:1];
    [storeNav setTabBarItem:homeStore];
    [vcArray addObject:storeNav];
    
    FRMessagePageViewController * message = [[FRMessagePageViewController alloc] init];
    FRNavigationController * messageNav = [[FRNavigationController alloc] initWithRootViewController:message];
    UITabBarItem * messageItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemHistory tag:2];
    [messageNav setTabBarItem:messageItem];
    [vcArray addObject:messageNav];
    
    FRMyViewController * my = [[FRMyViewController alloc] init];
    FRNavigationController * myNav = [[FRNavigationController alloc] initWithRootViewController:my];
    UITabBarItem * myItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemHistory tag:3];
    [myNav setTabBarItem:myItem];
    [vcArray addObject:myNav];
    
    [self setViewControllers:vcArray];
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
