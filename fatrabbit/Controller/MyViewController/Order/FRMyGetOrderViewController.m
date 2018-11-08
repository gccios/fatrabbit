//
//  FRMyGetOrderViewController.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/28.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRMyGetOrderViewController.h"
#import "FRGetServiceOrderViewController.h"

@interface FRMyGetOrderViewController ()

@property (nonatomic, strong) NSArray * serviceTitleArray;
@property (nonatomic, strong) NSArray * serviceTypeArray;

@end

@implementation FRMyGetOrderViewController

- (instancetype)init
{
    
    if (self = [super init]) {
        self.navigationItem.title = @"我接到的订单";
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
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index
{
    NSString * title = [self.serviceTitleArray objectAtIndex:index];
    return title;
}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController
{
    return self.serviceTitleArray.count;
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index
{
    NSInteger type = [[self.serviceTypeArray objectAtIndex:index] integerValue];
    return [[FRGetServiceOrderViewController alloc] initWithType:type];
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
