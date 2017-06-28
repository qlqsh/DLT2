//
//  StatisticsViewController.m
//  DaLeTou
//
//  Created by 刘明 on 2017/5/16.
//  Copyright © 2017年 刘明. All rights reserved.
//

#import "StatisticsViewController.h"
#import "ItemDescription.h"
#import "StatisticsData.h"

#import <PNPieChart.h>
#import <MBProgressHUD/MBProgressHUD.h>

@interface StatisticsViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *redCount;    // 红球出现情况
@property (nonatomic, strong) NSArray *blueCount;   // 蓝球出现情况
@property (nonatomic, strong) NSArray *headCount;   // 头号出现情况
@property (nonatomic, strong) NSArray *tailCount;   // 尾号出现情况
@property (nonatomic, strong) NSArray *valueOfSum;  // 和值（每差值10为1档）范围
@property (nonatomic, strong) NSArray *continuousCount; // 连号情况
@end

@implementation StatisticsViewController

#pragma mark - UITableView 初始化
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        _tableView.allowsSelection = NO;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        
        // 注册Cell
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"statisticsCell"];
    }
    
    return _tableView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"statisticsCell"];
    // 删除重影
    while ([cell.contentView.subviews lastObject] != nil) {
        [[cell.contentView.subviews lastObject] removeFromSuperview];
    }
    switch (indexPath.section) {
        case 0:
            [cell.contentView addSubview:[self drawPieChartWithArray:_redCount]];
            break;
        case 1:
            [cell.contentView addSubview:[self drawPieChartWithArray:_blueCount]];
            break;
        case 2:
            [cell.contentView addSubview:[self drawPieChartWithArray:_headCount]];
            break;
        case 3:
            [cell.contentView addSubview:[self drawPieChartWithArray:_tailCount]];
            break;
        case 4:
            [cell.contentView addSubview:[self drawPieChartWithArray:_valueOfSum]];
            break;
        case 5:
            [cell.contentView addSubview:[self drawPieChartWithArray:_continuousCount]];
            break;
        default:
            break;
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kScreenWidth;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30.0f)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = kRedColor;
    switch (section) {
        case 0:
            titleLabel.text = NSLocalizedString(@"headerTitleRed", nil);
            break;
        case 1:
            titleLabel.text = @"蓝球";
            break;
        case 2:
            titleLabel.text = @"头";
            break;
        case 3:
            titleLabel.text = @"尾";
            break;
        case 4:
            titleLabel.text = @"和值范围";
            break;
        case 5:
            titleLabel.text = @"连号概率";
            break;
        default:
            break;
    }
    return titleLabel;
}

#pragma mark - 饼图
/// 绘制饼图（红、蓝、头、尾）
- (PNPieChart *)drawPieChartWithArray:(NSArray *)dataArray {
    CGRect frame = CGRectMake(10.0f, 10.0f, kScreenWidth-20.0f, kScreenWidth-20.0f);
    NSArray *colors = [self colorsWithNumber:dataArray.count];
    NSMutableArray *items = [NSMutableArray arrayWithCapacity:dataArray.count];
    for (int i = 0; i < dataArray.count; i++) {
        ItemDescription *itemDescription = dataArray[i];
        PNPieChartDataItem *item = [PNPieChartDataItem dataItemWithValue:itemDescription.number
                                                                   color:colors[i]
                                                             description:itemDescription.content];
        [items addObject:item];
    }
    PNPieChart *pieChart = [[PNPieChart alloc] initWithFrame:frame items:[items copy]];
    pieChart.descriptionTextColor = [UIColor whiteColor];
    pieChart.descriptionTextFont = [UIFont fontWithName:@"Avenir-Medium" size:9.0];
    [pieChart strokeChart];
    return pieChart;
}

/// 饼图颜色数组
- (NSArray *)colorsWithNumber:(NSUInteger)number {
    if (number > 10) {
        NSMutableArray *colors = [NSMutableArray arrayWithCapacity:number];
        for (int i = 0; i < number; i++) {
            UIColor *color = kRGBColor(255.0-i*2, 83-i, 75-i);
            [colors addObject:color];
        }
        return colors;
    }
    return @[kRedColor, kBlueColor, kGreenColor, kOrangeColor, kYellowColor, kCyanColor, [UIColor brownColor], [UIColor purpleColor], [UIColor magentaColor], [UIColor grayColor]];
}

#pragma mark - UIViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 更新界面
    self.title = @"统计";
    [self.view addSubview:self.tableView];
    
    [self updateData];
}

/// 数据更新
- (void)updateData {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES]; // 显示进度指示器
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // 后台操作
        // 数据初始化
        StatisticsData *statisticsData = [StatisticsData shared];
        _redCount = statisticsData.redCount;
        _blueCount = statisticsData.blueCount;
        _headCount = statisticsData.headCount;
        _tailCount = statisticsData.tailCount;
        _valueOfSum = statisticsData.valueOfSum;
        _continuousCount = statisticsData.continuousCount;
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

@end
