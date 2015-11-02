//
//  ChooseTitleViewController.m
//  Yizhenapp
//
//  Created by 李胜书 on 15/10/10.
//  Copyright © 2015年 李胜书. All rights reserved.
//

#import "ChooseTitleViewController.h"

@interface ChooseTitleViewController ()

{
    NSMutableArray *choosedTitleArray;//选中的标题
}

@end

@implementation ChooseTitleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self setupData];
}

-(void)setupView{
    self.title = NSLocalizedString(@"指定分享内容", @"");
    _setShareTitleTable = [[UITableView alloc]init];
    _setShareTitleTable.delegate = self;
    _setShareTitleTable.dataSource = self;
    _setShareTitleTable.tableFooterView = [[UIView alloc]init];
    _setShareTitleTable.backgroundColor = grayBackgroundLightColor;
    _setShareTitleTable.sectionFooterHeight = 22;
    [self.view addSubview:_setShareTitleTable];
    [_setShareTitleTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(@0);
    }];
}

-(void)setupData{
    choosedTitleArray = [NSMutableArray arrayWithArray:_setChoosedTitleArray];
    _setChoosedENGTitleArray = [NSMutableArray array];
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
        return _titleArray.count;
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
        if (choosedTitleArray.count == _titleArray.count) {
            cell.imageView.image = [UIImage imageNamed:@"choose"];
        }else{
            cell.imageView.image = [UIImage imageNamed:@"unselected"];
        }
    }else{
        cell.textLabel.text = _titleArray[indexPath.row];
        cell.imageView.image = [UIImage imageNamed:@"unselected"];
        for (NSString *choosedTitle in choosedTitleArray) {
            if ([choosedTitle isEqualToString:_titleArray[indexPath.row]]) {
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
        if (choosedTitleArray.count == 0) {
            choosedTitleArray = [NSMutableArray arrayWithArray:_titleArray];
            _setChoosedENGTitleArray = [NSMutableArray arrayWithArray:_titleENGArray];
        }else{
            [choosedTitleArray removeAllObjects];
            [_setChoosedENGTitleArray removeAllObjects];
        }
        [_setShareTitleTable reloadData];
    }else{
        UIImage *cellImage = [tableView cellForRowAtIndexPath:indexPath].imageView.image;
        if ([cellImage isEqual:[UIImage imageNamed:@"choose"]]) {
            [choosedTitleArray removeObject:[tableView cellForRowAtIndexPath:indexPath].textLabel.text];
            [_setChoosedENGTitleArray removeObject:_titleENGArray[indexPath.row]];
        }else{
            [choosedTitleArray addObject:[tableView cellForRowAtIndexPath:indexPath].textLabel.text];
            [_setChoosedENGTitleArray addObject:_titleENGArray[indexPath.row]];
        }
        [_setShareTitleTable reloadData];
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
    [_chooseTitleArrayDele chooseTitleArray:choosedTitleArray ChoosedENGArray:_setChoosedENGTitleArray];
}

@end
