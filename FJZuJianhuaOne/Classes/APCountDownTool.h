//
//  APCountDownTool.h
//  AntPocket
//
//  Created by zxy on 2019/7/24.
//  Copyright © 2019 AntPocket. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

//static long long passSecond = 0;

@interface APCountDownTool : NSObject

/// 已过去的时间（秒）
@property(nonatomic, assign)long long passSecond;

/**
 倒计时
 @param time 总时间（s）
 */
- (void)countDownWithTime:(long long)time block:(void(^)(NSString * day, NSString *time, NSString * minute, NSString * second))block;

/**
 获取时长（秒）
 */
- (long long)getSecondBegTime: (NSString *)begTime endTime: (NSString *)endTime;

/**
 销毁定时器
 */
- (void)destoryTimer;


@end

NS_ASSUME_NONNULL_END
