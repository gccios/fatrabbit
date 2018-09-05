//
//  FRAddressViewController.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/5.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRAddressViewController.h"
#import "FRUserAddressRequest.h"
#import "UserManager.h"
#import "FRAddressTableViewCell.h"
#import "FRAddNewAddressViewController.h"

@interface FRAddressViewController () <UITableViewDelegate, UITableViewDataSource, FRAddNewAddressViewControllerDelegate>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataSource;

@end

@implementation FRAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"地址管理";
    self.dataSource = [UserManager shareManager].addressList;
    if (self.dataSource.count == 0) {
        [self requestAddressList];
    }
    
    [self createViews];
}

- (void)requestAddressList
{
    FRUserAddressRequest * request = [[FRUserAddressRequest alloc] init];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        if (KIsDictionary(response)) {
            NSDictionary * data = [response objectForKey:@"data"];
            if (KIsArray(data)) {
                [UserManager shareManager].addressList = [FRAddressModel mj_objectArrayWithKeyValuesArray:data];
                self.dataSource = [UserManager shareManager].addressList;
                [self.tableView reloadData];
            }
        }
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
    }];
}

- (void)addAddressButtonDidClicked
{
    FRAddNewAddressViewController * addAddress = [[FRAddNewAddressViewController alloc] init];
    addAddress.delegate = self;
    [self.navigationController pushViewController:addAddress animated:YES];
}

#pragma mark - FRAddNewAddressViewControllerDelegate
- (void)FRAddressDidChange
{
    [self requestAddressList];
}

- (void)createViews
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.rowHeight = 80 * scale;
    [self.tableView registerClass:[FRAddressTableViewCell class] forCellReuseIdentifier:@"FRAddressTableViewCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 40 * scale, 0);
    
    UIButton * addAddressButton = [FRCreateViewTool createButtonWithFrame:CGRectZero font:kPingFangRegular(15 * scale) titleColor:UIColorFromRGB(0xffffff) title:@"新增收货地址"];
    addAddressButton.backgroundColor = KThemeColor;
    [self.view addSubview:addAddressButton];
    [addAddressButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(40 * scale);
    }];
    [addAddressButton addTarget:self action:@selector(addAddressButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FRAddressTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FRAddressTableViewCell" forIndexPath:indexPath];
    
    FRAddressModel * model = [self.dataSource objectAtIndex:indexPath.row];
    [cell configWithModel:model];
    
    __weak typeof(self) weakSelf = self;
    cell.addressEditHandle = ^{
        FRAddNewAddressViewController * address = [[FRAddNewAddressViewController alloc] initWithEditModel:model];
        address.delegate = weakSelf;
        [weakSelf.navigationController pushViewController:address animated:YES];
    };
    
    return cell;
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
