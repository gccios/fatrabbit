//
//  FROrderPageViewController.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/8/27.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FROrderPageViewController.h"
#import "FROrderViewController.h"
#import "FRMyServiceOrderViewController.h"

@interface FROrderPageViewController ()

@property (nonatomic, strong) NSArray * storeTitleArray;
@property (nonatomic, strong) NSArray * storeTypeArray;
@property (nonatomic, strong) NSArray * serviceTitleArray;
@property (nonatomic, strong) NSArray * serviceTypeArray;

@property (nonatomic, assign) NSInteger type;//1为商品订单 2为服务订单

@property (nonatomic, strong) UIButton * rightButton;

@end

@implementation FROrderPageViewController

- (instancetype)init
{
    
    if (self = [super init]) {
        self.type = 1;
        self.navigationItem.title = @"商品订单";
        self.storeTitleArray = @[@"全部", @"待付款", @"待收货", @"待评价", @"已完成", @"已取消"];
        self.storeTypeArray = @[@(0), @(1), @(2), @(3), @(4), @(5)];
        self.serviceTitleArray = @[@"全部", @"待付款", @"待评价", @"已完成", @"已取消"];
        self.serviceTypeArray = @[@(0), @(1), @(3), @(4), @(5)];
        self.hidesBottomBarWhenPushed = YES;
        [self configSelf];
    }
    return self;
}

- (void)configSelf
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    self.titleSizeNormal = 13.f * scale;
    self.titleSizeSelected = 15.f * scale;
    self.titleColorNormal = UIColorFromRGB(0x333333);
    self.titleColorSelected = KThemeColor;
    self.progressColor = KThemeColor;
    self.progressHeight = 1.5f;
    self.menuViewStyle = WMMenuViewStyleLine;
    self.menuView.scrollView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    self.progressViewBottomSpace = 1;
    self.preloadPolicy = WMPageControllerPreloadPolicyNeighbour;
    self.menuItemWidth = kMainBoundsWidth / 6.f;
    self.progressViewWidths = @[@(kMainBoundsWidth / 12.f),@(kMainBoundsWidth / 8.f),@(kMainBoundsWidth / 8.f),@(kMainBoundsWidth / 8.f),@(kMainBoundsWidth / 8.f),@(kMainBoundsWidth / 8.f)];
    self.pageAnimatable = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createViews];
}

- (void)createViews
{
    self.view.backgroundColor = UIColorFromRGB(0xf5f5f5);
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.exclusiveTouch = YES;
    [button setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 40, 44);
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, -25, 0, 0)];
    [button addTarget:self action:@selector(navBackButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor clearColor];
    UIBarButtonItem* backItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = backItem;
    
    self.rightButton = [FRCreateViewTool createButtonWithFrame:CGRectZero font:kPingFangRegular(14) titleColor:UIColorFromRGB(0xFFFFFF) title:@"服务订单"];
    self.rightButton.exclusiveTouch = YES;
    [self.rightButton setFrame:CGRectMake(0, 0, 60, 30)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
    [self.rightButton addTarget:self action:@selector(rightButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
}

- (void)rightButtonDidClicked
{
    if (self.type == 1) {
        [self.rightButton setTitle:@"商品订单" forState:UIControlStateNormal];
        self.navigationItem.title = @"服务订单";
        self.type = 2;
        [self reloadData];
    }else if (self.type == 2) {
        [self.rightButton setTitle:@"服务订单" forState:UIControlStateNormal];
        self.navigationItem.title = @"商品订单";
        self.type = 1;
        [self reloadData];
    }
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index
{
    if (self.type == 1) {
        NSString * title = [self.storeTitleArray objectAtIndex:index];
        return title;
    }else{
        NSString * title = [self.serviceTitleArray objectAtIndex:index];
        return title;
    }
}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController
{
    if (self.type == 1) {
        return self.storeTitleArray.count;
    }else{
        return self.serviceTitleArray.count;
    }
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index
{
    if (self.type == 1) {
        NSInteger type = [[self.storeTypeArray objectAtIndex:index] integerValue];
        return [[FROrderViewController alloc] initWithType:type];
    }else{
        NSInteger type = [[self.serviceTypeArray objectAtIndex:index] integerValue];
        return [[FRMyServiceOrderViewController alloc] initWithType:type];
    }
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView
{
    return CGRectMake(0, 0, kMainBoundsWidth, 40);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView
{
    return CGRectMake(0, 40, kMainBoundsWidth, kMainBoundsHeight - kNaviBarHeight - kStatusBarHeight - 40);
}

- (void)navBackButtonClicked:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //代理置空，否则会闪退
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //开启iOS7的滑动返回效果
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    }
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
