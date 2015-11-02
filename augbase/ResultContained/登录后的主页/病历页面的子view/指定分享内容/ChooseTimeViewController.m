//
//  ChooseTimeViewController.m
//  Yizhenapp
//
//  Created by 李胜书 on 15/10/10.
//  Copyright © 2015年 李胜书. All rights reserved.
//

#import "ChooseTimeViewController.h"

@interface ChooseTimeViewController ()

{
    NSMutableArray *choosedTimeArray;//选中的数组
}

@end

@implementation ChooseTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self setupData];
}

-(void)setupView{
    self.title = NSLocalizedString(@"指定分享内容", @"");
    _setShareTimeTable = [[UITableView alloc]init];
    _setShareTimeTable.delegate = self;
    _setShareTimeTable.dataSource = self;
    _setShareTimeTable.tableFooterView = [[UIView alloc]init];
    _setShareTimeTable.backgroundColor = grayBackgroundLightColor;
    _setShareTimeTable.sectionFooterHeight = 22;
    [self.view addSubview:_setShareTimeTable];
    [_setShareTimeTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(@0);
    }];
}

-(void)setupData{
    choosedTimeArray = [NSMutableArray arrayWithArray:_setChoosedTimeArray];
}

#pragma delegate在最下方
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return _timeArray.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

#pragma 此处的cell的具体信息均需要从后端获取
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *settingCellIndentify = @"setShareCell";
    UITableViewCell *cell;
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:settingCellIndentify];
    }
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableView.separatorColor = lightGrayBackColor;
    tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);//上左下右,顺序
    if (indexPath.section == 0) {
        cell.textLabel.text = NSLocalizedString(@"全选", @"");
        if (choosedTimeArray.count == _timeArray.count) {
            cell.imageView.image = [UIImage imageNamed:@"choose"];
        }else{
            cell.imageView.image = [UIImage imageNamed:@"unselected"];
        }
    }else{
        cell.textLabel.text = _timeArray[indexPath.row];
        cell.imageView.image = [UIImage imageNamed:@"unselected"];
        for (NSString *choosedTitle in choosedTimeArray) {
            if ([choosedTitle isEqualToString:_timeArray[indexPath.row]]) {
                cell.imageView.image = [UIImage imageNamed:@"choose"];
            }
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"选中了%ld消息,执行跳转",(long)indexPath.row);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (choosedTimeArray.count == 0) {
            choosedTimeArray = [NSMutableArray arrayWithArray:_timeArray];
        }else{
            [choosedTimeArray removeAllObjects];
        }
        [_setShareTimeTable reloadData];
    }else{
        UIImage *cellImage = [tableView cellForRowAtIndexPath:indexPath].imageView.image;
        if ([cellImage isEqual:[UIImage imageNamed:@"choose"]]) {
            [choosedTimeArray removeObject:[tableView cellForRowAtIndexPath:indexPath].textLabel.text];
        }else{
            [choosedTimeArray addObject:[tableView cellForRowAtIndexPath:indexPath].textLabel.text];
        }
        [_setShareTimeTable reloadData];
    }
}

#pragma 添加头和尾
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0) {
        UIView *FooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 22)];
        FooterView.layer.borderColor = lightGrayBackColor.CGColor;
        FooterView.layer.borderWidth = 0.5;
        FooterView.backgroundColor = grayBackgroundLightColor;
        return FooterView;
    }else{
        UIView *FooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 22)];
        FooterView.backgroundColor = [UIColor clearColor];
        return FooterView;
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [_chooseTimeArrayDele chooseTimeArray:choosedTimeArray];
}

@end
