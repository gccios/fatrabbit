//
//  FRCateListViewController.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/3.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRCateListViewController.h"
#import "FRCreateViewTool.h"
#import <Masonry.h>
#import "FRCateListCell.h"
#import "FRCateChildCell.h"

@interface FRCateListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) FRCateListType type;

@property (nonatomic, strong) UIView * titleView;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UITableView * childTableView;

@property (nonatomic, strong) NSMutableArray * dataSource;
@property (nonatomic, strong) NSArray * childSource;
@property (nonatomic, assign) BOOL isShowChild;

@end

@implementation FRCateListViewController

- (instancetype)initWithType:(FRCateListType)type
{
    if (self = [super init]) {
        self.type = type;
    }
    return self;
}

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
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 50;
    self.tableView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[FRCateListCell class] forCellReuseIdentifier:@"FRCateListCell"];
    [self.view insertSubview:self.tableView belowSubview:self.titleView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleView.mas_bottom);
        make.left.bottom.mas_equalTo(0);
        make.width.mas_equalTo(kMainBoundsWidth / 3.f);
    }];
    self.tableView.tableFooterView = [UIView new];
    
    if (self.dataSource.count > 0) {
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
        FRCateModel * model = [self.dataSource objectAtIndex:0];
        self.childSource = model.child;
    }
    
    self.childTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    //    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.childTableView.rowHeight = 50;
    self.childTableView.backgroundColor = [UIColor whiteColor];
    self.childTableView.delegate = self;
    self.childTableView.dataSource = self;
    [self.childTableView registerClass:[FRCateChildCell class] forCellReuseIdentifier:@"FRCateChildCell"];
    [self.view insertSubview:self.childTableView belowSubview:self.titleView];
    [self.childTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleView.mas_bottom);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(kMainBoundsWidth / 3.f * 2);
//        make.right.mas_equalTo(kMainBoundsWidth / 3.f * 2);
        make.right.mas_equalTo(0);
    }];
    self.childTableView.tableFooterView = [UIView new];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        return self.dataSource.count;
    }
    return self.childSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView) {
        FRCateListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FRCateListCell" forIndexPath:indexPath];
        
        FRCateModel * model = [self.dataSource objectAtIndex:indexPath.row];
        [cell configWithModel:model];
        
        return cell;
    }else{
        FRCateChildCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FRCateChildCell" forIndexPath:indexPath];
        
        FRCateModel * model = [self.childSource objectAtIndex:indexPath.row];
        [cell configWithModel:model];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView) {
        FRCateModel * model = [self.dataSource objectAtIndex:indexPath.row];
        self.childSource = model.child;
        [self.childTableView reloadData];
        if (!self.isShowChild) {
            
//            [UIView animateWithDuration:.3f animations:^{
//                [self.childTableView mas_updateConstraints:^(MASConstraintMaker *make) {
//                    make.right.mas_equalTo(0);
//                }];
//                [self.view layoutIfNeeded];
//            }];
            self.isShowChild = YES;
        }
    }else{
        if (self.delegate && [self.delegate respondsToSelector:@selector(FRcateListViewCongtrollerDidChoose:type:)]) {
            FRCateModel * model = [self.childSource objectAtIndex:indexPath.row];
            
            if (self.type == FRCateListType_Publish) {
                [self dismissViewControllerAnimated:NO completion:nil];
            }else{
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            
            [self.delegate FRcateListViewCongtrollerDidChoose:model type:self.type];
        }
    }
}

- (void)createTitleView
{
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
    titleLabel.text = @"请选择需求类型";
    [self.titleView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kStatusBarHeight);
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(40);
    }];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.exclusiveTouch = YES;
    [button setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    button.frame = CGRectMake(20, 20, 40, 40);
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, -25, 0, 0)];
    [button addTarget:self action:@selector(navBackButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor clearColor];
    [self.titleView addSubview:button];
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
