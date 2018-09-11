//
//  FRCatePageViewController.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/11.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRCatePageViewController.h"
#import "FRNavAutoView.h"
#import "FRNavAutoButton.h"
#import "FRCatePageDetailViewController.h"
#import "FRAllCateListViewController.h"

@interface FRCatePageViewController () <FRAllCateListViewControllerDelegate>

@property (nonatomic, strong) FRCateModel * model;
@property (nonatomic, strong) UILabel * titleLabel;

@end

@implementation FRCatePageViewController

- (instancetype)initWithModel:(FRCateModel *)model
{
    if (self = [super init]) {
        self.hidesBottomBarWhenPushed = YES;
        self.model = model;
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
//    self.menuItemWidth = kMainBoundsWidth / 6.f;
//    self.progressViewWidths = @[@(kMainBoundsWidth / 12.f),@(kMainBoundsWidth / 8.f),@(kMainBoundsWidth / 8.f),@(kMainBoundsWidth / 8.f),@(kMainBoundsWidth / 8.f),@(kMainBoundsWidth / 8.f)];
    self.pageAnimatable = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createViews];
}

- (void)cateButtonDidClicked
{
    FRAllCateListViewController * allCate = [[FRAllCateListViewController alloc] init];
    allCate.delegate = self;
    [self presentViewController:allCate animated:YES completion:nil];
}

#pragma mark - FRAllCateListViewControllerDelegate
- (void)FRAllCateListViewControllerDidChoose:(FRCateModel *)model
{
    [self setSelectIndex:0];
    self.model = model;
    [self reloadData];
}

- (void)createViews
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    self.view.backgroundColor = UIColorFromRGB(0xf5f5f5);
    
    FRNavAutoButton * cateButton = [FRNavAutoButton buttonWithType:UIButtonTypeCustom];
    cateButton.frame = CGRectMake(0, 0, 110 * scale, 35 * scale);
    [cateButton addTarget:self action:@selector(cateButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    
    self.titleLabel = [FRCreateViewTool createLabelWithFrame:CGRectMake(0, 0, 80 * scale, 35 * scale) font:kPingFangRegular(16 * scale) textColor:UIColorFromRGB(0xffffff) alignment:NSTextAlignmentCenter];
    self.titleLabel.text = self.model.name;
    [cateButton addSubview:self.titleLabel];
    
    UIImageView * moreDownImageView = [FRCreateViewTool createImageViewWithFrame:CGRectMake(90 * scale, 15 * scale, 10 * scale, 5 * scale) contentModel:UIViewContentModeScaleAspectFill image:[UIImage imageNamed:@"moreDown"]];
    [cateButton addSubview:moreDownImageView];
    
    self.navigationItem.titleView = cateButton;
    
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

- (NSInteger)numbersOfTitlesInMenuView:(WMMenuView *)menu
{
    return self.model.child.count;
}

- (NSString *)menuView:(WMMenuView *)menu titleAtIndex:(NSInteger)index
{
    FRCateModel * model = [self.model.child objectAtIndex:index];
    return model.name;
}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController
{
    return self.model.child.count;
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index
{
    return [[FRCatePageDetailViewController alloc] init];
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
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
