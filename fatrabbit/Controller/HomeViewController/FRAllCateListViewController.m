//
//  FRAllCateListViewController.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/11.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRAllCateListViewController.h"
#import "FRManager.h"
#import "FRCreateViewTool.h"
#import <Masonry.h>
#import "FRAllCateListTableViewCell.h"

@interface FRAllCateListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView * titleView;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataSource;

@end

@implementation FRAllCateListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createTitleView];
    
    self.dataSource = [FRManager shareManager].cateList;
    [self createTableListView];
}

- (void)createTableListView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.rowHeight = 50;
    self.tableView.backgroundColor = UIColorFromRGB(0xffffff);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[FRAllCateListTableViewCell class] forCellReuseIdentifier:@"FRAllCateListTableViewCell"];
    [self.view insertSubview:self.tableView belowSubview:self.titleView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleView.mas_bottom);
        make.left.right.bottom.mas_equalTo(0);
    }];
    self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 70 * kMainBoundsWidth / 375.f, 0);
    self.tableView.tableFooterView = [UIView new];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FRAllCateListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FRAllCateListTableViewCell" forIndexPath:indexPath];
    
    FRCateModel * model = [self.dataSource objectAtIndex:indexPath.row];
    [cell configWithModel:model];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(FRAllCateListViewControllerDidChoose:)]) {
        FRCateModel * model = [self.dataSource objectAtIndex:indexPath.row];
        
        [self dismissViewControllerAnimated:NO completion:nil];
        
        [self.delegate FRAllCateListViewControllerDidChoose:model];
    }
}

- (void)createTitleView
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    self.titleView = [[UIView alloc] initWithFrame:CGRectZero];
    self.titleView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.titleView];
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(44 + kStatusBarHeight);
    }];
    
    self.titleView.layer.shadowColor = UIColorFromRGB(0x333333).CGColor;
    self.titleView.layer.shadowOpacity = .15f;
    self.titleView.layer.shadowRadius = 8;
    self.titleView.layer.shadowOffset = CGSizeMake(0, 4);
    
    UILabel * titleLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(17) textColor:UIColorFromRGB(0x333333) alignment:NSTextAlignmentCenter];
    titleLabel.text = @"全部分类";
    [self.titleView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kStatusBarHeight);
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(40);
    }];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.exclusiveTouch = YES;
    [button setImage:[UIImage imageNamed:@"cateClose"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(navBackButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor clearColor];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.bottom.mas_equalTo(-15 * scale);
        make.width.height.mas_equalTo(60 * scale);
    }];
}

- (void)navBackButtonClicked
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
