//
//  FRStoreSearchViewController.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/8/30.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRStoreSearchViewController.h"
#import "FRCreateViewTool.h"
#import <Masonry.h>
#import "FRNavAutoView.h"
#import <IQKeyboardManager.h>
#import "FRStoreListViewController.h"
#import "FRStoreSearchRequest.h"

@interface FRStoreSearchViewController () <UITextFieldDelegate>

@property (nonatomic, strong) NSArray * titleArray;
@property (nonatomic, strong) NSArray * vcArray;
@property (nonatomic, strong) FRCateModel * cateModel;

@property (nonatomic, strong) UITextField * searchTextField;

@end

@implementation FRStoreSearchViewController

- (instancetype)initWithCateModel:(FRCateModel *)model
{
    if (self = [super init]) {
        self.titleArray = @[@"全部商品", @"销量", @"价格"];
        self.vcArray = @[[[FRStoreListViewController alloc] init],
                         [[FRStoreListViewController alloc] init],
                         [[FRStoreListViewController alloc] init]];
        self.cateModel = model;
        [self configSelf];
    }
    return self;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.titleArray = @[@"全部商品", @"销量", @"价格"];
        self.vcArray = @[[[FRStoreListViewController alloc] init],
                         [[FRStoreListViewController alloc] init],
                         [[FRStoreListViewController alloc] init]];
        [self configSelf];
    }
    return self;
}

- (void)configSelf
{
    self.navigationItem.title = @"商品订单";
    self.hidesBottomBarWhenPushed = YES;
    
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
    self.menuItemWidth = kMainBoundsWidth / 3.f;
    self.progressViewWidths = @[@(kMainBoundsWidth / 4.f),@(kMainBoundsWidth / 8.f),@(kMainBoundsWidth / 8.f)];
    self.pageAnimatable = YES;
    
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
    return self.titleArray.count;
}

- (NSString *)menuView:(WMMenuView *)menu titleAtIndex:(NSInteger)index
{
    return [self.titleArray objectAtIndex:index];
}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController
{
    return self.vcArray.count;
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index
{
    return [self.vcArray objectAtIndex:index];
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView
{
    return CGRectMake(0, 0, kMainBoundsWidth, 40);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView
{
    return CGRectMake(0, 40, kMainBoundsWidth, kMainBoundsHeight - kNaviBarHeight - kStatusBarHeight - 40);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createViews];
    
    if (self.cateModel) {
        self.searchTextField.text = self.cateModel.name;
        [self searchRequest];
    }
}

- (void)searchRequest
{
    FRStoreSearchRequest * request = [[FRStoreSearchRequest alloc] init];
    if (self.cateModel) {
        [request configWithKeyWord:self.cateModel.name];
    }
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
    }];
}

- (void)createViews
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    FRNavAutoView * navView = [[FRNavAutoView alloc] initWithFrame:CGRectMake(70 * scale, 0, kMainBoundsWidth - 90 * scale, kNaviBarHeight)];
    self.navigationItem.titleView = navView;
    
    self.searchTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    self.searchTextField.returnKeyType = UIReturnKeySearch;
    self.searchTextField.delegate = self;
    self.searchTextField.font = kPingFangRegular(14 * scale);
    self.searchTextField.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.4f];
    [navView addSubview:self.searchTextField];
    [self.searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(30 * scale);
    }];
    
    self.searchTextField.clearButtonMode = UITextFieldViewModeAlways;
    
    UIView * leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10 * scale, 30 * scale)];
    self.searchTextField.leftView = leftView;
    self.searchTextField.leftViewMode = UITextFieldViewModeAlways;
    
    [FRCreateViewTool cornerView:self.searchTextField radius:15 * scale];
    
    self.searchTextField.placeholder = @"搜索企业/服务/案例/分类等，专业团队";
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text.length) {
        [self keyBoardDidEndEditing];
    }
    
    return YES;
}

- (void)keyBoardDidEndEditing
{
    if (self.searchTextField.isFirstResponder) {
        [self.searchTextField resignFirstResponder];
    }
}

- (void)navBackButtonClicked:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //开启iOS7的滑动返回效果
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //代理置空，否则会闪退
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
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
