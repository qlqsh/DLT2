//
//  CompatibilityViewController.m
//  DaLeTou
//
//  Created by 刘明 on 2017/5/25.
//  Copyright © 2017年 刘明. All rights reserved.
//

#import "CompatibilityViewController.h"

#import "BallView.h"
#import "BallListView.h"
#import "BallButton.h"

#import "ItemDescription.h"
#import "StatisticsData.h"

#import "MBProgressHUD.h"

#import <PNChart/PNRadarChart.h>

@interface CompatibilityViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;

#pragma mark - 数据
@property (nonatomic, strong) NSDictionary *combinationDict;
@property (nonatomic, strong) NSArray *results;         // 结果数组。符合条件的数据。
@property (nonatomic, strong) NSMutableArray *items;    // 雷达图数据数组。
@property (nonatomic, strong) NSString *selected;       // 选择的号码。
@property (nonatomic) BOOL showRed;         // 是红球还是蓝球。
@property (nonatomic) NSUInteger maxShow;   // 最多显示数量。
@end

@implementation CompatibilityViewController
#pragma mark - UIViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 更新界面
    self.title = @"号码契合度";
    [self.view addSubview:self.tableView];
    
    // 更新数据
    [self initData];
    [self updateData];
}

/// 更新数据
- (void)updateData {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES]; // 显示进度指示器
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // 后台操作
        StatisticsData *statisticsData = [StatisticsData shared];
        _combinationDict = [statisticsData combinations];
        dispatch_async(dispatch_get_main_queue(), ^{
            // 回到主界面
            [self.tableView reloadData];
            [MBProgressHUD hideHUDForView:self.view animated:YES]; // 隐藏进度指示器
        });
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView 初始化
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        _tableView.allowsSelection = NO;
        _tableView.separatorInset = UIEdgeInsetsZero;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        
        // 注册Cell
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    
    return _tableView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_items == nil) { // 没有数据
        return 1;
    }
    if (![self perfectData]) { // 数据不完美
        return 2;
    }
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
        case 1:
            // 数据不完美状态。可能是雷达图、也可能是结果列表。
            return [self perfectData] ? 1 : _results.count;
        case 2:
            // 数据完美状态。
            return _results.count;
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    // 2. 使用删除子视图方式删除重影（不推荐）
    while ([cell.contentView.subviews lastObject] != nil) {
        [[cell.contentView.subviews lastObject] removeFromSuperview];
    }
    
    switch (indexPath.section) {
        case 0: {
            CGFloat buttonWidth = kScreenWidth/2 - 20.0f;
            UIButton *redButton = [[UIButton alloc] init];
            redButton.frame = CGRectMake(10, 5, buttonWidth, 34);
            redButton.layer.borderWidth = 0.5f;
            redButton.layer.borderColor = [UIColor grayColor].CGColor;
            redButton.layer.cornerRadius = 17.0f;
            [redButton setTitle:@"红球" forState:UIControlStateNormal];
            [redButton setTitleColor:kRedColor forState:UIControlStateNormal];
            [redButton addTarget:self
                          action:@selector(addRedAction)
                forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:redButton];
            UIButton *blueButton = [[UIButton alloc] init];
            blueButton.frame = CGRectMake(30 + buttonWidth, 5, buttonWidth, 34);
            blueButton.layer.borderWidth = 0.5f;
            blueButton.layer.borderColor = [UIColor grayColor].CGColor;
            blueButton.layer.cornerRadius = 17.0f;
            [blueButton setTitle:@"蓝球" forState:UIControlStateNormal];
            [blueButton setTitleColor:kBlueColor forState:UIControlStateNormal];
            [blueButton addTarget:self
                           action:@selector(addBlueAction)
                 forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:blueButton];
            break;
        }
        case 1: {
            if (!(_results == nil)) {
                if ([self perfectData]) {
                    CGRect frame = CGRectMake(15, 0, kScreenWidth - 30, kScreenWidth - 30);
                    PNRadarChartDataItem *firstRadarChart = [_items firstObject];
                    PNRadarChart *radarChart = [[PNRadarChart alloc] initWithFrame:frame items:_items valueDivider:firstRadarChart.value];
                    [cell.contentView addSubview:radarChart];
                    
                    NSArray *numberArray = [_selected componentsSeparatedByString:@" "];
                    CGFloat positionX = kScreenWidth/2 - numberArray.count*40/2;
                    CGFloat positionY = kScreenWidth/2 - 20 - 15;
                    NSUInteger i = 0;
                    for (NSString *number in numberArray) {
                        BallView *ballView = [[BallView alloc] initWithPosition:CGPointMake(positionX + 40*i, positionY)];
                        _showRed ? [ballView setState:2] : [ballView setState:3];
                        ballView.textLabel.text = number;
                        [cell.contentView addSubview:ballView];
                        i++;
                    }
                } else {
                    [self showResultsWithIndexPath:indexPath andCell:cell];
                }
            }
            break;
        }
        case 2: {
            if (!(_results == nil)) {
                [self showResultsWithIndexPath:indexPath andCell:cell];
            }
            break;
        }
        default:
            break;
    }
    return cell;
}

/// 绘制过滤后结果单元。
- (void)showResultsWithIndexPath:(NSIndexPath *)indexPath andCell:(UITableViewCell *)cell {
    if (!(_results == nil)) {
        // 数字组合
        ItemDescription *item = _results[indexPath.row];
        NSArray *numberArray = [item.content componentsSeparatedByString:@" "];
        CGFloat positionX = (kScreenWidth - (numberArray.count + 1)*40)/2;
        NSUInteger i = 0;
        for (NSString *number in numberArray) {
            BallView *ballView = [[BallView alloc] initWithPosition:CGPointMake(positionX + i*40.0f, 0)];
            ballView.textLabel.text = number;
            _showRed ? [ballView setState:2] : [ballView setState:3];
            i++;
            [cell.contentView addSubview:ballView];
        }
        
        // 数字标签
        UILabel *showLabel = [[UILabel alloc] initWithFrame:CGRectMake(positionX + 40*i, 20, 40, 20)];
        showLabel.text = [NSString stringWithFormat:@"[%lu]", (unsigned long)item.number];
        showLabel.textColor = [UIColor darkGrayColor];
        showLabel.textAlignment = NSTextAlignmentLeft;
        showLabel.font = [UIFont systemFontOfSize:12.0f];
        [cell.contentView addSubview:showLabel];
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return [self perfectData] ? kScreenWidth - 30 : 44.0;
    }
    return 44.0;
}

#pragma mark - 按钮动作
- (void)addRedAction {
    UIAlertController *alert =
        [UIAlertController alertControllerWithTitle:@"最多选择3个红球"
                                            message:@"\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
                                     preferredStyle:UIAlertControllerStyleAlert];
    BallListView *redsView = [[BallListView alloc] initIsDLT:YES
                                                    andIsRed:YES
                                                  andHasNull:NO
                                                  andColumns:6];
    CGRect frame = CGRectMake(16.0f,
                              50.0f,
                              redsView.frame.size.width,
                              redsView.frame.size.height);
    redsView.frame = frame;
    [alert.view addSubview:redsView];
    
    UIAlertAction *defaultAction =
        [UIAlertAction actionWithTitle:@"确认"
                                 style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action) {
                                   NSMutableArray *selectedBalls = [NSMutableArray arrayWithCapacity:5];
                                   for (BallButton *ballButton in redsView.balls) {
                                       if (ballButton.isSelected) {
                                           [selectedBalls addObject:ballButton.titleLabel.text];
                                       }
                                   }
                                   [self clearData];
                                   if (selectedBalls.count < 1) {
                                       [MBProgressHUD warnInView:self.view
                                                         andText:@"最少选择1个红球!"
                                                        andDelay:2.0f];
                                   } else if (selectedBalls.count > 3) {
                                       [MBProgressHUD warnInView:self.view
                                                         andText:@"最多选择3个红球!"
                                                        andDelay:2.0f];
                                   } else {
                                       _results = [self filterDataWithSelected:selectedBalls andIsRed:true];
                                       if (_items.count == 0) {
                                           [MBProgressHUD warnInView:self.view
                                                             andText:@"条件太多，没有参考价值。"
                                                            andDelay:2.0f];
                                       } else {
                                           // 延时机制，消除警告。
                                           MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                           dispatch_after((dispatch_time_t) 0.2, dispatch_get_main_queue(), ^{
                                               [hud hideAnimated:true];
                                               [self.tableView reloadData];
                                           });
                                       }
                                   }
                               }];
    [defaultAction setValue:kRedColor forKey:@"titleTextColor"];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction *action) {
                                                         }];
    [cancelAction setValue:kRedColor forKey:@"titleTextColor"];
    [alert addAction:defaultAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)addBlueAction {
    UIAlertController *alert =
    [UIAlertController alertControllerWithTitle:@"最多选择1个蓝球"
                                        message:@"\n\n\n\n\n"
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    BallListView *bluesView = [[BallListView alloc] initIsDLT:YES
                                                     andIsRed:NO
                                                   andHasNull:NO
                                                   andColumns:6];
    CGRect frame = CGRectMake(16.0f,
                              50.0f,
                              bluesView.frame.size.width,
                              bluesView.frame.size.height);
    bluesView.frame = frame;
    [alert.view addSubview:bluesView];
    
    UIAlertAction *defaultAction =
        [UIAlertAction actionWithTitle:@"确认"
                                 style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action) {
                                   NSMutableArray *selectedBalls = [NSMutableArray arrayWithCapacity:5];
                                   for (BallButton *ballButton in bluesView.balls) {
                                       if (ballButton.isSelected) {
                                           [selectedBalls addObject:ballButton.titleLabel.text];
                                       }
                                   }
                                   [self clearData];
                                   if (selectedBalls.count == 0) {
                                       [MBProgressHUD warnInView:self.view
                                                         andText:@"至少选择1个蓝球！"
                                                        andDelay:2.0f];
                                   } else if (selectedBalls.count == 1) {
                                       MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                       _results = [self filterDataWithSelected:selectedBalls andIsRed:false];
                                       // 延时机制，消除警告。
                                       dispatch_after((dispatch_time_t) 0.2, dispatch_get_main_queue(), ^{
                                           [hud hideAnimated:true];
                                           [self.tableView reloadData];
                                       });
                                   } else {
                                       [MBProgressHUD warnInView:self.view
                                                         andText:@"只能选择1个蓝球！"
                                                        andDelay:2.0f];
                                   }
                               }];
    [defaultAction setValue:kBlueColor forKey:@"titleTextColor"];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction *action) {
                                                         }];
    [cancelAction setValue:kBlueColor forKey:@"titleTextColor"];
    [alert addAction:defaultAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 雷达图相关
/// 判断是否应该出现雷达图。数据不完美，不适合雷达图。
- (BOOL)perfectData {
    // 第一个数字组合出现次数低于3，不显示雷达图，清理数据。
    NSUInteger show = 3;
    if (!(_items == nil)) {
        PNRadarChartDataItem *item = [_items firstObject];
        // 出现次数小于show，不显示雷达图。
        if (item.value < show) {
            return false;
        }
    }
    // 数字组合数量低于6个，不显示雷达图，清理数据。
    if (_items.count < _maxShow) {
        return false;
    }
    return true;
}

#pragma mark - 数据处理
/// 初始化数据
- (void)initData {
    _results = nil;
    _items = [NSMutableArray arrayWithCapacity:1];
    _selected = @"";
    _showRed = true;
    _maxShow = 6;
}

/// 清理旧数据
- (void)clearData {
    _results = nil;
    [_items removeAllObjects];
    _selected = @"";
    _showRed = true;
}

/// 根据选择的号码，过滤数据。返回包含选择号码的数据的数组。
- (NSArray *)filterDataWithSelected:(NSArray *)selected andIsRed:(BOOL)isRed {
    NSArray *combination = nil;
    if (isRed) {
        combination = _combinationDict[@(selected.count+1)];
        _showRed = true;
    } else {
        combination = _combinationDict[@(selected.count+5+1)];
        _showRed = false;
    }
    _selected = [selected componentsJoinedByString:@" "];
    NSMutableArray *results = [NSMutableArray arrayWithCapacity:_maxShow];
    NSUInteger i = 0;
    for (ItemDescription *item in combination) {
        if ([item contains:selected]) {
            [results addObject:item];
            if (i < _maxShow) {
                PNRadarChartDataItem *dataItem = [PNRadarChartDataItem dataItemWithValue:item.number description:[item comparedWithSelected:selected]];
                [self.items addObject:dataItem];
                i++;
            }
        }
    }
    return [results copy];
}

@end
