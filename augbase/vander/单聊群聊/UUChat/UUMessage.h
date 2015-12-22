#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MessageType) {
    UUMessageTypeText     = 0 , // 文字
    UUMessageTypePicture  = 1 , // 图片
    UUMessageTypeVoice    = 2 ,  // 语音
    UUMessageTypeTable    = 3 ,  // 大表格
};


typedef NS_ENUM(NSInteger, MessageFrom) {
    UUMessageFromMe    = 0,   // 自己发的
    UUMessageFromOther = 1    // 别人发得
};


@interface UUMessage : NSObject

@property (nonatomic, copy) NSString *strIcon;
@property (nonatomic, copy) NSString *strId;
@property (nonatomic, copy) NSString *strTime;
@property (nonatomic, copy) NSString *strName;

@property (nonatomic, copy) NSString *strContent;

@property (nonatomic, copy) NSURL  *picture;

@property (nonatomic, copy) NSData   *voice;
@property (nonatomic, copy) NSString *strVoiceTime;

@property (nonatomic, copy) NSString *urlContent; //大表分享的url
@property (nonatomic, copy) NSString *urlTitle;   //大表分享的标题

@property (nonatomic, assign) MessageType type;
@property (nonatomic, assign) MessageFrom from;

@property (nonatomic, assign) BOOL showDateLabel;

@property (nonatomic,strong) UIViewController *rootNavC;//

- (void)setWithDict:(NSDictionary *)dict;

- (void)minuteOffSetStart:(NSString *)start end:(NSString *)end;

@end
