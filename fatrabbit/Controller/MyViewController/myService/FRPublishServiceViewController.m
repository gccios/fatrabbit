//
//  FRPublishServiceViewController.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/12.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRPublishServiceViewController.h"
#import "RDTextView.h"
#import "FRImageCollectionViewCell.h"
#import "MBProgressHUD+FRHUD.h"
#import "LookImageViewController.h"
#import "FRCateListViewController.h"
#import <TZImagePickerController.h>
#import "FRUploadManager.h"
#import "FRServiceRequest.h"

@interface FRPublishServiceViewController () <UICollectionViewDelegate, UICollectionViewDataSource, TZImagePickerControllerDelegate, FRCateListViewControllerDelegate>

@property (nonatomic, strong) FRMySeriviceModel * seriviceModel;
@property (nonatomic, strong) FRCateModel * model;

@property (nonatomic, strong) UITextField * serviceTitleField;
@property (nonatomic, strong) UITextField * servicePriceField;

@property (nonatomic, strong) RDTextView * textView;

@property (nonatomic, strong) UIView * contentView;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UILabel * cateNameLabel;

@property (nonatomic, strong) UICollectionView * imageCollectionView;
@property (nonatomic, strong) NSMutableArray * imageSource;
@property (nonatomic, assign) NSInteger maxCount;

@end

@implementation FRPublishServiceViewController

- (instancetype)initEditWithServiceModel:(FRMySeriviceModel *)seriviceModel imageSource:(NSArray *)imageSource cateModel:(FRCateModel *)model
{
    if (self = [super init]) {
        self.model = model;
        [self.imageSource addObjectsFromArray:imageSource];
        self.seriviceModel = seriviceModel;
    }
    return self;
}

- (instancetype)initWithFRCateModel:(FRCateModel *)model
{
    if (self = [super init]) {
        self.model = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.maxCount = 7;
    self.navigationItem.title = @"发布服务";
    [self createViews];
    [self createTablerHeaderView];
    [self createTablerfooterView];
}

- (void)handleButtonDidClicked
{
    NSString * title = self.serviceTitleField.text;
    if (isEmptyString(title)) {
        [MBProgressHUD showTextHUDWithText:@"请输入标题"];
        return;
    }
    NSString * price = self.servicePriceField.text;
    if (isEmptyString(price)) {
        [MBProgressHUD showTextHUDWithText:@"请输入价格"];
        return;
    }
    NSString * remark = self.textView.text;
    if (isEmptyString(remark)) {
        [MBProgressHUD showTextHUDWithText:@"请输入相关描述信息"];
        return;
    }
    
    double priceFloat = [price doubleValue];
    if (self.imageSource.count > 0) {
        
        MBProgressHUD * hud = [MBProgressHUD showLoadingHUDWithText:@"正在上传图片" inView:self.view];
        NSMutableArray * imageList = [[NSMutableArray alloc] init];
        __block NSInteger count = 0;
        hud.label.text = [NSString stringWithFormat:@"正在上传图片%ld/%ld", count+1, self.imageSource.count];
        [[FRUploadManager shareManager] uploadImageArray:self.imageSource progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
            
        } success:^(NSString *path, NSInteger index) {
            [imageList addObject:path];
            count++;
            if (count == self.imageSource.count) {
                [hud hideAnimated:NO];
                [self publishSeriviceWithPrice:priceFloat title:title remark:remark images:imageList];
            }else{
                hud.label.text = [NSString stringWithFormat:@"正在上传图片%ld/%ld", count+1, self.imageSource.count];
            }
            NSLog(@"%@", [NSString stringWithFormat:@"%ld张地址：%@", index, path]);
        } failure:^(NSError *error, NSInteger index) {
            count++;
            if (count == self.imageSource.count) {
                [hud hideAnimated:NO];
                [self publishSeriviceWithPrice:priceFloat title:title remark:remark images:imageList];
            }else{
                hud.label.text = [NSString stringWithFormat:@"正在上传图片%ld/%ld", count+1, self.imageSource.count];
            }
            NSLog(@"%@\n%@", [NSString stringWithFormat:@"%ld张上传失败", index], error);
        }];
    }else{
        [self publishSeriviceWithPrice:priceFloat title:title remark:remark images:nil];
    }
}

- (void)publishSeriviceWithPrice:(double)priceFloat title:(NSString *)title remark:(NSString *)remark images:(NSArray *)image
{
    MBProgressHUD * hud = [MBProgressHUD showLoadingHUDWithText:@"正在发布服务" inView:self.view];
    FRServiceRequest * request =  [[FRServiceRequest alloc] initPublishWithPrice:priceFloat title:title remark:remark img:image cateID:self.model.cid];
    
    if (self.seriviceModel) {
        [request configEditWithID:self.seriviceModel.cid];
    }
    
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [hud hideAnimated:YES];
        [MBProgressHUD showTextHUDWithText:@"发布成功"];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(FRPublishServiceDidUpdate)]) {
            [self.delegate FRPublishServiceDidUpdate];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [hud hideAnimated:YES];
        NSString * msg = [response objectForKey:@"msg"];
        if (!isEmptyString(msg)) {
            [MBProgressHUD showTextHUDWithText:msg];
        }
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
        [hud hideAnimated:YES];
        [MBProgressHUD showTextHUDWithText:@"发布失败"];
        
    }];
}

- (void)chooseCateType
{
    //    FRCateListViewController * list = [[FRCateListViewController alloc] initWithType:FRCateListType_Choose];
    //    list.delegate = self;
    //    [self presentViewController:list animated:YES completion:nil];
}

#pragma mark - FRCateListViewControllerDelegate
- (void)FRcateListViewCongtrollerDidChoose:(FRCateModel *)model type:(FRCateListType)type
{
    self.model = model;
    self.cateNameLabel.text = model.name;
}

- (void)createViews
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.backgroundColor = self.view.backgroundColor;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 50 * scale, 0);
    
    UIButton * handleButton = [FRCreateViewTool createButtonWithFrame:CGRectZero font:kPingFangRegular(15 * scale) titleColor:UIColorFromRGB(0xffffff) title:@"发布服务"];
    [handleButton setBackgroundColor:UIColorFromRGB(0xf8bf44)];
    [self.view addSubview:handleButton];
    [handleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(45 * scale);
    }];
    [handleButton addTarget:self action:@selector(handleButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
}

- (void)createTablerHeaderView
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, 380 * scale)];
    self.contentView.backgroundColor = UIColorFromRGB(0xffffff);
    [self.view addSubview:self.contentView];
    
    UILabel * titleLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(15 * scale) textColor:UIColorFromRGB(0x999999) alignment:NSTextAlignmentLeft];
    titleLabel.text = @"服务标题";
    [self.contentView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(30 * scale);
        make.left.mas_equalTo(15 * scale);
        make.height.mas_equalTo(20 * scale);
    }];
    
    self.serviceTitleField = [[UITextField alloc] initWithFrame:CGRectZero];
    self.serviceTitleField.borderStyle = UITextBorderStyleRoundedRect;
    [self.contentView addSubview:self.serviceTitleField];
    [self.serviceTitleField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(titleLabel);
        make.left.mas_equalTo(titleLabel.mas_right).offset(15 * scale);
        make.height.mas_equalTo(25 * scale);
        make.width.mas_equalTo(175 * scale);
    }];
    if (self.seriviceModel) {
        self.serviceTitleField.text = self.seriviceModel.title;
    }
    
    UILabel * priceLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(15 * scale) textColor:UIColorFromRGB(0x999999) alignment:NSTextAlignmentLeft];
    priceLabel.text = @"服务定价";
    [self.contentView addSubview:priceLabel];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(20 * scale);
        make.left.mas_equalTo(15 * scale);
        make.height.mas_equalTo(20 * scale);
    }];
    
    self.servicePriceField = [[UITextField alloc] initWithFrame:CGRectZero];
    self.servicePriceField.borderStyle = UITextBorderStyleRoundedRect;
    self.servicePriceField.keyboardType = UIKeyboardTypeDecimalPad;
    [self.contentView addSubview:self.servicePriceField];
    [self.servicePriceField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(priceLabel);
        make.left.mas_equalTo(priceLabel.mas_right).offset(15 * scale);
        make.height.mas_equalTo(25 * scale);
        make.width.mas_equalTo(175 * scale);
    }];
    if (self.seriviceModel) {
        self.servicePriceField.text = [NSString stringWithFormat:@"%.2lf", self.seriviceModel.amount];
    }
    
    UILabel * tipLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(13 * scale) textColor:UIColorFromRGB(0x666666) alignment:NSTextAlignmentLeft];
    tipLabel.text = @"描述您的服务";
    [self.contentView addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(priceLabel.mas_bottom).offset(30 * scale);
        make.left.mas_equalTo(15 * scale);
        make.height.mas_equalTo(15 * scale);
    }];
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectZero];
    lineView.backgroundColor = UIColorFromRGB(0xCCCCCC);
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(tipLabel.mas_bottom).offset(10 * scale);
        make.left.mas_equalTo(10 * scale);
        make.width.mas_equalTo(kMainBoundsWidth - 20 * scale);
        make.height.mas_equalTo(.5f);
    }];
    
    self.textView = [[RDTextView alloc] initWithFrame:CGRectZero];
    self.textView.font = kPingFangRegular(12 * scale);
    self.textView.textColor = UIColorFromRGB(0x666666);
    self.textView.placeholder = @"请详细描述您的服务，以便为您更快的找到需求商，特殊要求请重点突出";
    self.textView.placeholderLabel.textColor = UIColorFromRGB(0x999999);
    self.textView.placeholderLabel.font = kPingFangRegular(10 * scale);
    self.textView.maxSize = 200;
    [self.contentView addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineView.mas_bottom).offset(10 * scale);
        make.left.mas_equalTo(10 * scale);
        make.width.mas_equalTo(kMainBoundsWidth - 20 * scale);
        make.height.mas_equalTo(100 * scale);
    }];
    if (self.seriviceModel) {
        self.textView.text = self.seriviceModel.remark;
    }
    
    CGFloat width = (kMainBoundsWidth - 20 * scale) / 4.f;
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(width, width);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    
    self.imageCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [self.imageCollectionView registerClass:[FRImageCollectionViewCell class] forCellWithReuseIdentifier:@"FRImageCollectionViewCell"];
    self.imageCollectionView.backgroundColor = UIColorFromRGB(0xffffff);
    self.imageCollectionView.delegate = self;
    self.imageCollectionView.dataSource = self;
    self.imageCollectionView.scrollEnabled = NO;
    [self.contentView addSubview:self.imageCollectionView];
    [self.imageCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.textView.mas_bottom);
        make.left.mas_equalTo(10 * scale);
        make.width.mas_equalTo(kMainBoundsWidth - 20 * scale);
        make.height.mas_equalTo(width + 10 * scale);
    }];
    
    UIView * bottomLineView = [[UIView alloc] initWithFrame:CGRectZero];
    bottomLineView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    [self.contentView addSubview:bottomLineView];
    [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(10 * scale);
    }];
    
    self.tableView.tableHeaderView = self.contentView;
}

- (void)createTablerfooterView
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    UIView * footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, 50 * scale)];
    footerView.backgroundColor = UIColorFromRGB(0xffffff);
    UILabel * typeLable = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(15 * scale) textColor:UIColorFromRGB(0x999999) alignment:NSTextAlignmentLeft];
    typeLable.text = @"服务类型";
    [footerView addSubview:typeLable];
    [typeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30 * scale);
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(20 * scale);
    }];
    
    self.cateNameLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(15 * scale) textColor:UIColorFromRGB(0x333333) alignment:NSTextAlignmentLeft];
    self.cateNameLabel.text = self.model.name;
    [footerView addSubview:self.cateNameLabel];
    [self.cateNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(typeLable.mas_right).offset(25 * scale);
        make.centerY.mas_equalTo(typeLable);
        make.height.mas_equalTo(typeLable);
    }];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseCateType)];
    [footerView addGestureRecognizer:tap];
    
    self.tableView.tableFooterView = footerView;
    [self reloadWithImageChange];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imageSource.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FRImageCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FRImageCollectionViewCell" forIndexPath:indexPath];
    
    if (indexPath.row == self.imageSource.count) {
        
        [cell configLastCell];
        
    }else{
        UIImage * image = [self.imageSource objectAtIndex:indexPath.item];
        [cell configWithImage:image];
        
        __weak typeof(self) weakSelf = self;
        cell.imageDeleteHandle = ^{
            [weakSelf.imageSource removeObject:image];
            [weakSelf reloadWithImageChange];
        };
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.imageSource.count) {
        
        if (self.imageSource.count == self.maxCount) {
            NSString * title = [NSString stringWithFormat:@"最多只能选择%ld张", self.maxCount];
            [MBProgressHUD showTextHUDWithText:title];
            return;
        }
        
        TZImagePickerController * picker = [[TZImagePickerController alloc] initWithMaxImagesCount:100 delegate:self];
        picker.allowPickingOriginalPhoto = NO;
        picker.allowPickingVideo = NO;
        picker.showSelectedIndex = YES;
        picker.allowCrop = NO;
        picker.maxImagesCount = self.maxCount - self.imageSource.count;
        
        [self presentViewController:picker animated:YES completion:nil];
        
    }else{
        
        UIImage * image = [self.imageSource objectAtIndex:indexPath.item];
        LookImageViewController * look = [[LookImageViewController alloc] initWithImage:image];
        [self presentViewController:look animated:YES completion:nil];
        
    }
}

#pragma mark - 选取照片
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos
{
    [self.imageSource addObjectsFromArray:photos];
    
    [self reloadWithImageChange];
}

//由于图片数量变化需要刷新页面
- (void)reloadWithImageChange
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    CGFloat height = (kMainBoundsWidth - 20 * scale) / 4.f;
    if (self.imageSource.count > 3) {
        self.contentView.frame = CGRectMake(0, 0, kMainBoundsWidth, 380 * scale + height);
        [self.imageCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(height * 2 + 10 * scale);
        }];
    }else{
        self.contentView.frame = CGRectMake(0, 0, kMainBoundsWidth, 380 * scale);
        [self.imageCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(height + 10 * scale);
        }];
    }
    [self.imageCollectionView reloadData];
    [self.tableView reloadData];
}

- (NSMutableArray *)imageSource
{
    if (!_imageSource) {
        _imageSource = [NSMutableArray new];
    }
    return _imageSource;
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
