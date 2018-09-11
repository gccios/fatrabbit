//
//  FRMyInfoViewController.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/10.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRMyInfoViewController.h"
#import "FRUserMenuCell.h"
#import "FRUserMenuLogoCell.h"
#import <TZImagePickerController.h>
#import "FREditNameViewController.h"
#import "UserManager.h"

@interface FRMyInfoViewController () <UITableViewDelegate, UITableViewDataSource, TZImagePickerControllerDelegate, FREditNameViewControllerDelegate>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataSource;

@end

@implementation FRMyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"个人信息";
    [self createDataSource];
    [self createViews];
}

- (void)createDataSource
{
    [self.dataSource removeAllObjects];
    
    [self.dataSource addObject:[[FRUserMenuModel alloc] initWithType:FRUserMenuType_Logo]];
    [self.dataSource addObject:[[FRUserMenuModel alloc] initWithType:FRUserMenuType_NickName]];
    [self.dataSource addObject:[[FRUserMenuModel alloc] initWithType:FRUserMenuType_Mobile]];
}

- (void)createViews
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[FRUserMenuCell class] forCellReuseIdentifier:@"FRUserMenuCell"];
    [self.tableView registerClass:[FRUserMenuLogoCell class] forCellReuseIdentifier:@"FRUserMenuLogoCell"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.tableView.tableFooterView = [UIView new];
}

#pragma mark - TZImagePickerControllerDelegate
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos
{
    if (photos) {
        UIImage * logo = [photos firstObject];
        FRUserMenuModel * model = [self.dataSource firstObject];
        if (model.type == FRUserMenuType_Logo) {
            model.image = logo;
        }
        [self.tableView reloadData];
    }
}

#pragma mark - FREditNameViewControllerDelegate
- (void)FRUserNickNameDidUpdate:(NSString *)nickName
{
    [UserManager shareManager].nickname = nickName;
    [[UserManager shareManager] needUpdateLocalUserInfo];
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FRUserMenuModel * model = [self.dataSource objectAtIndex:indexPath.row];
    if (model.type == FRUserMenuType_Logo) {
        
        TZImagePickerController * picker = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
        picker.allowPickingOriginalPhoto = NO;
        picker.allowPickingVideo = NO;
        picker.allowTakeVideo = NO;
        picker.showSelectedIndex = NO;
        picker.allowCrop = NO;
        
        [self presentViewController:picker animated:YES completion:nil];
        
    }else if (model.type == FRUserMenuType_NickName) {
        
        FREditNameViewController * editName = [[FREditNameViewController alloc] init];
        editName.delegate = self;
        [self.navigationController pushViewController:editName animated:YES];
        
    }else if (model.type == FRUserMenuType_Mobile) {
        
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FRUserMenuModel * model = [self.dataSource objectAtIndex:indexPath.row];
    
    if (model.type == FRUserMenuType_Logo) {
        
        FRUserMenuLogoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FRUserMenuLogoCell" forIndexPath:indexPath];
        [cell configWithModel:model];
        
        return cell;
        
    }else {
        
        FRUserMenuCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FRUserMenuCell" forIndexPath:indexPath];
        [cell configWithModel:model];
        
        return cell;
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    FRUserMenuModel * model = [self.dataSource objectAtIndex:indexPath.row];
    if (model.type == FRUserMenuType_Logo) {
        
        return 85 * scale;
        
    }else {
        
        return 60 * scale;
        
    }
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
