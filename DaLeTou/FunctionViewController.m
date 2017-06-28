//
//  FunctionViewController.m
//  DaLeTou
//
//  Created by 刘明 on 2017/6/12.
//  Copyright © 2017年 刘明. All rights reserved.
//

#import "FunctionViewController.h"

// Models
#import "DataManager.h"

// Views
#import "FunctionView.h"

// 第三方类
#import "Reachability.h"
#import "MBProgressHUD.h"

static NSString *const kCollectionViewCellIdentifier = @"functionCell";

@interface FunctionViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView; // 集合视图
@property (nonatomic, strong) UICollectionViewFlowLayout *collectionViewFlowLayout; // 流式布局

@property (nonatomic, strong) Reachability *connection; // 网络标识
@end

@implementation FunctionViewController
#pragma mark - UIViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initializeUserInterface];
    [self initializeNetworking];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [self stopNetworking];
}

- (void)initializeUserInterface {
    self.title = NSLocalizedString(@"FVC_title", nil);
    // 视图加载
    [self.view addSubview:self.collectionView];
    
    // 更新
    UIBarButtonItem *refreshButton =
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                      target:self
                                                      action:@selector(initializeNetworking)];
    refreshButton.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = refreshButton;
}

#pragma mark - 属性
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CGRect collectionViewRect = CGRectMake(0, 0,
                                               CGRectGetWidth(self.view.bounds),
                                               CGRectGetHeight(self.view.bounds));
        _collectionView = [[UICollectionView alloc] initWithFrame:collectionViewRect
                                             collectionViewLayout:self.collectionViewFlowLayout];
        UIImage *backgroundImage = [UIImage imageNamed:@"Background"];
        _collectionView.layer.contents = (id) backgroundImage.CGImage;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        
        // 注册
        [_collectionView registerClass:[UICollectionViewCell class]
            forCellWithReuseIdentifier:kCollectionViewCellIdentifier];
    }
    
    return _collectionView;
}

- (UICollectionViewFlowLayout *)collectionViewFlowLayout {
    if (!_collectionViewFlowLayout) {
        _collectionViewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
        // 设置cell
        CGFloat cellWidth = self.view.bounds.size.width / 2;
        CGFloat cellHeight = (CGFloat) (cellWidth * 1.25);
        _collectionViewFlowLayout.estimatedItemSize = CGSizeMake(cellWidth, cellHeight);
        _collectionViewFlowLayout.itemSize = CGSizeMake(cellWidth, cellHeight);
        _collectionViewFlowLayout.minimumLineSpacing = 0;
        _collectionViewFlowLayout.minimumInteritemSpacing = 0;
    }
    
    return _collectionViewFlowLayout;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return 8;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell =
        [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewCellIdentifier
                                                  forIndexPath:indexPath];
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    // 删除重影
    while ([cell.contentView.subviews lastObject] != nil) {
        [[cell.contentView.subviews lastObject] removeFromSuperview];
    }
    
    FunctionView *functionView = [[FunctionView alloc] initWithFrame:cell.bounds];
    functionView.state = indexPath.row;
    [cell.contentView addSubview:functionView];
    
    return cell;
}


#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: // 获奖列表
            [self performSegueWithIdentifier:@"Winnings" sender:nil];
            break;
        case 1: // 走势图
            [self performSegueWithIdentifier:@"Trend" sender:nil];
            break;
        case 2: // 历史同期
            [self performSegueWithIdentifier:@"HistorySame" sender:nil];
            break;
        case 3: // 统计
            [self performSegueWithIdentifier:@"Statistics" sender:nil];
            break;
        case 4: // 相似走势
            [self performSegueWithIdentifier:@"ConditionTrend" sender:nil];
            break;
        case 5: // 计算奖金
            [self performSegueWithIdentifier:@"CalculateMoney" sender:nil];
            break;
        case 6: // 号码组合
            [self performSegueWithIdentifier:@"CombinationAll" sender:nil];
            break;
        case 7: // 号码契合度
            [self performSegueWithIdentifier:@"Compatibility" sender:nil];
            break;
        default:
            break;
    }
}

#pragma mark - 网络监控
- (void)initializeNetworking {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkNetworkState)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    self.connection = [Reachability reachabilityForInternetConnection];
    [self.connection startNotifier];
    
    if ([self.connection currentReachabilityStatus] != NotReachable) {
        [self updateDataUseNetworking];
    }
}

- (void)stopNetworking {
    [self.connection stopNotifier];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/// 检测网络状态
- (void)checkNetworkState {
    if ([self.connection currentReachabilityStatus] == ReachableViaWiFi) { // WiFi
        [self updateDataUseNetworking];
    } else if ([self.connection currentReachabilityStatus] == ReachableViaWWAN) { // 3G
        [self updateDataUseNetworking];
    } else { // NotReachable
        [MBProgressHUD warnInView:self.view andText:@"网络无法访问" andDelay:2.0f];
        DLog(@"没有网络");
    }
}

/// 获取数据
- (void)updateDataUseNetworking {
    // 进度指示器
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        DataManager *dataManager = [DataManager shared];
        [dataManager updateWinningUseNetworking];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });
}

@end
