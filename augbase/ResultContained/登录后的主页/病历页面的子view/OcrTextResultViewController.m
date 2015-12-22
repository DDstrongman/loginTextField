//
//  ViewController.m
//  ResultContained
//
//  Created by 李胜书 on 15/6/26.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "OcrTextResultViewController.h"
#import "MJRefresh.h"

#import "OrderTextListViewController.h"
#import "DetailImageOcrViewController.h"
#import "DrugHistroyViewController.h"

#import "SetShareContentRootViewController.h"

#import "WriteFileSupport.h"

@interface OcrTextResultViewController ()

{
    CGFloat cellHeight;
    
    NSMutableArray *bottomArray;//底部工具条的数据dataArray
    UIView *bottomMessView;//底部显示详细信息的view
    UITableView *bottomTable;//底部显示用的tableview
    UIView *visualEffectView;//提供高斯模糊的view
    
    UIView *bottomRightView;//点击显示详情后右方跳出view，本来应该用scrollview的，但是本页面scrollview太多，尽量减少更多的scrollview应用
    
    UIView *shareView;//底部分享view
    
    NSMutableArray *titleArray;//列表表名（时间）数组
    
    NSMutableArray *showNameArray;//结果总表名，用来显示数据结果名称
    NSMutableArray *ocrDetailValueArray;//保存每行显示总结果的数组
    NSArray *customizedIdsOrder;//保存数据每列排序的总数组
    NSMutableArray *showNameTempArray;//10个结果表名，用来显示数据结果名称
    NSMutableArray *ocrDetailTempValueArray;//保留所有
    NSArray *customizedIdsTempOrder;//10个保存数据每列排序的数组
    
    NSDictionary *allCodeDetails;//所有数据键值对应的中文名字典
    
    NSInteger tableTag;//点击tableview的tag；
    NSInteger tableIndexRow;//点击tableview的列号
    
    UILabel *bottomTitleLabel;//底部view的标题label
    UILabel *bottomRightLabel;//底部右方view的标题label
    
    NSMutableArray *bottomMedicArray;//底部显示用药的数组
    NSMutableArray *bottomValueArray;//底部显示指标详情的数组
    UITextView *detailTextView;//底部显示标题具体解释给用户的textview
    
    NSInteger ocrResultIndex;//刷新的页数，从0开始，每页10个数据
    BOOL flushResult;//判断是否在进行刷新，防止多次刷新
    
    NSMutableArray *colorArray;//药物颜色的数组
    NSArray *medicineArray;//药品数组，用来分配药品颜色
    
    
    NSString *changeStatus;//需要改变为isviewed（查看过）状态的id组合字符串
    
    UIButton *firstButton;//底部分享按钮
    UIButton *secondButton;//底部排序按钮
    
    NSDictionary *picList;//总详情
    
    UITableView *bChaoTable;//b超的表
    
    int pageNumber;//当前一页的table数目
    
    UIButton *bottomButton;//底部提示用button
}

@end

@implementation OcrTextResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
    [[UIApplication sharedApplication]setStatusBarHidden:YES];
    [self setupData];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 3) {
        if (tableTag == 100) {
            if(ocrDetailValueArray.count == 0){
                return 1;
            }else{
                return  ((NSArray *)[(NSDictionary *)ocrDetailValueArray[tableIndexRow] objectForKey:@"medhis"]).count;
            }
        }else{
            return bottomValueArray.count;
        }
    }else{
        return titleArray.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 3) {
        return 50;
    }else{
        return 45;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (tableView.tag == 555) {
        NSString static *cellIndentify = @"bChaoInfoCell";
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIndentify];
        }
        if (ocrDetailValueArray.count>0) {
            if ([[ocrDetailValueArray[indexPath.row] objectForKey:@"ltrList"][0] objectForKey:@"type"] != [NSNull null]) {
                if ([[[ocrDetailValueArray[indexPath.row] objectForKey:@"ltrList"][0] objectForKey:@"type"] intValue] == 1) {
                    //                cell.imageView.image = [UIImage imageNamed:@"the_b_of_super"];
                    UIImageView *tailImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"the_b_of_super"]];
                    cell.accessoryView = tailImageView;
                }else{
                    cell.detailTextLabel.text = @"-";
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
            }else{
                cell.detailTextLabel.text = @"-";
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
        }
        if (indexPath.row%2 == 0) {
            cell.backgroundColor = [UIColor whiteColor];
        }else{
            cell.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:248.0/255.0 blue:248.0/255.0 alpha:1.0];
        }
    }else if (tableView == _nameTable) {
        BOOL tempIsFinished = YES;
        if (ocrDetailValueArray.count>0) {
            for (NSDictionary *dic in [ocrDetailValueArray[indexPath.row] objectForKey:@"medhis"]) {
                if ([[dic objectForKey:@"progress"] isEqualToString:@"start"]||[[dic objectForKey:@"progress"] isEqualToString:@"finish"]) {
                    cell = [tableView dequeueReusableCellWithIdentifier:@"doubleresult" forIndexPath:indexPath];
                    [((UIButton *)[cell.contentView viewWithTag:2]).imageView viewWithRadis:3.0];
                    if ([[dic objectForKey:@"progress"] isEqualToString:@"start"]) {
                        [((UIButton *)[cell.contentView viewWithTag:2]) setImage:[UIImage imageNamed:@"begin"] forState:UIControlStateNormal];
                    }else{
                        [((UIButton *)[cell.contentView viewWithTag:2]) setImage:[UIImage imageNamed:@"stop"] forState:UIControlStateNormal];
                    }
                    [((UIButton *)[cell.contentView viewWithTag:2]) setTitle:[dic objectForKey:@"medname"] forState:UIControlStateNormal];
                    for (int i= 0; i<medicineArray.count; i++) {
                        if ([[dic objectForKey:@"medname"] isEqualToString:medicineArray[i]]) {
                            ((UIButton *)[cell.contentView viewWithTag:2]).imageView.backgroundColor = colorArray[(i%10)];
                        }
                    }
                    tempIsFinished = NO;
                    [cell viewWithTag:7].hidden = YES;
                    if ([[ocrDetailValueArray[indexPath.row] objectForKey:@"isViewedByMe"] boolValue]) {
                        [cell viewWithTag:6].backgroundColor = themeColor;
                        [[cell viewWithTag:6] imageWithRound:NO];
                        [cell viewWithTag:6].hidden = YES;
                    }else{
                        [cell viewWithTag:6].backgroundColor = themeColor;
                        [[cell viewWithTag:6] imageWithRound:NO];
                        [cell viewWithTag:6].hidden = NO;
                    }
                    break;
                }
            }
            if (tempIsFinished) {
                cell = [tableView dequeueReusableCellWithIdentifier:@"result" forIndexPath:indexPath];
            }
        }else{
            cell = [tableView dequeueReusableCellWithIdentifier:@"result" forIndexPath:indexPath];
        }
        if (titleArray.count>0) {
            ((UILabel *)[cell.contentView viewWithTag:1]).text = [(NSString *)titleArray[indexPath.row] substringFromIndex:2];
        }
        cell.backgroundColor = [UIColor whiteColor];
        cell.layer.borderWidth = 0.25;
        cell.layer.borderColor = grayBackgroundDarkColor.CGColor;
        UIView *shadowView = [[UIView alloc]initWithFrame:CGRectMake(cell.bounds.size.width-2, -2, 1.5, cell.bounds.size.height+4)];
        shadowView.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0];
        [cell addSubview:shadowView];
    }else if(tableView.tag == 3){
        NSDictionary *lineDetailDic;
        if (ocrDetailValueArray.count > 0) {
            lineDetailDic = ocrDetailValueArray[tableIndexRow];
        }
        NSString static *bottomCellIndentify = @"BottomCell";
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:bottomCellIndentify];
        }
        if (tableTag == 100) {
            if (titleArray.count>0) {
                bottomTitleLabel.text = titleArray[tableIndexRow];
                NSArray *medicArray = [lineDetailDic objectForKey:@"medhis"];
                if (medicArray.count >indexPath.row) {
                    cell.textLabel.text = [(NSDictionary *)medicArray[indexPath.row] objectForKey:@"medname"];
                    UIButton *weekBottonButton = [[UIButton alloc]init];
                    [weekBottonButton viewWithRadis:3.0];
                    for (int i= 0; i<medicineArray.count; i++) {
                        if ([[(NSDictionary *)medicArray[indexPath.row] objectForKey:@"medname"] isEqualToString:medicineArray[i]]) {
                            weekBottonButton.backgroundColor = colorArray[(i%10)];
                        }
                    }
//                    cell.detailTextLabel.text = [[[(NSDictionary *)medicArray[indexPath.row] objectForKey:@"week"] stringValue] stringByAppendingString:@"周"];
                    weekBottonButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
                    [weekBottonButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
                    [weekBottonButton setTitle:[[[(NSDictionary *)medicArray[indexPath.row] objectForKey:@"week"] stringValue] stringByAppendingString:@"周"] forState:UIControlStateNormal];
                    [cell addSubview:weekBottonButton];
                    [weekBottonButton mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.right.equalTo(@-15);
                        make.centerY.mas_equalTo(cell.mas_centerY);
                        make.width.equalTo(@60);
                        make.height.equalTo(@30);
                    }];
                    
                    for (NSDictionary *dic in [ocrDetailValueArray[indexPath.row] objectForKey:@"medhis"]) {
                        if ([[dic objectForKey:@"progress"] isEqualToString:@"start"]||[[dic objectForKey:@"progress"] isEqualToString:@"finish"]) {
                            if ([[dic objectForKey:@"progress"] isEqualToString:@"start"]) {
                                [weekBottonButton setImage:[UIImage imageNamed:@"begin"] forState:UIControlStateNormal];
                            }else{
                                [weekBottonButton setImage:[UIImage imageNamed:@"stop"] forState:UIControlStateNormal];
                            }
                        }
                    }
                }
            }
        }else{
            NSDictionary *valuesDetailDic;
            if (tableTag > 100) {
                bottomTitleLabel.text = [showNameTempArray[tableTag-100-1] objectForKey:@"showname"];
                NSString *tempString = [showNameTempArray[tableTag-100-1] objectForKey:@"description"];
                tempString  = [tempString stringByReplacingOccurrencesOfString:@"<p>"  withString:@"  "];
                tempString  = [tempString stringByReplacingOccurrencesOfString:@"</p>"  withString:@"  "];
                detailTextView.text = tempString;
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                paragraphStyle.lineSpacing = 8; //行距
                NSDictionary *attributes = @{ NSFontAttributeName:[UIFont systemFontOfSize:15], NSParagraphStyleAttributeName:paragraphStyle};
                
                detailTextView.attributedText = [[NSAttributedString alloc]initWithString: detailTextView.text attributes:attributes];
                NSDictionary *valuestempDic = [lineDetailDic objectForKey:@"values"];
                valuesDetailDic = [valuestempDic objectForKey:customizedIdsTempOrder[tableTag-100-1]];
            }
            cell.textLabel.text = bottomValueArray[indexPath.row];
            if (indexPath.row == 0) {
                if ([[valuesDetailDic objectForKey:@"type"]intValue] != 0) {
                    cell.detailTextLabel.text = NSLocalizedString(@"阴", @"");
                }else{
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"(%@~%@)%@",[valuesDetailDic objectForKey:@"lowerlimit"],[valuesDetailDic objectForKey:@"upperlimit"],[valuesDetailDic objectForKey:@"unit"]];
                }
            }else if (indexPath.row == 1){
                if ([[valuesDetailDic objectForKey:@"calmethod"]intValue] != 0) {
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%g %@",[[valuesDetailDic objectForKey:@"value"] doubleValue],[valuesDetailDic objectForKey:@"unit"]];
                }else{
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@",[valuesDetailDic objectForKey:@"value"],[valuesDetailDic objectForKey:@"unit"]];
                }
            }else if (indexPath.row == 2){
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[valuesDetailDic objectForKey:@"categoryName"]];
            }else{
                if ([[lineDetailDic objectForKey:@"hospitalName"] isKindOfClass:[NSNull class]]) {
                    cell.detailTextLabel.text = @"--";
                }else{
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[lineDetailDic objectForKey:@"hospitalName"]];
                }
            }
        }
    }
    else {
        NSString static *cellIndentify = @"AllInfoCell";
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentify];
        }
        NSDictionary *lineDetailDic;
        if (ocrDetailTempValueArray.count > 0) {
            lineDetailDic = ocrDetailTempValueArray[indexPath.row];
        }
        if (tableView == _firstResultTable) {
            NSNumber *firstWidth;
            NSNumber *secondWidth;
            NSNumber *thirdWidth;
            UIButton *firstWeekButton = [[UIButton alloc]init];
            firstWeekButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
            [firstWeekButton setTitle:[@"1" stringByAppendingString:@"周"] forState:UIControlStateNormal];
            firstWeekButton.backgroundColor = themeColor;
            [cell addSubview:firstWeekButton];
            [firstWeekButton viewWithRadis:5.0];
            UIButton *secondWeekButton = [[UIButton alloc]init];
            secondWeekButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
            secondWeekButton.backgroundColor = themeColor;
            [secondWeekButton setTitle:[@"12" stringByAppendingString:@"周"] forState:UIControlStateNormal];
            [secondWeekButton viewWithRadis:5.0];
            [cell addSubview:secondWeekButton];
            UIButton *thirdWeekButton = [[UIButton alloc]init];
            thirdWeekButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
            thirdWeekButton.backgroundColor = themeColor;
            [thirdWeekButton setTitle:[@"31" stringByAppendingString:@"周"] forState:UIControlStateNormal];
            [thirdWeekButton viewWithRadis:5.0];
            [cell addSubview:thirdWeekButton];
            UILabel *pointLabel = [[UILabel alloc]init];
            pointLabel.text = @"...";
            pointLabel.textColor = [UIColor colorWithRed:50.0/255.0 green:50.0/255.0 blue:50.0/255.0 alpha:1.0];
            [cell addSubview:pointLabel];
            pointLabel.hidden = YES;
            
            firstWeekButton.tag = indexPath.row;
            secondWeekButton.tag = indexPath.row;
            thirdWeekButton.tag = indexPath.row;
            
            [firstWeekButton addTarget:self action:@selector(weekButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [secondWeekButton addTarget:self action:@selector(weekButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [thirdWeekButton addTarget:self action:@selector(weekButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            NSArray *medHis = [lineDetailDic objectForKey:@"medhis"];
            NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
            if (medHis.count == 0) {
                firstWeekButton.hidden = YES;
                secondWeekButton.hidden = YES;
                thirdWeekButton.hidden = YES;
                pointLabel.hidden = YES;
            }else if(medHis.count == 1){
                firstWeekButton.hidden = NO;
                secondWeekButton.hidden = YES;
                thirdWeekButton.hidden = YES;
                pointLabel.hidden = YES;
                NSDictionary *medDic = medHis[0];
                [firstWeekButton setTitle:[[[medDic objectForKey:@"week"] stringValue] stringByAppendingString:@"周"] forState:UIControlStateNormal];
                for (int i= 0; i<medicineArray.count; i++) {
                    if ([[medDic objectForKey:@"medname"] isEqualToString:medicineArray[i]]) {
                        firstWeekButton.backgroundColor = colorArray[(i%10)];
                    }
                }
            }else if (medHis.count == 2){
                firstWeekButton.hidden = NO;
                secondWeekButton.hidden = NO;
                thirdWeekButton.hidden = YES;
                pointLabel.hidden = YES;
                NSDictionary *medDicOne = medHis[0];
                NSDictionary *medDicTwo = medHis[1];
                [firstWeekButton setTitle:[[numberFormatter stringFromNumber:[medDicOne objectForKey:@"week"]] stringByAppendingString:@"周"] forState:UIControlStateNormal];
                [secondWeekButton setTitle:[[numberFormatter stringFromNumber:[medDicTwo objectForKey:@"week"]] stringByAppendingString:@"周"] forState:UIControlStateNormal];
                for (int i= 0; i<medicineArray.count; i++) {
                    if ([[medDicOne objectForKey:@"medname"] isEqualToString:medicineArray[i]]) {
                        firstWeekButton.backgroundColor = colorArray[(i%10)];
                    }
                }
                for (int i= 0; i<medicineArray.count; i++) {
                    if ([[medDicTwo objectForKey:@"medname"] isEqualToString:medicineArray[i]]) {
                        secondWeekButton.backgroundColor = colorArray[(i%10)];
                    }
                }
            }else{
                firstWeekButton.hidden = NO;
                secondWeekButton.hidden = NO;
                thirdWeekButton.hidden = NO;
                if (medHis.count == 3) {
                    pointLabel.hidden = YES;
                }else{
                    pointLabel.hidden = NO;
                }
                NSDictionary *medDicOne = medHis[0];
                NSDictionary *medDicTwo = medHis[1];
                NSDictionary *medDicThree = medHis[2];
                [firstWeekButton setTitle:[[numberFormatter stringFromNumber:[medDicOne objectForKey:@"week"]] stringByAppendingString:@"周"] forState:UIControlStateNormal];
                [secondWeekButton setTitle:[[numberFormatter stringFromNumber:[medDicTwo objectForKey:@"week"]] stringByAppendingString:@"周"] forState:UIControlStateNormal];
                [thirdWeekButton setTitle:[[numberFormatter stringFromNumber:[medDicThree objectForKey:@"week"]] stringByAppendingString:@"周"] forState:UIControlStateNormal];
                for (int i= 0; i<medicineArray.count; i++) {
                    if ([[medDicOne objectForKey:@"medname"] isEqualToString:medicineArray[i]]) {
                        firstWeekButton.backgroundColor = colorArray[(i%10)];
                    }
                }
                for (int i= 0; i<medicineArray.count; i++) {
                    if ([[medDicTwo objectForKey:@"medname"] isEqualToString:medicineArray[i]]) {
                        secondWeekButton.backgroundColor = colorArray[(i%10)];
                    }
                }
                for (int i= 0; i<medicineArray.count; i++) {
                    if ([[medDicThree objectForKey:@"medname"] isEqualToString:medicineArray[i]]) {
                        thirdWeekButton.backgroundColor = colorArray[(i%10)];
                    }
                }
            }
            
            firstWidth = [NSNumber numberWithInt:(25+(int)firstWeekButton.titleLabel.text.length*5)];
            secondWidth = [NSNumber numberWithInt:(25+(int)secondWeekButton.titleLabel.text.length*5)];
            thirdWidth = [NSNumber numberWithInt:(25+(int)thirdWeekButton.titleLabel.text.length*5)];
            
            [firstWeekButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(@7.5);
                make.width.equalTo(firstWidth);
                make.centerY.mas_equalTo(cell.mas_centerY);
            }];
            [secondWeekButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(firstWeekButton.mas_right).with.offset(5);
                make.width.equalTo(secondWidth);
                make.centerY.mas_equalTo(cell.mas_centerY);
            }];
            [thirdWeekButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(secondWeekButton.mas_right).with.offset(5);
                make.width.equalTo(thirdWidth);
                make.centerY.mas_equalTo(cell.mas_centerY);
            }];
            [pointLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(thirdWeekButton.mas_right).with.offset(5);
                make.width.equalTo(@30);
                make.height.equalTo(@20);
                make.top.equalTo(@7);
            }];
        }else{
            UILabel *contentLabel = [[UILabel alloc]init];
            contentLabel.tag = 1;
            NSDictionary *tempValues = [lineDetailDic objectForKey:@"values"];
            NSNumber *key;
            if (customizedIdsTempOrder.count >tableView.tag - 100 -1 ) {
                key = customizedIdsTempOrder[tableView.tag -100-1];
            }
            NSDictionary *finalValues = [tempValues objectForKey:key];
            if ([finalValues objectForKey:@"value"] == nil) {
                contentLabel.text = @"-";
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                contentLabel.textColor = [UIColor colorWithRed:80.0/255.0 green:80.0/255.0 blue:80.0/255.0 alpha:1.0];
            }else{
#warning 以后要尽量避免在cell里使用stringformat提升效率
                if ([[finalValues objectForKey:@"type"] intValue] != 0) {
                    if ([[finalValues objectForKey:@"value"]intValue] == 1) {
                        contentLabel.text = NSLocalizedString(@"阳（+）", @"");
                        contentLabel.textColor = [UIColor redColor];
                    }else{
                        contentLabel.text = NSLocalizedString(@"阴（-）", @"");
                        contentLabel.textColor = [UIColor colorWithRed:80.0/255.0 green:80.0/255.0 blue:80.0/255.0 alpha:1.0];
                    }
                }else{
                    if ([[finalValues objectForKey:@"calmethod"]intValue] != 0) {
                        contentLabel.text = [NSString stringWithFormat:@"%g %@",[[finalValues objectForKey:@"value"] doubleValue],[finalValues objectForKey:@"unit"]];
                    }else{
                        contentLabel.text = [NSString stringWithFormat:@"%@ %@",[finalValues objectForKey:@"value"],[finalValues objectForKey:@"unit"]];
                    }
                    float max = [[finalValues objectForKey:@"upperlimit"] floatValue];
                    float min = [[finalValues objectForKey:@"lowerlimit"] floatValue];
                    if ([[finalValues objectForKey:@"value"] floatValue] > min && [[finalValues objectForKey:@"value"] floatValue] < max) {
                        contentLabel.textColor = [UIColor colorWithRed:80.0/255.0 green:80.0/255.0 blue:80.0/255.0 alpha:1.0];
                    }else{
                        contentLabel.textColor = [UIColor redColor];
                    }
                }
            }
            contentLabel.textAlignment = NSTextAlignmentRight;
            contentLabel.font = [UIFont systemFontOfSize:14.0];
            [cell addSubview:contentLabel];
            [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(@5);
                make.right.equalTo(@-5);
                make.height.equalTo(@30);
                make.centerY.mas_equalTo(cell.mas_centerY);
            }];
        }
        if (indexPath.row%2 == 0) {
            cell.backgroundColor = [UIColor whiteColor];
        }else{
            cell.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:248.0/255.0 blue:248.0/255.0 alpha:1.0];
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击了第几个表===%ld，点击了第几列====%ld",(long)tableView.tag,(long)indexPath.row);
    if (tableView.tag == 555) {
        if ([[ocrDetailValueArray[indexPath.row] objectForKey:@"ltrList"][0] objectForKey:@"type"] != [NSNull null]) {
            if ([[[ocrDetailValueArray[indexPath.row] objectForKey:@"ltrList"][0] objectForKey:@"type"] intValue] == 1) {
                UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                DetailImageOcrViewController *div = [main instantiateViewControllerWithIdentifier:@"detailocrimage"];
                NSString *urlString = [[[ocrDetailValueArray[indexPath.row] objectForKey:@"ltrList"][0] objectForKey:@"picsInfo"][0] objectForKey:@"pic"];;
                NSMutableDictionary *dic = [ocrDetailValueArray[indexPath.row] objectForKey:@"ltrList"][0];
                div.showImageUrl = [NSString stringWithFormat:@"http://yizhenimg.augbase.com/origin/%@",urlString];
                div.detailDic = dic;
                div.ResultOrING = YES;
                div.OcrTextViewController = self;
                [self.navigationController pushViewController:div animated:YES];
            }
        }
    }else if (tableView.tag != 3) {
        tableTag = tableView.tag;
        NSDictionary *lineDetailDic;
        if (ocrDetailTempValueArray.count > 0) {
            lineDetailDic = ocrDetailTempValueArray[indexPath.row];
        }
        NSDictionary *tempValues = [lineDetailDic objectForKey:@"values"];
        NSNumber *key;
        if (customizedIdsTempOrder.count >tableView.tag - 100 -1 ) {
            key = customizedIdsTempOrder[tableView.tag -100-1];
        }
        NSDictionary *finalValues = [tempValues objectForKey:key];
        if ([finalValues objectForKey:@"value"] == nil&&tableView.tag != 100) {
            
        }else{
            [self popSpringAnimationOut:bottomMessView];
        }
    }
    if (tableView.tag == 100) {
        [bottomMessView viewWithTag:123].hidden = YES;
        [bottomButton setTitle:NSLocalizedString(@"用药记录", @"") forState:UIControlStateNormal];
    }else if(tableView.tag != 3){
        [bottomMessView viewWithTag:123].hidden = NO;
        [bottomButton setTitle:NSLocalizedString(@"对应化验单", @"") forState:UIControlStateNormal];
    }else{
        
    }
    if (tableView.tag != 3) {
        tableIndexRow = indexPath.row;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)weekButtonClick:(UIButton *)sender{
    tableTag = 100;
    tableIndexRow = sender.tag;
    [bottomMessView viewWithTag:123].hidden = YES;
    [self popSpringAnimationOut:bottomMessView];
    [bottomButton setTitle:NSLocalizedString(@"用药记录", @"") forState:UIControlStateNormal];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isKindOfClass:[UITableView class]]&&scrollView.tag != 3) {
        _nameTable.contentOffset = scrollView.contentOffset;
#warning 改成动态加载tableview之后需要改变同步运动方式,主要的卡吨集中在这里
        for (UIView *temp in [_resultScroller subviews]) {
            if ([temp isKindOfClass:[UITableView class]]) {
                ((UITableView*)temp).contentOffset = scrollView.contentOffset;
            }
        }
    }
    else if(scrollView == _titleScroller||scrollView == _resultScroller){
        if (scrollView == _titleScroller) {
            _resultScroller.contentOffset = CGPointMake(scrollView.contentOffset.x, _resultScroller.contentOffset.y);
        }else{
            _titleScroller.contentOffset = CGPointMake(scrollView.contentOffset.x, _titleScroller.contentOffset.y);// scrollView.contentOffset;
        }
    }
}

#pragma 有滚动的时候滚动完毕之后触发delegate
-(void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView
{
    if(scrollView == _titleScroller||scrollView == _resultScroller){
        if ((int)(scrollView.contentOffset.x) % 120 !=0) {
            int tempNumber = (int)(scrollView.contentOffset.x-240)/120+1;
            //设置了_titlescroller和resultscroller一样的offset，所以此处只能设置一次animate，否则出错
            //            [_titleScroller setContentOffset:scrollView.contentOffset animated:YES];
            if (tempNumber<7&&tempNumber>1) {
                [_resultScroller setContentOffset:CGPointMake(240+tempNumber*120, scrollView.contentOffset.y) animated:YES];
            }
        }
    }
//    flushResult = YES;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma 返回函数
-(IBAction)goBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setupView{
    _nameTable.delegate = self;
    _nameTable.dataSource = self;
    pageNumber = (int)(ViewWidth - 120)/120+1;
    //初始化两个scrollerview
    _titleScroller = [[UIScrollView alloc]initWithFrame:CGRectMake(100, 0, ViewWidth-100, 50)];
    _titleScroller.delegate = self;
    _titleScroller.backgroundColor = [UIColor blackColor];
    _titleScroller.scrollEnabled = YES;
    _resultScroller = [[UIScrollView alloc]initWithFrame:CGRectMake(100, 50, ViewWidth-100, ViewHeight-50-49)];
    _resultScroller.backgroundColor = grayBackgroundLightColor;
    _resultScroller.scrollEnabled = YES;
    _resultScroller.delegate = self;
    [self.view addSubview:_titleScroller];
    [self.view addSubview:_resultScroller];
    
    _firstTitleButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 190, 50)];
    [_titleScroller addSubview:_firstTitleButton];
    [_firstTitleButton setTitle:NSLocalizedString(@"用药周期", @"") forState:UIControlStateNormal];
    _firstTitleButton.backgroundColor = [UIColor blackColor];
    _secondTitleButton = [[UIButton alloc]initWithFrame:CGRectMake(_firstTitleButton.frame.origin.x+_firstTitleButton.bounds.size.width, 0, 50, 50)];
    [_secondTitleButton setTitle:NSLocalizedString(@"B超", @"") forState:UIControlStateNormal];
    _secondTitleButton.backgroundColor = [UIColor blackColor];
    _firstTitleButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    _secondTitleButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [_titleScroller addSubview:_secondTitleButton];
    
    _firstResultTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 190, ViewHeight-50-49)];
    _firstResultTable.delegate = self;
    _firstResultTable.dataSource = self;
    _firstResultTable.tag = 100;
    _firstResultTable.showsVerticalScrollIndicator = NO;
    _firstResultTable.separatorStyle = UITableViewCellSelectionStyleNone;
    [_resultScroller addSubview:_firstResultTable];
    
    bChaoTable = [[UITableView alloc]initWithFrame:CGRectMake(_firstResultTable.frame.origin.x+_firstResultTable.bounds.size.width, 0, 50, ViewHeight-50-49)];
    bChaoTable.dataSource = self;
    bChaoTable.delegate = self;
    bChaoTable.tag = 555;
    bChaoTable.showsVerticalScrollIndicator = NO;
    bChaoTable.separatorStyle = UITableViewCellSelectionStyleNone;
    [_resultScroller addSubview:bChaoTable];
    
    
    
    bottomArray = [@[NSLocalizedString(@"指标排序", @""),NSLocalizedString(@"分享表格", @"")]mutableCopy];
    //底部工具条
    UIView *bottomToolBar = [[UIView alloc]initWithFrame:CGRectMake(0, ViewHeight-49, ViewWidth, 49)];
    bottomToolBar.backgroundColor = [UIColor whiteColor];
    firstButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, ViewWidth/2, 49)];
    secondButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, ViewWidth/2, 49)];
    
    firstButton.center = CGPointMake(ViewWidth/(2*[bottomArray count])*1, 24.5);
    firstButton.backgroundColor = themeColor;
    secondButton.center = CGPointMake(ViewWidth/(2*[bottomArray count])*3, 24.5);
    secondButton.backgroundColor = themeColor;
    
    [firstButton setTitle:bottomArray[0] forState:UIControlStateNormal];
    firstButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    firstButton.titleEdgeInsets = UIEdgeInsetsMake(0,15, 0, 0);
    [firstButton setImage:[UIImage imageNamed:@"sequence"] forState:UIControlStateNormal];
    [secondButton setTitle:bottomArray[1] forState:UIControlStateNormal];
    [secondButton setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    secondButton.titleEdgeInsets = UIEdgeInsetsMake(0,15, 0, 0);
    secondButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    
    [bottomToolBar addSubview:firstButton];
    [bottomToolBar addSubview:secondButton];
    [self.view addSubview:bottomToolBar];
    
    [firstButton addTarget:self action:@selector(orderResults:) forControlEvents:UIControlEventTouchUpInside];
    [secondButton addTarget:self action:@selector(shareResults:) forControlEvents:UIControlEventTouchUpInside];
    
    [self setUpBottomTable];
    [self setUpBottomRightView];
}

-(void)setUpBottomTable{
    bottomMessView = [[UIView alloc]initWithFrame:CGRectMake(0, ViewHeight, ViewWidth, 350)];
    bottomMessView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomMessView];
    
    UIButton *cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    cancelButton.center = CGPointMake(30, 23);
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"closed"] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelBottomView:) forControlEvents:UIControlEventTouchUpInside];
    [bottomMessView addSubview:cancelButton];
    bottomTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    bottomTitleLabel.center = CGPointMake(bottomMessView.center.x,23);
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"userSystemVersion"] floatValue]>8.0) {
        bottomTitleLabel.font = [UIFont systemFontOfSize:17.0 weight:2.0];
    }else{
        bottomTitleLabel.font = [UIFont systemFontOfSize:17.0];
    }
    bottomTitleLabel.textAlignment = NSTextAlignmentCenter;
    bottomTitleLabel.text = @"";
    [bottomMessView addSubview:bottomTitleLabel];
    UIButton *detailButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    detailButton.tag = 123;
    detailButton.center = CGPointMake(ViewWidth-30, 23);
    [detailButton setBackgroundImage:[UIImage imageNamed:@"detail"] forState:UIControlStateNormal];
    [detailButton addTarget:self action:@selector(showDetail:) forControlEvents:UIControlEventTouchUpInside];
    [bottomMessView addSubview:detailButton];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 44, ViewWidth, 1)];
    [bottomMessView addSubview:lineView];
    lineView.backgroundColor = lightGrayBackColor;
    
    bottomTable = [[UITableView alloc]init];
    bottomTable.delegate = self;
    bottomTable.dataSource = self;
    bottomTable.separatorColor = lightGrayBackColor;
    bottomTable.tag = 3;
    bottomTable.showsVerticalScrollIndicator = NO;
    bottomTable.tableFooterView = [[UIView alloc]init];
    [bottomMessView addSubview:bottomTable];
    
    bottomButton = [[UIButton alloc]init];
    [bottomButton setTitle:NSLocalizedString(@"去看看", @"") forState:UIControlStateNormal];
    [bottomButton setTitleColor:themeColor forState:UIControlStateNormal];
    [bottomButton addTarget:self action:@selector(gotoOtherView:) forControlEvents:UIControlEventTouchUpInside];
    bottomButton.layer.borderColor = themeColor.CGColor;
    bottomButton.layer.borderWidth = 1.0;
    [bottomButton viewWithRadis:10.0];
    
    [bottomMessView addSubview:bottomButton];
    [bottomMessView addSubview:cancelButton];
    
    [bottomTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(@0);
        make.top.equalTo(@45);
        make.bottom.equalTo(@-80);
    }];
    [bottomButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.right.equalTo(@-20);
        make.height.equalTo(@45);
        make.bottom.equalTo(@-17);
    }];
}

-(void)setUpBottomRightView{
    bottomRightView = [[UIView alloc]initWithFrame:CGRectMake(ViewWidth, ViewHeight-350, ViewWidth, 350)];
    bottomRightView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomRightView];
    
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    backButton.center = CGPointMake(30, 23);
    [backButton setBackgroundImage:[UIImage imageNamed:@"back3"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backBottomRightView:) forControlEvents:UIControlEventTouchUpInside];
    [bottomRightView addSubview:backButton];
    bottomRightLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    bottomRightLabel.center = CGPointMake(bottomMessView.center.x,23);
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"userSystemVersion"] floatValue]>8.0) {
        bottomRightLabel.font = [UIFont systemFontOfSize:17.0 weight:2.0];
    }else{
        bottomRightLabel.font = [UIFont systemFontOfSize:17.0];
    }
    bottomRightLabel.textAlignment = NSTextAlignmentCenter;
    bottomRightLabel.text = @"";
    [bottomRightView addSubview:bottomRightLabel];
    
    detailTextView = [[UITextView alloc]init];
    detailTextView.text = @"";
    detailTextView.scrollEnabled = YES;
    detailTextView.layoutManager.allowsNonContiguousLayout = NO;
    detailTextView.editable = NO;
    detailTextView.font = [UIFont systemFontOfSize:15.0];
    
    [bottomRightView addSubview:detailTextView];
    [detailTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@45);
        make.left.equalTo(@10);
        make.right.bottom.equalTo(@-10);
    }];
}

-(void)cancelShareAction:(UIButton *)sender{
    [self popSpringAnimationHidden:shareView];
}

-(void)setupData{
    [[SetupView ShareInstance]showHUD:self Title:NSLocalizedString(@"加载中", @"")];
    ocrResultIndex = 0;
    flushResult = YES;
    titleArray = [NSMutableArray array];
    showNameArray = [NSMutableArray array];
    ocrDetailValueArray = [NSMutableArray array];
    customizedIdsOrder = [NSMutableArray array];
    bottomMedicArray = [NSMutableArray array];
    colorArray = [NSMutableArray array];
    bottomValueArray = [@[NSLocalizedString(@"参考范围", @""),NSLocalizedString(@"指标数值", @""),NSLocalizedString(@"指标类别", @""),NSLocalizedString(@"检测医院", @"")]mutableCopy];
    tableIndexRow = 0;
    tableTag = 100;
    [colorArray addObject:[UIColor colorWithRed:255.0/255 green:210.0/255 blue:72.0/255 alpha:1.0]];
    [colorArray addObject:[UIColor colorWithRed:246.0/255 green:147.0/255 blue:111.0/255 alpha:1.0]];
    [colorArray addObject:[UIColor colorWithRed:242.0/255 green:111.0/255 blue:122.0/255 alpha:1.0]];
    [colorArray addObject:[UIColor colorWithRed:236.0/255 green:148.0/255 blue:191.0/255 alpha:1.0]];
    [colorArray addObject:[UIColor colorWithRed:161.0/255 green:138.0/255 blue:192.0/255 alpha:1.0]];
    [colorArray addObject:[UIColor colorWithRed:119.0/255 green:205.0/255 blue:214.0/255 alpha:1.0]];
    [colorArray addObject:[UIColor colorWithRed:64.0/255 green:188.0/255 blue:157.0/255 alpha:1.0]];
    [colorArray addObject:[UIColor colorWithRed:174.0/255 green:212.0/255 blue:117.0/255 alpha:1.0]];
    [colorArray addObject:[UIColor colorWithRed:127.0/255 green:197.0/255 blue:110.0/255 alpha:1.0]];
    [colorArray addObject:[UIColor colorWithRed:189.0/255 green:186.0/255 blue:50.0/255 alpha:1.0]];
    NSString *url;
    
    if (_isMine&&[[WriteFileSupport ShareInstance]isFileExist:yizhenMineTable]&&_newResNumber == 0) {
        
        picList = [[WriteFileSupport ShareInstance]readDictionary:yizhenMineTable FileName:yizhenindicator];
        medicineArray = [[WriteFileSupport ShareInstance]readArray:yizhenMineTable FileName:yizhenmedcine];
        NSArray *keysOrder = [[WriteFileSupport ShareInstance]readArray:yizhenMineTable FileName:yizhenkeysOrder];
        
        if (keysOrder.count == 0) {
            UIAlertView *showNoticeAlert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"您没有病历数据", @"") message:NSLocalizedString(@"请上传您的化验单",@"") delegate:self cancelButtonTitle:NSLocalizedString(@"确定", @"") otherButtonTitles:nil, nil];
            [showNoticeAlert show];
        }
        allCodeDetails = [[WriteFileSupport ShareInstance]readDictionary:yizhenMineTable FileName:yizhenallCodeDetails];
        
        if (_isReView) {
            customizedIdsOrder = _viewedTitleArray;
            titleArray = [NSMutableArray arrayWithArray:_viewedTimeArray];
            firstButton.hidden = YES;
            secondButton.hidden = YES;
            bottomButton.hidden = YES;
        }else{
            customizedIdsOrder = [[WriteFileSupport ShareInstance]readArray:yizhenMineTable FileName:yizhencustomizedIdsOrder];
            titleArray = [NSMutableArray arrayWithArray:keysOrder];
            firstButton.hidden = NO;
            secondButton.hidden = NO;
            bottomButton.hidden = NO;
        }
        for (int i = 0; i<keysOrder.count; i++) {
            NSString *temp = keysOrder[i];
            if ([picList objectForKey:temp] != nil) {
                NSDictionary *tempValueDic = [picList objectForKey:temp];
                [ocrDetailValueArray addObject:tempValueDic];
            }
        }
        ocrDetailTempValueArray = ocrDetailValueArray;
        for (int i = 0; i<customizedIdsOrder.count ; i++) {
            NSString *resultIndex = customizedIdsOrder[i];
            if ([allCodeDetails objectForKey:resultIndex] != nil) {
                [showNameArray addObject:[allCodeDetails objectForKey:resultIndex]];
            }
        }
        _titleScroller.contentSize = CGSizeMake(190+50+120*showNameArray.count, 50-20);
        _resultScroller.contentSize = CGSizeMake(190+50+120*showNameArray.count, ViewHeight-50-49-20);
        
        _thirdTitleButton = [[UIButton alloc]initWithFrame:CGRectMake(_secondTitleButton.frame.origin.x+_secondTitleButton.bounds.size.width, 0, 120, 50)];
        _thirdTitleButton.backgroundColor = [UIColor blackColor];
        _thirdTitleButton.tag = 901;
        _thirdTitleButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _thirdTitleButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [_titleScroller addSubview:_thirdTitleButton];
        for (int i = 101; i<100+customizedIdsOrder.count+1; i++) {
            UITableView *tempTable = [[UITableView alloc]initWithFrame:CGRectMake((120*(i - 100+1)), 0, 120, ViewHeight-50-49)];
            tempTable.delegate = self;
            tempTable.dataSource = self;
            tempTable.tag = i;
            tempTable.showsVerticalScrollIndicator = NO;
            tempTable.separatorStyle = UITableViewCellSelectionStyleNone;
            [_resultScroller addSubview:tempTable];
        }
        _secondResultTable = (UITableView *)[_resultScroller viewWithTag:101];
        _thirdsultTable = (UITableView *)[_resultScroller viewWithTag:102];
        
        for (int i = 1; i<showNameArray.count+1; i++) {
            NSDictionary *tempDic = showNameArray[i-1];
            UIButton *tempButton = [[UIButton alloc]initWithFrame:CGRectMake(190+50+i*120-120, 0, 120, 50)];
            [_titleScroller addSubview:tempButton];
            tempButton.tag = i+900;
            if (tempDic != nil && tempButton != nil) {
                [tempButton setTitle:[tempDic objectForKey:@"showname"] forState:UIControlStateNormal];
                tempButton.backgroundColor = [UIColor blackColor];
                tempButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
                tempButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
            }
        }
        showNameTempArray = showNameArray;
        customizedIdsTempOrder = customizedIdsOrder;
        
        [_nameTable reloadData];
        
        for (UIView *temp in [_resultScroller subviews]) {
            if ([temp isKindOfClass:[UITableView class]]) {
                [((UITableView*)temp) reloadData];
            }
        }
        [[SetupView ShareInstance]hideHUD];
    }else{
        if (_isMine) {
            url = [NSString stringWithFormat:@"%@v2/indicator/listall?uid=%@&token=%@",Baseurl,[[NSUserDefaults standardUserDefaults] objectForKey:@"userUID"],[[NSUserDefaults standardUserDefaults] objectForKey:@"userToken"]];
        }else{
            url = [NSString stringWithFormat:@"%@v2/indicator/listall?uid=%@&token=%@&userJId=%@",Baseurl,[[NSUserDefaults standardUserDefaults] objectForKey:@"userUID"],[[NSUserDefaults standardUserDefaults] objectForKey:@"userToken"],_personJID];
            firstButton.hidden = YES;
            secondButton.hidden = YES;
            bottomButton.hidden = YES;
        }
        NSLog(@"url===%@",url);
        [[HttpManager ShareInstance] AFNetGETSupport:url Parameters:nil SucessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            int res=[[source objectForKey:@"res"] intValue];
            if (res == 0) {
                //请求完成
                picList = [source objectForKey:@"indicator"];
                medicineArray = [source objectForKey:@"medcine"];
                NSArray *keysOrder = [source objectForKey:@"keysOrder"];
                
                if (keysOrder.count == 0) {
                    if (_isMine) {
                        UIAlertView *showNoticeAlert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"您没有病历数据", @"") message:NSLocalizedString(@"请上传您的化验单",@"") delegate:self cancelButtonTitle:NSLocalizedString(@"确定", @"") otherButtonTitles:nil, nil];
                        [showNoticeAlert show];
                    }else{
                        UIAlertView *showNoticeAlert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"TA没有病历数据", @"") message:NSLocalizedString(@"请提醒TA上传化验单",@"") delegate:self cancelButtonTitle:NSLocalizedString(@"确定", @"") otherButtonTitles:nil, nil];
                        [showNoticeAlert show];
                    }
                }
                allCodeDetails = [source objectForKey:@"allCodeDetails"];
                if (_isReView) {
                    customizedIdsOrder = _viewedTitleArray;
                    titleArray = [NSMutableArray arrayWithArray:_viewedTimeArray];
                    firstButton.hidden = YES;
                    secondButton.hidden = YES;
                    bottomButton.hidden = YES;
                }else{
                    customizedIdsOrder = [source objectForKey:@"customizedIdsOrder"];
                    titleArray = [NSMutableArray arrayWithArray:keysOrder];
                    if (_isMine) {
                        firstButton.hidden = NO;
                        secondButton.hidden = NO;
                        bottomButton.hidden = NO;
                    }
                }
                if (_isMine&&!_isReView) {
                    [[WriteFileSupport ShareInstance]writeDictionary:picList DirName:yizhenMineTable FileName:yizhenindicator];
                    [[WriteFileSupport ShareInstance]writeArray:keysOrder DirName:yizhenMineTable FileName:yizhenkeysOrder];
                    [[WriteFileSupport ShareInstance]writeArray:medicineArray DirName:yizhenMineTable FileName:yizhenmedcine];
                    [[WriteFileSupport ShareInstance]writeDictionary:allCodeDetails DirName:yizhenMineTable FileName:yizhenallCodeDetails];
                    [[WriteFileSupport ShareInstance]writeArray:customizedIdsOrder DirName:yizhenMineTable FileName:yizhencustomizedIdsOrder];
                }
                
                for (int i = 0; i<keysOrder.count; i++) {
                    NSString *temp = keysOrder[i];
                    if ([picList objectForKey:temp] != nil) {
                        NSDictionary *tempValueDic = [picList objectForKey:temp];
                        if (![[tempValueDic objectForKey:@"isViewedByMe"] boolValue]) {
                            if (changeStatus == nil) {
                                changeStatus = [[[tempValueDic objectForKey:@"ltrList"][0] objectForKey:@"id"] stringValue];
                            }else{
                                changeStatus = [NSString stringWithFormat:@"%@,%@",changeStatus,[[[tempValueDic objectForKey:@"ltrList"][0] objectForKey:@"id"] stringValue]];
                            }
                            NSString *changeStatusUrl = [NSString stringWithFormat:@"%@v2/indicator/viewedStatus?uid=%@&token=%@&isDoctor=false&ltrIds=%@",Baseurl,[[NSUserDefaults standardUserDefaults] objectForKey:@"userUID"],[[NSUserDefaults standardUserDefaults] objectForKey:@"userToken"],changeStatus];
                            NSLog(@"changestatusulr===%@",changeStatusUrl);
                            [[HttpManager ShareInstance]AFNetPOSTNobodySupport:changeStatusUrl Parameters:nil SucessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
                                NSDictionary *source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                                int res=[[source objectForKey:@"res"] intValue];
                                NSLog(@"修改res===%d",res);
                                if (res == 0) {
                                    NSLog(@"修改观察状态成功");
                                }
                            } FailedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
                                
                            }];
                        }
                        [ocrDetailValueArray addObject:tempValueDic];
                    }
                }
                ocrDetailTempValueArray = ocrDetailValueArray;
                for (int i = 0; i<customizedIdsOrder.count ; i++) {
                    NSString *resultIndex = customizedIdsOrder[i];
                    if ([allCodeDetails objectForKey:resultIndex] != nil) {
                        [showNameArray addObject:[allCodeDetails objectForKey:resultIndex]];
                    }
                }
                _titleScroller.contentSize = CGSizeMake(190+50+120*showNameArray.count, 50-20);
                _resultScroller.contentSize = CGSizeMake(190+50+120*showNameArray.count, ViewHeight-50-49-20);
                
                _thirdTitleButton = [[UIButton alloc]initWithFrame:CGRectMake(_secondTitleButton.frame.origin.x+_secondTitleButton.bounds.size.width, 0, 120, 50)];
                _thirdTitleButton.backgroundColor = [UIColor blackColor];
                _thirdTitleButton.tag = 901;
                _thirdTitleButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
                _thirdTitleButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
                [_titleScroller addSubview:_thirdTitleButton];
                for (int i = 101; i<100+customizedIdsOrder.count+1; i++) {
                    UITableView *tempTable = [[UITableView alloc]initWithFrame:CGRectMake((120*(i - 100+1)), 0, 120, ViewHeight-50-49)];
                    tempTable.delegate = self;
                    tempTable.dataSource = self;
                    tempTable.tag = i;
                    tempTable.showsVerticalScrollIndicator = NO;
                    tempTable.separatorStyle = UITableViewCellSelectionStyleNone;
                    [_resultScroller addSubview:tempTable];
                }
                _secondResultTable = (UITableView *)[_resultScroller viewWithTag:101];
                _thirdsultTable = (UITableView *)[_resultScroller viewWithTag:102];
                
                for (int i = 1; i<showNameArray.count+1; i++) {
                    NSDictionary *tempDic = showNameArray[i-1];
                    UIButton *tempButton = [[UIButton alloc]initWithFrame:CGRectMake(190+50+i*120-120, 0, 120, 50)];
                    [_titleScroller addSubview:tempButton];
                    tempButton.tag = i+900;
                    if (tempDic != nil && tempButton != nil) {
                        [tempButton setTitle:[tempDic objectForKey:@"showname"] forState:UIControlStateNormal];
                        tempButton.backgroundColor = [UIColor blackColor];
                        tempButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
                        tempButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
                    }
                }
                showNameTempArray = showNameArray;
                customizedIdsTempOrder = customizedIdsOrder;
                
                [_nameTable reloadData];
                
                for (UIView *temp in [_resultScroller subviews]) {
                    if ([temp isKindOfClass:[UITableView class]]) {
                        [((UITableView*)temp) reloadData];
                    }
                }
                [[SetupView ShareInstance]hideHUD];
            }else if (res == 49){
                if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"userWeChat"] boolValue]) {
                    NSString *thirdPartyUrl = [NSString stringWithFormat:@"%@v2/user/login/thirdPartyAccount?token=%@&uuid=%@&third_party_type=%d",Baseurl,[[NSUserDefaults standardUserDefaults] objectForKey:@"userWeChatToken"],[[NSUserDefaults standardUserDefaults] objectForKey:@"userWeChatUID"],0];
                    [[HttpManager ShareInstance]AFNetPOSTNobodySupport:thirdPartyUrl Parameters:nil SucessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
                        NSDictionary *source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                        int res=[[source objectForKey:@"res"] intValue];
                        NSLog(@"device activitation source=%@,res=====%d",source,res);
                        if (res == 0) {
                            [[NSUserDefaults standardUserDefaults] setObject:[source objectForKey:@"token"] forKey:@"userToken"];
                            NSString *url;
                            if (_isMine) {
                                url = [NSString stringWithFormat:@"%@v2/indicator/listall?uid=%@&token=%@",Baseurl,[[NSUserDefaults standardUserDefaults] objectForKey:@"userUID"],[[NSUserDefaults standardUserDefaults] objectForKey:@"userToken"]];
                            }else{
                                url = [NSString stringWithFormat:@"%@v2/indicator/listall?uid=%@&token=%@&userJId=%@",Baseurl,[[NSUserDefaults standardUserDefaults] objectForKey:@"userUID"],[[NSUserDefaults standardUserDefaults] objectForKey:@"userToken"],_personJID];
                            }
                            NSLog(@"url===%@",url);
                            [[HttpManager ShareInstance] AFNetGETSupport:url Parameters:nil SucessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
                                NSDictionary *source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                                int res=[[source objectForKey:@"res"] intValue];
                                if (res == 0) {
                                    //请求完成
                                    picList = [source objectForKey:@"indicator"];
                                    medicineArray = [source objectForKey:@"medcine"];
                                    NSArray *keysOrder = [source objectForKey:@"keysOrder"];
                                    if (keysOrder.count == 0) {
                                        if (_isMine) {
                                            UIAlertView *showNoticeAlert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"您没有病历数据", @"") message:NSLocalizedString(@"请上传您的化验单",@"") delegate:self cancelButtonTitle:NSLocalizedString(@"确定", @"") otherButtonTitles:nil, nil];
                                            [showNoticeAlert show];
                                        }else{
                                            UIAlertView *showNoticeAlert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"TA没有病历数据", @"") message:NSLocalizedString(@"请提醒TA上传化验单",@"") delegate:self cancelButtonTitle:NSLocalizedString(@"确定", @"") otherButtonTitles:nil, nil];
                                            [showNoticeAlert show];
                                        }
                                    }
                                    allCodeDetails = [source objectForKey:@"allCodeDetails"];
                                    if (_isReView) {
                                        customizedIdsOrder = _viewedTitleArray;
                                        titleArray = [NSMutableArray arrayWithArray:_viewedTimeArray];
                                        firstButton.hidden = YES;
                                        secondButton.hidden = YES;
                                        bottomButton.hidden = YES;
                                    }else{
                                        customizedIdsOrder = [source objectForKey:@"customizedIdsOrder"];
                                        titleArray = [NSMutableArray arrayWithArray:keysOrder];
                                        firstButton.hidden = NO;
                                        secondButton.hidden = NO;
                                        bottomButton.hidden = NO;
                                    }
                                    if (!_isMine) {
                                        firstButton.hidden = YES;
                                        secondButton.hidden = YES;
                                        bottomButton.hidden = YES;
                                    }
                                    [[WriteFileSupport ShareInstance]writeDictionary:picList DirName:yizhenMineTable FileName:yizhenindicator];
                                    [[WriteFileSupport ShareInstance]writeArray:keysOrder DirName:yizhenMineTable FileName:yizhenkeysOrder];
                                    [[WriteFileSupport ShareInstance]writeArray:medicineArray DirName:yizhenMineTable FileName:yizhenmedcine];
                                    [[WriteFileSupport ShareInstance]writeDictionary:allCodeDetails DirName:yizhenMineTable FileName:yizhenallCodeDetails];
                                    [[WriteFileSupport ShareInstance]writeArray:customizedIdsOrder DirName:yizhenMineTable FileName:yizhencustomizedIdsOrder];
                                    
                                    for (int i = 0; i<keysOrder.count; i++) {
                                        NSString *temp = keysOrder[i];
                                        if ([picList objectForKey:temp] != nil) {
                                            NSDictionary *tempValueDic = [picList objectForKey:temp];
                                            if (![[tempValueDic objectForKey:@"isViewedByMe"] boolValue]) {
                                                if (changeStatus == nil) {
                                                    changeStatus = [[[tempValueDic objectForKey:@"ltrList"][0] objectForKey:@"id"] stringValue];
                                                }else{
                                                    changeStatus = [NSString stringWithFormat:@"%@,%@",changeStatus,[[[tempValueDic objectForKey:@"ltrList"][0] objectForKey:@"id"] stringValue]];
                                                }
                                                NSString *changeStatusUrl = [NSString stringWithFormat:@"%@v2/indicator/viewedStatus?uid=%@&token=%@&isDoctor=false&ltrIds=%@",Baseurl,[[NSUserDefaults standardUserDefaults] objectForKey:@"userUID"],[[NSUserDefaults standardUserDefaults] objectForKey:@"userToken"],changeStatus];
                                                NSLog(@"changestatusulr===%@",changeStatusUrl);
                                                [[HttpManager ShareInstance]AFNetPOSTNobodySupport:changeStatusUrl Parameters:nil SucessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                    NSDictionary *source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                                                    int res=[[source objectForKey:@"res"] intValue];
                                                    NSLog(@"修改res===%d",res);
                                                    if (res == 0) {
                                                        NSLog(@"修改观察状态成功");
                                                    }
                                                } FailedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                    
                                                }];
                                            }
                                            [ocrDetailValueArray addObject:tempValueDic];
                                        }
                                    }
                                    ocrDetailTempValueArray = ocrDetailValueArray;
                                    for (int i = 0; i<customizedIdsOrder.count ; i++) {
                                        NSString *resultIndex = customizedIdsOrder[i];
                                        if ([allCodeDetails objectForKey:resultIndex] != nil) {
                                            [showNameArray addObject:[allCodeDetails objectForKey:resultIndex]];
                                        }
                                    }
                                    
                                    for (int i= 0; i<customizedIdsOrder.count; i++) {
                                        
                                    }
                                    _titleScroller.contentSize = CGSizeMake(190+50+120*showNameArray.count, 50-20);
                                    _resultScroller.contentSize = CGSizeMake(190+50+120*showNameArray.count, ViewHeight-50-49-20);
                                    
                                    _thirdTitleButton = [[UIButton alloc]initWithFrame:CGRectMake(_secondTitleButton.frame.origin.x+_secondTitleButton.bounds.size.width, 0, 120, 50)];
                                    _thirdTitleButton.backgroundColor = [UIColor blackColor];
                                    _thirdTitleButton.tag = 901;
                                    _thirdTitleButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
                                    _thirdTitleButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
                                    [_titleScroller addSubview:_thirdTitleButton];
                                    for (int i = 101; i<100+customizedIdsOrder.count+1; i++) {
                                        UITableView *tempTable = [[UITableView alloc]initWithFrame:CGRectMake((120*(i - 100+1)), 0, 120, ViewHeight-50-49)];
                                        tempTable.delegate = self;
                                        tempTable.dataSource = self;
                                        tempTable.tag = i;
                                        tempTable.showsVerticalScrollIndicator = NO;
                                        tempTable.separatorStyle = UITableViewCellSelectionStyleNone;
                                        [_resultScroller addSubview:tempTable];
                                    }
                                    _secondResultTable = (UITableView *)[_resultScroller viewWithTag:101];
                                    _thirdsultTable = (UITableView *)[_resultScroller viewWithTag:102];
                                    
                                    for (int i = 1; i<showNameArray.count+1; i++) {
                                        NSDictionary *tempDic = showNameArray[i-1];
                                        UIButton *tempButton = [[UIButton alloc]initWithFrame:CGRectMake(190+50+i*120-120, 0, 120, 50)];
                                        [_titleScroller addSubview:tempButton];
                                        tempButton.tag = i+900;
                                        if (tempDic != nil && tempButton != nil) {
                                            [tempButton setTitle:[tempDic objectForKey:@"showname"] forState:UIControlStateNormal];
                                            tempButton.backgroundColor = [UIColor blackColor];
                                            tempButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
                                            tempButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
                                        }
                                    }
                                    showNameTempArray = showNameArray;
                                    customizedIdsTempOrder = customizedIdsOrder;
                                    
                                    [_nameTable reloadData];
                                    
                                    for (UIView *temp in [_resultScroller subviews]) {
                                        if ([temp isKindOfClass:[UITableView class]]) {
                                            [((UITableView*)temp) reloadData];
                                        }
                                    }
                                    [[SetupView ShareInstance]hideHUD];
                                }else{
                                    NSLog(@"web获取数据失败＝＝＝%d",res);
                                    [[SetupView ShareInstance]showAlertView:res Hud:nil ViewController:self];
                                    [[SetupView ShareInstance]hideHUD];
                                }
                            }  FailedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
                                NSLog(@"WEB端登录失败：%@",error);
                                [[SetupView ShareInstance]hideHUD];
                            }];
                            
                        }else{
                            [[SetupView ShareInstance]hideHUD];
                            [[SetupView ShareInstance]showAlertView:res Hud:nil ViewController:self];
                        }
                    } FailedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
                        [[SetupView ShareInstance]hideHUD];
                        [[SetupView ShareInstance]showAlertView:NSLocalizedString(@"请检查您的网络和定位是否打开", @"") Title:NSLocalizedString(@"不能获取附近战友", @"") ViewController:self];
                    }];
                }else{
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    NSString *url = [NSString stringWithFormat:@"%@v2/user/login",Baseurl];
                    NSMutableDictionary *loginDic = [NSMutableDictionary dictionary];
                    [loginDic setValue:[defaults objectForKey:@"userName"] forKey:@"username"];
                    [loginDic setValue:[defaults objectForKey:@"userPassword"] forKey:@"password"];
                    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
                    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
                    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
                    [manager POST:url parameters:loginDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        NSDictionary *source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                        int res=[[source objectForKey:@"res"] intValue];
                        if (res==0) {
                            [defaults setObject:[source objectForKey:@"token"] forKey:@"userToken"];
                            
                            NSString *url;
                            if (_isMine) {
                                url = [NSString stringWithFormat:@"%@v2/indicator/listall?uid=%@&token=%@",Baseurl,[[NSUserDefaults standardUserDefaults] objectForKey:@"userUID"],[[NSUserDefaults standardUserDefaults] objectForKey:@"userToken"]];
                            }else{
                                url = [NSString stringWithFormat:@"%@v2/indicator/listall?uid=%@&token=%@&userJId=%@",Baseurl,[[NSUserDefaults standardUserDefaults] objectForKey:@"userUID"],[[NSUserDefaults standardUserDefaults] objectForKey:@"userToken"],_personJID];
                            }
                            NSLog(@"url===%@",url);
                            [[HttpManager ShareInstance] AFNetGETSupport:url Parameters:nil SucessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
                                NSDictionary *source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                                int res=[[source objectForKey:@"res"] intValue];
                                if (res == 0) {
                                    //请求完成
                                    picList = [source objectForKey:@"indicator"];
                                    medicineArray = [source objectForKey:@"medcine"];
                                    NSArray *keysOrder = [source objectForKey:@"keysOrder"];
                                    if (keysOrder.count == 0) {
                                        if (_isMine) {
                                            UIAlertView *showNoticeAlert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"您没有病历数据", @"") message:NSLocalizedString(@"请上传您的化验单",@"") delegate:self cancelButtonTitle:NSLocalizedString(@"确定", @"") otherButtonTitles:nil, nil];
                                            [showNoticeAlert show];
                                        }else{
                                            UIAlertView *showNoticeAlert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"TA没有病历数据", @"") message:NSLocalizedString(@"请提醒TA上传化验单",@"") delegate:self cancelButtonTitle:NSLocalizedString(@"确定", @"") otherButtonTitles:nil, nil];
                                            [showNoticeAlert show];
                                        }
                                    }
                                    allCodeDetails = [source objectForKey:@"allCodeDetails"];
                                    if (_isReView) {
                                        customizedIdsOrder = _viewedTitleArray;
                                        titleArray = [NSMutableArray arrayWithArray:_viewedTimeArray];
                                        firstButton.hidden = YES;
                                        secondButton.hidden = YES;
                                        bottomButton.hidden = YES;
                                    }else{
                                        customizedIdsOrder = [source objectForKey:@"customizedIdsOrder"];
                                        titleArray = [NSMutableArray arrayWithArray:keysOrder];
                                        firstButton.hidden = NO;
                                        secondButton.hidden = NO;
                                        bottomButton.hidden = NO;
                                    }
                                    if (!_isMine) {
                                        firstButton.hidden = YES;
                                        secondButton.hidden = YES;
                                        bottomButton.hidden = YES;
                                    }
                                    for (int i = 0; i<keysOrder.count; i++) {
                                        NSString *temp = keysOrder[i];
                                        if ([picList objectForKey:temp] != nil) {
                                            NSDictionary *tempValueDic = [picList objectForKey:temp];
                                            if (![[tempValueDic objectForKey:@"isViewedByMe"] boolValue]) {
                                                if (changeStatus == nil) {
                                                    changeStatus = [[[tempValueDic objectForKey:@"ltrList"][0] objectForKey:@"id"] stringValue];
                                                }else{
                                                    changeStatus = [NSString stringWithFormat:@"%@,%@",changeStatus,[[[tempValueDic objectForKey:@"ltrList"][0] objectForKey:@"id"] stringValue]];
                                                }
                                                NSString *changeStatusUrl = [NSString stringWithFormat:@"%@v2/indicator/viewedStatus?uid=%@&token=%@&isDoctor=false&ltrIds=%@",Baseurl,[[NSUserDefaults standardUserDefaults] objectForKey:@"userUID"],[[NSUserDefaults standardUserDefaults] objectForKey:@"userToken"],changeStatus];
                                                NSLog(@"changestatusulr===%@",changeStatusUrl);
                                                [[HttpManager ShareInstance]AFNetPOSTNobodySupport:changeStatusUrl Parameters:nil SucessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                    NSDictionary *source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                                                    int res=[[source objectForKey:@"res"] intValue];
                                                    NSLog(@"修改res===%d",res);
                                                    if (res == 0) {
                                                        NSLog(@"修改观察状态成功");
                                                    }
                                                } FailedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                    
                                                }];
                                            }
                                            [ocrDetailValueArray addObject:tempValueDic];
                                        }
                                    }
                                    ocrDetailTempValueArray = ocrDetailValueArray;
                                    for (int i = 0; i<customizedIdsOrder.count ; i++) {
                                        NSString *resultIndex = customizedIdsOrder[i];
                                        if ([allCodeDetails objectForKey:resultIndex] != nil) {
                                            [showNameArray addObject:[allCodeDetails objectForKey:resultIndex]];
                                        }
                                    }
                                    
                                    for (int i= 0; i<customizedIdsOrder.count; i++) {
                                        
                                    }
                                    _titleScroller.contentSize = CGSizeMake(190+50+120*showNameArray.count, 50-20);
                                    _resultScroller.contentSize = CGSizeMake(190+50+120*showNameArray.count, ViewHeight-50-49-20);
                                    
                                    _thirdTitleButton = [[UIButton alloc]initWithFrame:CGRectMake(_secondTitleButton.frame.origin.x+_secondTitleButton.bounds.size.width, 0, 120, 50)];
                                    _thirdTitleButton.backgroundColor = [UIColor blackColor];
                                    _thirdTitleButton.tag = 901;
                                    _thirdTitleButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
                                    _thirdTitleButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
                                    [_titleScroller addSubview:_thirdTitleButton];
                                    for (int i = 101; i<100+customizedIdsOrder.count+1; i++) {
                                        UITableView *tempTable = [[UITableView alloc]initWithFrame:CGRectMake((120*(i - 100+1)), 0, 120, ViewHeight-50-49)];
                                        tempTable.delegate = self;
                                        tempTable.dataSource = self;
                                        tempTable.tag = i;
                                        tempTable.showsVerticalScrollIndicator = NO;
                                        tempTable.separatorStyle = UITableViewCellSelectionStyleNone;
                                        [_resultScroller addSubview:tempTable];
                                    }
                                    _secondResultTable = (UITableView *)[_resultScroller viewWithTag:101];
                                    _thirdsultTable = (UITableView *)[_resultScroller viewWithTag:102];
                                    
                                    for (int i = 1; i<showNameArray.count+1; i++) {
                                        NSDictionary *tempDic = showNameArray[i-1];
                                        UIButton *tempButton = [[UIButton alloc]initWithFrame:CGRectMake(190+50+i*120-120, 0, 120, 50)];
                                        [_titleScroller addSubview:tempButton];
                                        tempButton.tag = i+900;
                                        if (tempDic != nil && tempButton != nil) {
                                            [tempButton setTitle:[tempDic objectForKey:@"showname"] forState:UIControlStateNormal];
                                            tempButton.backgroundColor = [UIColor blackColor];
                                            tempButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
                                            tempButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
                                        }
                                    }
                                    showNameTempArray = showNameArray;
                                    customizedIdsTempOrder = customizedIdsOrder;
                                    
                                    [_nameTable reloadData];
                                    
                                    for (UIView *temp in [_resultScroller subviews]) {
                                        if ([temp isKindOfClass:[UITableView class]]) {
                                            [((UITableView*)temp) reloadData];
                                        }
                                    }
                                    [[SetupView ShareInstance]hideHUD];
                                }else{
                                    NSLog(@"web获取数据失败＝＝＝%d",res);
                                    [[SetupView ShareInstance]showAlertView:res Hud:nil ViewController:self];
                                    [[SetupView ShareInstance]hideHUD];
                                }
                            }  FailedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
                                NSLog(@"WEB端登录失败：%@",error);
                                [[SetupView ShareInstance]hideHUD];
                            }];
                            
                        }else{
                            [[SetupView ShareInstance]hideHUD];
                            [[SetupView ShareInstance]showAlertView:res Hud:nil ViewController:self];
                        }
                    }failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
                        [[SetupView ShareInstance]hideHUD];
                        [[SetupView ShareInstance]showAlertView:NSLocalizedString(@"请检查您的网络和定位是否打开", @"") Title:NSLocalizedString(@"不能获取附近战友", @"") ViewController:self];
                    }];
                }
            }else{
                NSLog(@"web获取数据失败＝＝＝%d",res);
                [[SetupView ShareInstance]showAlertView:res Hud:nil ViewController:self];
                [[SetupView ShareInstance]hideHUD];
            }
        }  FailedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"WEB端登录失败：%@",error);
            [[SetupView ShareInstance]hideHUD];
        }];
    }
}

#pragma 分享
- (void)shareAction{
    SetShareContentRootViewController *ssv = [[SetShareContentRootViewController alloc]init];
    ssv.titleDic = allCodeDetails;
    ssv.titleArray = customizedIdsOrder;
    ssv.timeArray = titleArray;
    [self.navigationController pushViewController:ssv animated:YES];
}

#pragma 底部view出现和隐藏
-(void)popOutShareView:(UIView *)targetView{
    visualEffectView = [[UIView alloc] init];
    
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapvisualEffectView:)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    [visualEffectView addGestureRecognizer:singleTapGestureRecognizer];
    visualEffectView.frame = self.view.bounds;
    visualEffectView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    
    [self.view insertSubview:visualEffectView belowSubview:bottomMessView];
    
    POPSpringAnimation *anim = [POPSpringAnimation animation];
    anim.property = [POPAnimatableProperty propertyWithName:kPOPViewFrame];
    anim.toValue = [NSValue valueWithCGRect:CGRectMake(0,ViewHeight-targetView.bounds.size.height,targetView.bounds.size.width,targetView.bounds.size.height)];
    anim.velocity = [NSValue valueWithCGRect:targetView.frame];
    anim.springBounciness = 5.0;
    anim.springSpeed = 10;
    [bottomTable reloadData];
    anim.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        if (finished) {
            
        }
    };
    
    [targetView pop_addAnimation:anim forKey:@"slider"];
}

-(void)popSpringAnimationOut:(UIView *)targetView{
    visualEffectView = [[UIView alloc] init];
    
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapvisualEffectView:)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    [visualEffectView addGestureRecognizer:singleTapGestureRecognizer];
    visualEffectView.frame = self.view.bounds;
    visualEffectView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    
    [self.view insertSubview:visualEffectView belowSubview:bottomMessView];
    
    POPSpringAnimation *anim = [POPSpringAnimation animation];
    anim.property = [POPAnimatableProperty propertyWithName:kPOPViewFrame];
    anim.toValue = [NSValue valueWithCGRect:CGRectMake(0,ViewHeight-targetView.bounds.size.height,targetView.bounds.size.width,targetView.bounds.size.height)];
    anim.velocity = [NSValue valueWithCGRect:targetView.frame];
    anim.springBounciness = 5.0;
    anim.springSpeed = 10;
    [bottomTable reloadData];
    anim.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        if (finished) {
            
        }
    };
    
    [targetView pop_addAnimation:anim forKey:@"slider"];
    
}

-(void)tapvisualEffectView:(UIView *)sender{
    [self popSpringAnimationHidden:bottomMessView];
    [self hideRightSpringAnimationHidden:bottomRightView];
}

-(void)popSpringAnimationHidden:(UIView *)targetView{
    if (visualEffectView != nil) {
        [visualEffectView removeFromSuperview];
    }
    tableTag = 100;
    tableIndexRow = 0;
    POPSpringAnimation *anim = [POPSpringAnimation animation];
    anim.property = [POPAnimatableProperty propertyWithName:kPOPViewFrame];
    anim.toValue = [NSValue valueWithCGRect:CGRectMake(0,ViewHeight,targetView.bounds.size.width,targetView.bounds.size.height)];
    anim.velocity = [NSValue valueWithCGRect:targetView.frame];
    anim.springBounciness = 5.0;
    anim.springSpeed = 10;
    
    anim.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        if (finished) {
            
        }
    };
    
    [targetView pop_addAnimation:anim forKey:@"slider"];
    
}

-(void)showRightSpringAnimationOut:(UIView *)targetView{
    bottomRightLabel.text = bottomTitleLabel.text;
    POPSpringAnimation *anim = [POPSpringAnimation animation];
    anim.property = [POPAnimatableProperty propertyWithName:kPOPViewFrame];
    anim.toValue = [NSValue valueWithCGRect:CGRectMake(0,ViewHeight-targetView.bounds.size.height,targetView.bounds.size.width,targetView.bounds.size.height)];
    anim.velocity = [NSValue valueWithCGRect:targetView.frame];
    anim.springBounciness = 5.0;
    anim.springSpeed = 10;
    
    anim.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        if (finished) {
            NSRange range = NSMakeRange(0, 1);
            [detailTextView scrollRangeToVisible:range];
        }
    };
    
    [targetView pop_addAnimation:anim forKey:@"slider"];
    
}

-(void)hideRightSpringAnimationHidden:(UIView *)targetView{
    POPSpringAnimation *anim = [POPSpringAnimation animation];
    anim.property = [POPAnimatableProperty propertyWithName:kPOPViewFrame];
    anim.toValue = [NSValue valueWithCGRect:CGRectMake(ViewWidth,ViewHeight-targetView.bounds.size.height,targetView.bounds.size.width,targetView.bounds.size.height)];
    anim.velocity = [NSValue valueWithCGRect:targetView.frame];
    anim.springBounciness = 5.0;
    anim.springSpeed = 10;
    
    anim.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        if (finished) {
            
        }
    };
    
    [targetView pop_addAnimation:anim forKey:@"slider"];
}

-(void)cancelBottomView:(UIButton *)sender{
    [bottomMessView viewWithTag:123].hidden = NO;
    [self popSpringAnimationHidden:bottomMessView];
    [self hideRightSpringAnimationHidden:bottomRightView];
}

-(void)backBottomRightView:(UIButton *)sender{
    [self hideRightSpringAnimationHidden:bottomRightView];
}

-(void)showDetail:(UIButton *)sender{
    [self showRightSpringAnimationOut:bottomRightView];
}

-(void)gotoOtherView:(UIButton *)sender{
    if (tableTag != 100) {
        UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        DetailImageOcrViewController *div = [main instantiateViewControllerWithIdentifier:@"detailocrimage"];
        
        NSString *urlString = [[[ocrDetailValueArray[tableIndexRow] objectForKey:@"ltrList"][0] objectForKey:@"picsInfo"][0] objectForKey:@"pic"];;
        NSMutableDictionary *dic = [ocrDetailValueArray[tableIndexRow] objectForKey:@"ltrList"][0];
        div.showImageUrl = [NSString stringWithFormat:@"http://yizhenimg.augbase.com/origin/%@",urlString];
        div.detailDic = dic;
        div.ResultOrING = YES;
        div.OcrTextViewController = self;
        [self.navigationController pushViewController:div animated:YES];
    }else{
        DrugHistroyViewController *dhv = [[DrugHistroyViewController alloc]init];
        dhv.OcrTextViewController = self;
        [self.navigationController pushViewController:dhv animated:YES];
    }
    [self popSpringAnimationHidden:bottomMessView];
}

-(void)shareResults:(UIButton *)sender{
    [self shareAction];
}

-(void)orderResults:(UIButton *)sender{
    OrderTextListViewController *otlv = [[OrderTextListViewController alloc]init];
    otlv.listArray = customizedIdsOrder;
    otlv.listName = allCodeDetails;
    [self.navigationController pushViewController:otlv animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [[UIApplication sharedApplication]setStatusBarHidden:NO];
    self.navigationController.navigationBarHidden = NO;
}

@end
