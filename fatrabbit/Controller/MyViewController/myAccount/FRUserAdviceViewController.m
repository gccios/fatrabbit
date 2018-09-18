//
//  FRUserAdviceViewController.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/5.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRUserAdviceViewController.h"
#import <TZImagePickerController.h>
#import "RDTextView.h"
#import "FRImageCollectionViewCell.h"
#import "LookImageViewController.h"
#import "MBProgressHUD+FRHUD.h"

@interface FRUserAdviceViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, TZImagePickerControllerDelegate>

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) UIView * contentView;
@property (nonatomic, strong) UITextField * contactField;
@property (nonatomic, strong) RDTextView * textView;

@property (nonatomic, strong) UICollectionView * imageCollectionView;
@property (nonatomic, strong) NSMutableArray * imageSource;
@property (nonatomic, assign) NSInteger maxCount;

@end

@implementation FRUserAdviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"意见反馈";
    self.maxCount = 7;
    
    [self createViews];
    [self createTableHeaderView];
}

- (void)handleButtonDidClicked
{
    
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
    self.tableView.tableFooterView = [UIView new];
    
    UIButton * handleButton = [FRCreateViewTool createButtonWithFrame:CGRectZero font:kPingFangRegular(15 * scale) titleColor:UIColorFromRGB(0xffffff) title:@"发布"];
    [handleButton setBackgroundColor:UIColorFromRGB(0xf8bf44)];
    [self.view addSubview:handleButton];
    [handleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(45 * scale);
    }];
    [handleButton addTarget:self action:@selector(handleButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
}

- (void)createTableHeaderView
{
    {
        CGFloat scale = kMainBoundsWidth / 375.f;
        
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, 380 * scale)];
        self.contentView.backgroundColor = UIColorFromRGB(0xffffff);
        [self.view addSubview:self.contentView];
        
        UIView * contactView = [[UIView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:contactView];
        [contactView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(0);
            make.height.mas_equalTo(50 * scale);
        }];
        
        UILabel * contactabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(14 * scale) textColor:UIColorFromRGB(0x333333) alignment:NSTextAlignmentLeft];
        contactabel.text = @"联系电话：";
        [contactView addSubview:contactabel];
        [contactabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0 * scale);
            make.left.mas_equalTo(25 * scale);
            make.height.mas_equalTo(20 * scale);
            make.width.mas_equalTo(80 * scale);
        }];
        
        self.contactField = [[UITextField alloc] initWithFrame:CGRectZero];
        self.contactField.textColor = UIColorFromRGB(0x999999);
        self.contactField.font = kPingFangRegular(13 * scale);
        [contactView addSubview:self.contactField];
        [self.contactField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.left.mas_equalTo(contactabel.mas_right);
            make.height.mas_equalTo(20 * scale);
            make.width.mas_equalTo(kMainBoundsWidth - 140 * scale);
        }];
        
        UIView * lineView = [[UIView alloc] initWithFrame:CGRectZero];
        lineView.backgroundColor = UIColorFromRGB(0xCCCCCC);
        [contactView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15 * scale);
            make.bottom.mas_equalTo(0);
            make.width.mas_equalTo(kMainBoundsWidth - 15 * scale);
            make.height.mas_equalTo(.5f);
        }];
        
        self.textView = [[RDTextView alloc] initWithFrame:CGRectZero];
        self.textView.font = kPingFangRegular(13 * scale);
        self.textView.textColor = UIColorFromRGB(0x666666);
        self.textView.placeholder = @"请详细描述您的意见或建议（限500字）";
        self.textView.placeholderLabel.textColor = UIColorFromRGB(0x999999);
        self.textView.placeholderLabel.font = kPingFangRegular(12 * scale);
        self.textView.maxSize = 500;
        [self.contentView addSubview:self.textView];
        [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(lineView.mas_bottom).offset(10 * scale);
            make.left.mas_equalTo(20 * scale);
            make.width.mas_equalTo(kMainBoundsWidth - 40 * scale);
            make.height.mas_equalTo(200 * scale);
        }];
        
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
