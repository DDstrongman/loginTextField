//
//  FriendDBItem.h
//  ResultContained
//
//  Created by 李胜书 on 15/8/3.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FriendDBItem : NSObject

@property (nonatomic,strong) NSString *friendJID;
@property (nonatomic,strong) NSString *friendName;
@property (nonatomic,strong) NSString *friendRealName;
@property (nonatomic,strong) NSString *friendImageUrl;
@property (nonatomic,strong) NSString *friendDescribe;

@property (nonatomic,strong) NSString *friendMedicineInfo;
@property (nonatomic,strong) NSString *friendMedicinePrivacySetting;
@property (nonatomic,strong) NSString *friendDisCurrentInfo;
@property (nonatomic,strong) NSString *friendDiseasePrivacySetting;

@property (nonatomic,strong) NSString *friendAge;
@property (nonatomic,strong) NSString *friendGender;
@property (nonatomic,strong) NSString *friendAddress;
@property (nonatomic,strong) NSString *friendSimilarity;
@property (nonatomic,strong) NSString *friendOnlineOrNot;//1，表示在线，0表示不在

@end
