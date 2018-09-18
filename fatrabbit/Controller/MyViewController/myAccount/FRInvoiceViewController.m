//
//  FRInvoiceViewController.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/13.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRInvoiceViewController.h"
#import "FRMyInvoiceTableViewCell.h"
#import "FREditInvoiceViewController.h"
#import "FRUserInvoiceRequest.h"
#import <MJRefreshNormalHeader.h>
#import "UserManager.h"

@interface FRInvoiceViewController () <UITableViewDelegate, UITableViewDataSource, FREditInvoiceViewControllerDelegate>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataSource;

@end

@implementation FRInvoiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createViews];
    self.dataSource = [UserManager shareManager].invoiceList;
    if (self.dataSource.count == 0) {
        [self requestInvoiceList];
    }
}

- (void)requestInvoiceList
{
    FRUserInvoiceRequest * request = [[FRUserInvoiceRequest alloc] initWithGetList];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        if (KIsDictionary(response)) {
            NSArray * data = [response objectForKey:@"data"];
            if (KIsArray(data)) {
                [self.dataSource removeAllObjects];
                [UserManager shareManager].invoiceList = [FRMyInvoiceModel mj_objectArrayWithKeyValuesArray:data];
                [self.dataSource addObjectsFromArray:[UserManager shareManager].invoiceList];
                [self.tableView reloadData];
            }
        }
        
        [self.tableView.mj_header endRefreshing];
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [self.tableView.mj_header endRefreshing];
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
        [self.tableView.mj_header endRefreshing];
        
    }];
}

- (void)addButtonDidClicked
{
    FREditInvoiceViewController * edit = [[FREditInvoiceViewController alloc] init];
    edit.delegate = self;
    [self.navigationController pushViewController:edit animated:YES];
}

- (void)editWithModel:(FRMyInvoiceModel *)model
{
    FREditInvoiceViewController * edit = [[FREditInvoiceViewController alloc] initWithInvoiceModel:model];
    edit.delegate = self;
    [self.navigationController pushViewController:edit animated:YES];
}

- (void)deleteWithModel:(NSIndexPath *)indexPath
{
    FRMyInvoiceModel * model = [self.dataSource objectAtIndex:indexPath.row];
    [self.dataSource removeObject:model];
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    [self.tableView endUpdates];
    
    FRUserInvoiceRequest * request = [[FRUserInvoiceRequest alloc] initDeleteWithInvoiceID:model.cid];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
    }];
}

- (void)FRUserInvoiceDidChange
{
    [self requestInvoiceList];
}

- (void)createViews
{
    self.navigationItem.title = @"我的发票";
    
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = UIColorFromRGB(0xffffff);
    self.tableView.rowHeight = 135 * scale;
    [self.tableView registerClass:[FRMyInvoiceTableViewCell class] forCellReuseIdentifier:@"FRMyInvoiceTableViewCell"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(0);
    }];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestInvoiceList)];
    
    UIButton * addButton = [FRCreateViewTool createButtonWithFrame:CGRectZero font:kPingFangRegular(12 * scale) titleColor:UIColorFromRGB(0xFFFFFF) title:@"添加"];
    addButton.frame = CGRectMake(0, 0, 40 * scale, 30 * scale);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:addButton];
    [addButton addTarget:self action:@selector(addButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FRMyInvoiceTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FRMyInvoiceTableViewCell" forIndexPath:indexPath];
    
    FRMyInvoiceModel * model = [self.dataSource objectAtIndex:indexPath.row];
    [cell configWithInvoiceModel:model];
    
    __weak typeof(self) weakSelf = self;
    cell.invoiceEditHandle = ^{
        [weakSelf editWithModel:model];
    };
    
    cell.invoiceDeleteHandle = ^{
        [weakSelf deleteWithModel:indexPath];
    };
    
    return cell;
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
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
