//
//  CombinationViewController.m
//  DaLeTou
//
//  Created by 刘明 on 2017/5/24.
//  Copyright © 2017年 刘明. All rights reserved.
//

#import "CombinationViewController.h"

#import "StatisticsData.h"
#import "ItemDescription.h"

#import "BallView.h"

@interface CombinationViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionViewFlowLayout *collectionViewFlowLayout;
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation CombinationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 更新界面
    NSString *text = _isRed ? @"红球" : @"蓝球";
    NSUInteger number = (_number > 5) ? (_number - 5) : _number;
    self.title = [NSString stringWithFormat:@"%tu个%@组合", number, text];
    [self.view addSubview:self.collectionView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionView 初始化
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds
                                             collectionViewLayout:self.collectionViewFlowLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        
        UIImage *backgroundImage = [UIImage imageNamed:@"Background"];
        _collectionView.layer.contents = (id) backgroundImage.CGImage;
        
        // 注册
        [_collectionView registerClass:[UICollectionViewCell class]
            forCellWithReuseIdentifier:@"combinationCell"];
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)collectionViewFlowLayout {
    if (!_collectionViewFlowLayout) {
        _collectionViewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
        // 设置cell
        CGFloat width = 40.0 * _number;
        if (_number > 5) {
            width = 40.0 * (_number - 5);
        }
        
        _collectionViewFlowLayout.estimatedItemSize = CGSizeMake(width, 60.0f);
        _collectionViewFlowLayout.itemSize = CGSizeMake(width, 40.0f);
        _collectionViewFlowLayout.minimumLineSpacing = 5;
        _collectionViewFlowLayout.minimumInteritemSpacing = 5;
        _collectionViewFlowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    }
    return _collectionViewFlowLayout;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return _combinations.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"combinationCell" forIndexPath:indexPath];
    
    // 使用删除子视图方式删除重影
    while ([cell.contentView.subviews lastObject] != nil) {
        [[cell.contentView.subviews lastObject] removeFromSuperview];
    }
    
    // 数字组合
    ItemDescription *item = _combinations[indexPath.row];
    NSUInteger i = 0;
    for (NSString *ball in [item.content componentsSeparatedByString:@" "]) {
        BallView *ballView = [[BallView alloc] initWithPosition:CGPointMake(i * 40.0f, 0)];
        _isRed ? (ballView.state = 2) : (ballView.state = 3);
        ballView.textLabel.text = ball;
        i++;
        [cell.contentView addSubview:ballView];
    }
    
    // 数字标签
    UILabel *showLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, 40.0f * i, 20)];
    showLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)item.number];
    showLabel.textColor = [UIColor darkGrayColor];
    showLabel.textAlignment = NSTextAlignmentCenter;
    showLabel.font = [UIFont systemFontOfSize:12.0f];
    [cell.contentView addSubview:showLabel];
    
    cell.layer.borderWidth = 0.5f;
    cell.layer.borderColor = [UIColor grayColor].CGColor;
    cell.layer.cornerRadius = 5.0;
    
    return cell;
}

@end
