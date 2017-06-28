//
//  TrendViewController.m
//  DaLeTou
//
//  Created by 刘明 on 2017/5/30.
//  Copyright © 2017年 刘明. All rights reserved.
//

#import "TrendViewController.h"
#import "TrendData.h"

#import "AnRowTrendView.h"
#import "AnRowStatisticsView.h"
#import "BallButton.h"

#import <MBProgressHUD/MBProgressHUD.h>

@interface TrendViewController ()

// 显示视图
@property (nonatomic, strong) UIScrollView *scrollView; // 主视图（下面的都是子视图）
@property (nonatomic, strong) UIView *titleView;        // 标题视图
@property (nonatomic, strong) UIView *trendView;        // 走势视图
@property (nonatomic, strong) UIView *statisticsView;   // 统计视图
@property (nonatomic, strong) UIView *ballButtonView;   // 球按钮视图

// 数据
@property (nonatomic, strong) NSArray *trendArray;  // 走势数据
@property (nonatomic, strong) NSArray *terms;       // 期号数据
@property (nonatomic, strong) NSArray *numberOfOccurrences; // 出现次数
@property (nonatomic, strong) NSArray *maxContinuous;       // 最大连出
@property (nonatomic, strong) NSArray *maxMissings;         // 最大遗漏
@property (nonatomic, strong) NSArray *averageMissings;     // 平均遗漏

// 设置属性
@property (nonatomic) NSUInteger termAmount;    // 期数
@property (nonatomic) NSUInteger missing;       // 显示遗漏值
@property (nonatomic) NSUInteger statistics;    // 显示统计
@property (nonatomic) NSUInteger selectedBall;  // 显示选择球按钮

@end

@implementation TrendViewController
#pragma mark - UIViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self initializeData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initializeInterface];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/// 初始化界面
- (void)initializeInterface {
    // 设置视图
    self.title = @"走势图";
    UIBarButtonItem *settingButtonItem =
        [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Setting"]
                                         style:UIBarButtonItemStylePlain
                                        target:self
                                        action:@selector(setAction)];
    settingButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = settingButtonItem;
}

/// 初始化数据
- (void)initializeData {
    // 进度指示器+获取数据
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // 后台获取数据
        TrendData *trendData = [TrendData shared];
        _trendArray = trendData.trendArray;
        _terms = trendData.terms;
        _numberOfOccurrences = trendData.numberOfOccurrences;
        _maxContinuous = trendData.maxContinuousOccurrences;
        _maxMissings = trendData.maxMissing;
        _averageMissings = trendData.averageMissing;
        dispatch_async(dispatch_get_main_queue(), ^{
            // 回到主界面
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.view addSubview:self.scrollView];
        });
    });
}

#pragma mark - 视图
/// 滚动视图。主视图（其它视图都是它的字视图）
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        CGRect bounds = [[UIScreen mainScreen] bounds]; // 滚动视图占满整个屏幕
        CGFloat offsetY = kStatusBarHeight + kNavigationHeight;
        CGRect frame = CGRectMake(0,
                                  offsetY,
                                  bounds.size.width,
                                  bounds.size.height - offsetY);
        _scrollView = [[UIScrollView alloc] initWithFrame:frame];
        
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = NO;                 // 边界无法弹动
        _scrollView.directionalLockEnabled = YES; // 定向锁定
        
        CGFloat defaultWidth = 65.0f + 25.0f * 47;
        self.titleView.frame = CGRectMake(0, 0, defaultWidth, 25);
        [_scrollView addSubview:self.titleView];
        offsetY = _titleView.frame.size.height;
        
        self.trendView.frame = CGRectMake(0, offsetY, defaultWidth, 25 * [self showTerm]);
        [_scrollView addSubview:self.trendView];
        offsetY += _trendView.frame.size.height;
        
        if (self.statistics != 0) {
            self.statisticsView.frame = CGRectMake(0, offsetY, defaultWidth, 25 * 4);
            [_scrollView addSubview:self.statisticsView];
            offsetY += _statisticsView.frame.size.height;
        }
        
        if (self.selectedBall != 0) {
            self.ballButtonView.frame = CGRectMake(0, offsetY, defaultWidth, 25);
            [_scrollView addSubview:self.ballButtonView];
            offsetY += _ballButtonView.frame.size.height;
        }
        
        _scrollView.contentSize = CGSizeMake(defaultWidth, offsetY);
    }
    return _scrollView;
}

/// 数字标签视图、第一部分（必出）。
- (UIView *)titleView {
    if (!_titleView) {
        _titleView = [[UIView alloc] init];
        
        // 标示图像（头部）
        UIImageView *numIssue = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NumIssue"]];
        [_titleView addSubview:numIssue];
        
        // 数字标签
        for (int i = 1; i <= 47; i++) {
            CGFloat offsetX = numIssue.frame.size.width + (i - 1) * 25;
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(offsetX, 0, 25, 25)];
            label.layer.borderWidth = 0.5f;
            label.layer.borderColor = kRGBColor(230.0f, 230.0f, 230.0f).CGColor;
            if (i <= 35) {
                label.text = [NSString stringWithFormat:@"%d", i];
                if (i < 10) {
                    label.text = [NSString stringWithFormat:@"0%d", i];
                }
            } else {
                label.text = [NSString stringWithFormat:@"%d", i - 35];
                if ((i - 35) < 10) {
                    label.text = [NSString stringWithFormat:@"0%d", i - 35];
                }
            }
            label.textColor = kRGBColor(123.0f, 114.0f, 108.0f);
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:16.0f];
            label.backgroundColor = kRGBColor(236.0f, 231.0f, 219.0f);
            [_titleView addSubview:label];
        }
    }
    return _titleView;
}

/// 走势视图。第二部分（部分出（30行、50行、100行，3种选择））。
- (UIView *)trendView {
    if (!_trendView) {
        NSUInteger showTerm = [self showTerm];
        BOOL hasMissing = self.missing == 0 ? false : true;
        _trendView = [[UIView alloc] init];
        
        NSUInteger count = _trendArray.count;
        NSArray *trendArray = [_trendArray subarrayWithRange:NSMakeRange(count - showTerm, showTerm)];
        NSArray *termArray = [_terms subarrayWithRange:NSMakeRange(count - showTerm, showTerm)];
        NSUInteger i = 0;
        
        for (NSArray *anRow in trendArray) {
            AnRowTrendView *anRowView = [[AnRowTrendView alloc] initWithFrame:CGRectMake(65.0f, i * 25.0f, 65.0f + 25.0f * 47, 25.0f)];
            [anRowView setTrendDataWithBalls:anRow andHasMissing:hasMissing];
            if (i % 2 == 1) {
                [anRowView changeBackground];
            }
            [_trendView addSubview:anRowView];
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, i * 25.0f, 65.0f, 25.0f)];
            titleLabel.text = termArray[i];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.font = [UIFont systemFontOfSize:11.0f];
            titleLabel.layer.borderWidth = 0.5;
            titleLabel.layer.borderColor = kRGBColor(230.0f, 230.0f, 230.0f).CGColor;
            if (i % 2 == 1) {
                titleLabel.backgroundColor = UIColor.groupTableViewBackgroundColor;
            }
            [_trendView addSubview:titleLabel];
            i += 1;
        }
    }
    return _trendView;
}

/// 统计视图。第三部分（可能出）。
- (UIView *)statisticsView {
    if (!_statisticsView) {
        _statisticsView = [[UIView alloc] init];
        
        CGFloat defaultWidth = 65.0f + 25.0f * 47;
        // 出现次数视图
        AnRowStatisticsView *numberOfOccurrencesView =
            [[AnRowStatisticsView alloc] initWithFrame:CGRectMake(0, 0, defaultWidth, 25.0f)];
        numberOfOccurrencesView.statistics = _numberOfOccurrences;
        numberOfOccurrencesView.state = 0;
        numberOfOccurrencesView.titleLabel.text = @"出现次数";
        [_statisticsView addSubview:numberOfOccurrencesView];
        
        // 最大连出视图
        AnRowStatisticsView *maxContinuousView =
            [[AnRowStatisticsView alloc] initWithFrame:CGRectMake(0, 25, defaultWidth, 25.0f)];
        maxContinuousView.statistics = _maxContinuous;
        maxContinuousView.state = 1;
        maxContinuousView.titleLabel.text = @"最大连出";
        [_statisticsView addSubview:maxContinuousView];
        
        // 最大遗漏视图
        AnRowStatisticsView *maxMissingsView =
            [[AnRowStatisticsView alloc] initWithFrame:CGRectMake(0, 50, defaultWidth, 25.0f)];
        maxMissingsView.statistics = _maxMissings;
        maxMissingsView.state = 2;
        maxMissingsView.titleLabel.text = @"最大遗漏";
        [_statisticsView addSubview:maxMissingsView];
        
        // 平均遗漏视图
        AnRowStatisticsView *averageMissingsView =
            [[AnRowStatisticsView alloc] initWithFrame:CGRectMake(0, 75, defaultWidth, 25.0f)];
        averageMissingsView.statistics = _averageMissings;
        averageMissingsView.state = 3;
        averageMissingsView.titleLabel.text = @"平均遗漏";
        [_statisticsView addSubview:averageMissingsView];
    }
    return _statisticsView;
}

/// 球按钮视图。第四部分（可能出）。
- (UIView *)ballButtonView {
    if (!_ballButtonView) {
        _ballButtonView = [[UIView alloc] init];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 65, 25)];
        titleLabel.text = @"选号";
        titleLabel.textColor = [UIColor magentaColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:11.0f];
        titleLabel.layer.borderWidth = 0.5f;
        titleLabel.layer.borderColor = kRGBColor(230.0f, 230.0f, 230.0f).CGColor;
        [_ballButtonView addSubview:titleLabel];
        
        UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(65, 0, 25 * 47, 25)];
        for (int i = 1; i <= 47; i++) {
            BallButton *button =
                [[BallButton alloc] initWithPosition:CGPointMake((i - 1) * 25, 0)];
            CGFloat scale = 25.0f/40.0f;
            button.transform = CGAffineTransformMakeScale(scale, scale);
            button.frame = CGRectMake((i - 1) * 25.0f, 0, 25.0f, 25.0f);
            if (i <= 35) { // 红球
                button.text = i < 10 ? [NSString stringWithFormat:@"0%d", i] : [NSString stringWithFormat:@"%d", i];
                button.isRed = true;
            } else { // 蓝球
                button.text = ((i - 35) < 10) ? [NSString stringWithFormat:@"0%d", (i - 35)] : [NSString stringWithFormat:@"%d", (i - 35)];
                button.isRed = false;
            }
            [buttonView addSubview:button];
            buttonView.layer.borderWidth = 0.5f;
            buttonView.layer.borderColor = kRGBColor(230.0f, 230.0f, 230.0f).CGColor;
        }
        [_ballButtonView addSubview:buttonView];
    }
    return _ballButtonView;
}

#pragma mark - 设置属性。使用UserDefaults。
- (NSUInteger)userDefaultsValueWithKey:(NSString *)key {
    NSObject *value = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    return value == nil ? 0 : [(NSString *)value integerValue];
}

- (NSUInteger)termAmount {
    return [self userDefaultsValueWithKey:@"termAmount"];
}

- (void)setTermAmount:(NSUInteger)termAmount {
    return [[NSUserDefaults standardUserDefaults] setInteger:termAmount forKey:@"termAmount"];
}

- (NSUInteger)missing {
    return [self userDefaultsValueWithKey:@"missing"];
}

- (void)setMissing:(NSUInteger)missing {
    return [[NSUserDefaults standardUserDefaults] setInteger:missing forKey:@"missing"];
}

- (NSUInteger)statistics {
    return [self userDefaultsValueWithKey:@"statistics"];
}

- (void)setStatistics:(NSUInteger)statistics {
    return [[NSUserDefaults standardUserDefaults] setInteger:statistics forKey:@"statistics"];
}

- (NSUInteger)selectedBall {
    return [self userDefaultsValueWithKey:@"selectedBall"];
}

- (void)setSelectedBall:(NSUInteger)selectedBall {
    return [[NSUserDefaults standardUserDefaults] setInteger:selectedBall forKey:@"selectedBall"];
}

/// 设置对话框（显示行数、是否显示遗漏、是否显示统计、是否显示按钮行）
- (void)setAction {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"走势图设置"
                                                                   message:@"\n\n\n\n\n\n\n\n\n\n"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIColor *segmentedColor = kRedColor;
    UISegmentedControl *termAmount = [[UISegmentedControl alloc] initWithItems:@[
                                                                                 @"近30期",
                                                                                 @"近50期",
                                                                                 @"近100期",
                                                                                 ]];
    termAmount.frame = CGRectMake(10.0f, 60.0f, 250.0f, 30.0f);
    termAmount.tintColor = segmentedColor;
    UISegmentedControl *missing = [[UISegmentedControl alloc] initWithItems:@[@"隐藏遗漏", @"显示遗漏"]];
    missing.frame = CGRectMake(10.0f, 100.0f, 250.0f, 30.0f);
    missing.tintColor = segmentedColor;
    UISegmentedControl *statistics = [[UISegmentedControl alloc] initWithItems:@[@"隐藏统计", @"显示统计"]];
    statistics.frame = CGRectMake(10.0f, 140.0f, 250.0f, 30.0f);
    statistics.tintColor = segmentedColor;
    UISegmentedControl *selectedBall = [[UISegmentedControl alloc] initWithItems:@[@"隐藏选号", @"显示选号"]];
    selectedBall.frame = CGRectMake(10.0f, 180.0f, 250.0f, 30.0f);
    selectedBall.tintColor = segmentedColor;
    
    termAmount.selectedSegmentIndex = self.termAmount;
    missing.selectedSegmentIndex = self.missing;
    statistics.selectedSegmentIndex = self.statistics;
    selectedBall.selectedSegmentIndex = self.selectedBall;
    
    [alert.view addSubview:termAmount];
    [alert.view addSubview:missing];
    [alert.view addSubview:statistics];
    [alert.view addSubview:selectedBall];
    
    UIAlertAction *defaultAction =
        [UIAlertAction actionWithTitle:@"确认"
                                 style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action) {
                                   // 保存走势图属性设置
                                   self.termAmount = termAmount.selectedSegmentIndex;
                                   self.missing = missing.selectedSegmentIndex;
                                   self.statistics = statistics.selectedSegmentIndex;
                                   self.selectedBall = selectedBall.selectedSegmentIndex;
                                   
                                   [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                   // 延时机制。消除警告
                                   dispatch_after((dispatch_time_t) 0.2, dispatch_get_main_queue(), ^{
                                       // 删除滚动视图
                                       [self removeView];
                                       // 进度指示器
                                       [MBProgressHUD hideHUDForView:self.view animated:YES];
                                       [self.view addSubview:self.scrollView];
                                   });
                               }];
    [defaultAction setValue:segmentedColor forKey:@"titleTextColor"];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction *action) {
                                                         }];
    [cancelAction setValue:segmentedColor forKey:@"titleTextColor"];
    [alert addAction:defaultAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 便捷方法
- (NSUInteger)showTerm {
    switch (self.termAmount) {
        case 1:
            return 50;
        case 2:
            return 100;
        case 0:
        default:
            return 30;
    }
}

/// 删除视图
- (void)removeView {
    // 删除滚动视图
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            [view removeFromSuperview];
        }
    }
    
    // 视图清空（滚动视图、走势视图）
    self.scrollView = nil;
    self.trendView = nil;
}

@end
