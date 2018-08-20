//
//  FRTabBarController.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/8/20.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRTabBarController.h"
#import "FRTabbar.h"

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
    
    for (NSInteger i = 0; i < 4; i++) {
        UIViewController * vc = [[UIViewController alloc] init];
        UINavigationController * na = [[UINavigationController alloc] initWithRootViewController:vc];
        [vcArray addObject:na];
        UITabBarItem * item = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemHistory tag:i];
        [na setTabBarItem:item];
    }
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
