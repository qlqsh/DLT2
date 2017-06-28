//
//  CalculateMoney.m
//  DaLeTou
//
//  Created by 刘明 on 2017/5/17.
//  Copyright © 2017年 刘明. All rights reserved.
//

#import "CalculateMoneyViewController.h"

#import "BallButton.h"
#import "BallListView.h"
#import "WinningBaseView.h"
#import "WinningDetailCell.h"
#import "ButtonCell.h"
#import "MyNumberCell.h"
#import "MoneyCell.h"

#import "Winning.h"
#import "DataManager.h"
#import "StatisticsData.h"

#import "MBProgressHUD.h"

@interface CalculateMoneyViewController () <UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, strong) NSArray *recentlyWinnings;    // 最近获奖号码数组
@property (nonatomic, strong) Winning *winning;             // 获奖号码
@property (nonatomic, strong) NSMutableArray *myNumber;     // 我的号码
@property (nonatomic, strong) NSString *winningMoneyDescription;    // 获奖描述
@end

@implementation CalculateMoneyViewController
#pragma mark - UIViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 更新界面
    self.title = @"奖金计算";
    [self.view addSubview:self.tableView];
    
    [self updateData];
}

/// 更新数据
- (void)updateData {
    _myNumber = [NSMutableArray arrayWithCapacity:1];
    _winningMoneyDescription = @"";
    [MBProgressHUD showHUDAddedTo:self.view animated:YES]; // 显示进度指示器
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // 后台操作
        DataManager *dataManager = [DataManager shared];
        _recentlyWinnings = [[dataManager readAllWinningInFile] subarrayWithRange:NSMakeRange(0, 10)];
        _winning = [_recentlyWinnings firstObject];
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
        
        _tableView.separatorInset = UIEdgeInsetsZero;
        _tableView.allowsSelection = NO;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        
        // 注册Cell
        [_tableView registerClass:[WinningDetailCell class] forCellReuseIdentifier:@"detailCell"];
        [_tableView registerClass:[MyNumberCell class] forCellReuseIdentifier:@"myNumberCell"];
        [_tableView registerClass:[ButtonCell class] forCellReuseIdentifier:@"buttonCell"];
        [_tableView registerClass:[MoneyCell class] forCellReuseIdentifier:@"moneyCell"];
    }
    
    return _tableView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0: // 最近获奖号码
            return 1;
        case 1: // 我的号码行
            return _myNumber.count;
        case 2: // 按钮行
            return 1;
        case 3: // 结果行
            if ([_winningMoneyDescription isEqualToString:@""]) {
                return 0;
            }
            return 1;
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: {
            WinningDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailCell"];
            UILabel *termLabel = [cell.contentView viewWithTag:111];
            UILabel *dateLabel = [cell.contentView viewWithTag:112];
            WinningBaseView *winningBaseView = [cell.contentView viewWithTag:113];
            termLabel.text = [NSString stringWithFormat:@"第%@期", _winning.term];
            dateLabel.text = [NSString stringWithFormat:@"%@（%@）", _winning.date, _winning.week];
            winningBaseView.texts = _winning.balls;
            [winningBaseView setSpecies:kIsDLT];
            UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectedWinningTermAction)];
            [cell addGestureRecognizer:tapGestureRecognizer];
            return cell;
        }
        case 1: {
            MyNumberCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myNumberCell"];
            // 删除重影
            while ([cell.contentView.subviews lastObject] != nil) {
                [[cell.contentView.subviews lastObject] removeFromSuperview];
            }
            NSDictionary *selected = _myNumber[indexPath.row];
            [cell setReds:selected[@"reds"] andBlues:selected[@"blues"]];
            return cell;
        }
        case 2: {
            ButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"buttonCell"];
            [cell.addButton addTarget:self
                               action:@selector(addAction)
                     forControlEvents:UIControlEventTouchUpInside];
            [cell.clearButton addTarget:self
                                 action:@selector(clearAction)
                       forControlEvents:UIControlEventTouchUpInside];
            [cell.calculateButton addTarget:self
                                     action:@selector(calculateAction)
                           forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }
        case 3: {
            MoneyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"moneyCell"];
            cell.winningMoneyView.text = _winningMoneyDescription;
            return cell;
        }
        default: {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            return cell;
        }
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
        case 1:
            return 20.0f;
        default:
            return 0.0f;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20.0f)];
    headerLabel.backgroundColor = kRedColor;
    headerLabel.textAlignment = NSTextAlignmentCenter;
    headerLabel.textColor = [UIColor whiteColor];
    switch (section) {
        case 0:
            headerLabel.text = @"开奖号码";
            break;
        case 1:
            headerLabel.text = @"我的号码";
            break;
        default:
            break;
    }
    return headerLabel;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return [WinningDetailCell heightOfCell];
        case 1: {
            NSDictionary *selected = _myNumber[indexPath.row];
            return [MyNumberCell heightOfCellWithCount:([selected[@"reds"] count] + [selected[@"blues"] count])];
        }
        case 2:
            return [ButtonCell heightOfCell];
        case 3:
            return [MoneyCell heightOfCell];
        default:
            return 40.0f;
    }
}

#pragma mark - 按钮动作
- (void)addAction {
    UIAlertController *alert =
        [UIAlertController alertControllerWithTitle:@"我的号码"
                                            message:@"\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
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
    redsView.layer.borderWidth = 0.5f;
    redsView.layer.borderColor = kRedColor.CGColor;
    [alert.view addSubview:redsView];
    
    BallListView *bluesView = [[BallListView alloc] initIsDLT:YES
                                                     andIsRed:NO
                                                   andHasNull:NO
                                                   andColumns:6];
    frame = CGRectMake(16.0f,
                       50.0f+redsView.frame.size.height+2.0f,
                       bluesView.frame.size.width,
                       bluesView.frame.size.height);
    bluesView.frame = frame;
    bluesView.layer.borderWidth = 0.5f;
    bluesView.layer.borderColor = kBlueColor.CGColor;
    [alert.view addSubview:bluesView];
    
    UIAlertAction *defaultAction =
        [UIAlertAction actionWithTitle:@"确认"
                                 style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action) {
                                   // 错误处理
                                   if (_myNumber.count > 20) {
                                       [MBProgressHUD warnInView:self.view
                                                         andText:@"您的获奖号码太多了！"
                                                        andDelay:2.0f];
                                   } else {
                                       NSMutableArray *reds = [NSMutableArray arrayWithCapacity:5];
                                       for (BallButton *ballButton in redsView.balls) {
                                           if (ballButton.isSelected) {
                                               [reds addObject:ballButton.titleLabel.text];
                                           }
                                       }
                                       NSMutableArray *blues = [NSMutableArray arrayWithCapacity:5];
                                       for (BallButton *ballButton in bluesView.balls) {
                                           if (ballButton.isSelected) {
                                               [blues addObject:ballButton.titleLabel.text];
                                           }
                                       }
                                       NSMutableDictionary *selected = [NSMutableDictionary dictionary];
                                       selected[@"reds"] = [reds copy];
                                       selected[@"blues"] = [blues copy];                                       
                                       MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                       hud.mode = MBProgressHUDModeText;
                                       if (reds.count < 5) {
                                           hud.label.text = @"最少需要选择5个红球！";
                                           [hud hideAnimated:YES afterDelay:2.0f];
                                       } else if (blues.count < 2) {
                                           hud.label.text = @"最少需要选择2个蓝球！";
                                           [hud hideAnimated:YES afterDelay:2.0f];
                                       } else if (reds.count > 15) {
                                           hud.label.text = @"最多只能选择15个红球！";
                                           [hud hideAnimated:YES afterDelay:2.0f];
                                       } else {
                                           [hud hideAnimated:YES];
                                           [_myNumber addObject:selected];
                                           // 延时机制。消除警告
                                           dispatch_after((dispatch_time_t) 0.2, dispatch_get_main_queue(), ^{
                                               // 刷新表格
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

- (void)clearAction {
    [_myNumber removeAllObjects];
    _winningMoneyDescription = @"";
    [self.tableView reloadData];
}

- (void)calculateAction {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        StatisticsData *statisticsData = [StatisticsData shared];
        _winningMoneyDescription = [statisticsData calculateMoneyWithCurrentWinning:_winning andMyNumber:_myNumber];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });
}

#pragma mark - UIPickerView
- (UIPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectZero];
        _pickerView.frame = CGRectMake(0.0f, 40.0f, 270.0f, 162.0f);
        
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        
        [_pickerView selectRow:0 inComponent:0 animated:YES];
    }
    return _pickerView;
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _recentlyWinnings.count;
}

#pragma mark - UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    Winning *winning = _recentlyWinnings[(NSUInteger)row];
    return [NSString stringWithFormat:@"%@期 （%@）", winning.term, winning.week];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    _winning = _recentlyWinnings[(NSUInteger)row];
}

/// 选择获奖期号
- (void)selectedWinningTermAction {
    UIAlertController *alert =
        [UIAlertController alertControllerWithTitle:@"期号"
                                            message:@"\n\n\n\n\n\n\n\n\n"
                                     preferredStyle:UIAlertControllerStyleAlert];
    [alert.view addSubview:self.pickerView];
    
    UIAlertAction *defaultAction =
        [UIAlertAction actionWithTitle:@"确认"
                                 style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action) {
                                   [self.tableView reloadData];
                               }];
    [defaultAction setValue:kRedColor forKey:@"titleTextColor"];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
