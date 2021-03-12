//
//  APCountDownTool.m
//  AntPocket
//
//  Created by zxy on 2019/7/24.
//  Copyright © 2019 AntPocket. All rights reserved.
//

#import "APCountDownTool.h"

@interface APCountDownTool ()
@property (nonatomic, strong) dispatch_source_t timer;
@end

@implementation APCountDownTool

APCountDownTool *tool;

- (instancetype)init{
    if (self = [super init]) {
        self.passSecond = 0;
    }
    return  self;
}
- (long long)getSecondBegTime:(NSString *)begTime endTime:(NSString *)endTime {
    if ([begTime longLongValue] >= [endTime longLongValue]) {
        return 0;
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    NSDate* begDdate = [NSDate dateWithTimeIntervalSince1970:[begTime doubleValue]/1000.0];
//    NSString *dateString1 = [formatter stringFromDate:begDdate];
        
    NSDate *endDdate = [NSDate dateWithTimeIntervalSince1970:[endTime doubleValue]/1000.0];
//    NSString *dateString2 = [formatter stringFromDate:endDdate];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *cmps = [calendar components:unit fromDate:begDdate toDate:endDdate options:0];
    long long t = cmps.day * 24 * 3600 + cmps.hour * 3600 + cmps.minute * 60 + cmps.second;
    return t;
}

- (void)countDownWithTime:(long long)time block:(void(^)(NSString * day, NSString *time, NSString * minute, NSString * second))block{
    if (time <= 0) {
        block(@"0",@"0",@"0",@"0");
        return;
    }
    __block double countDownTime = time - self.passSecond;
    __block NSString *daysString;
    __block NSString *hoursString;
    __block NSString *minuteString;
    __block NSString *secondString;
    
    dispatch_queue_t queue = dispatch_queue_create("timer", DISPATCH_QUEUE_CONCURRENT);
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(self.timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(self.timer, ^{
        if (countDownTime <= 0) {
            dispatch_source_cancel(self.timer);
            self.timer = nil;
            dispatch_async(dispatch_get_main_queue(), ^{
                block(@"0",@"0",@"0",@"0");
            });
        }else{
            NSInteger days = countDownTime / (24 * 3600);
            NSInteger hours = (countDownTime - days * 24 * 3600) / 3600;
            NSInteger minute = (countDownTime - days * 24 * 3600 - hours * 3600) / 60;
            NSInteger second = countDownTime - days * 24 * 3600 - hours * 3600 - minute * 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                daysString = [NSString stringWithFormat:@"%zd",days];
                if (hours < 10) {
                    hoursString = [NSString stringWithFormat:@"0%zd",hours];
                }else{
                    hoursString = [NSString stringWithFormat:@"%zd",hours];
                }
                if (minute < 10) {
                    minuteString = [NSString stringWithFormat:@"0%zd",minute];
                }else{
                    minuteString = [NSString stringWithFormat:@"%zd",minute];
                }
                if (second < 10) {
                    secondString = [NSString stringWithFormat:@"0%zd",second];
                }else{
                    secondString = [NSString stringWithFormat:@"%zd",second];
                }
                if (days == 0 && hours == 0 && minute == 0 ) {//&& second == 0
                    [self destoryTimer];
                }
                block(daysString,hoursString,minuteString,secondString);
            });
            countDownTime --;
            self.passSecond ++;
        }
    });
    dispatch_resume(self.timer);
}

- (void)destoryTimer{
    if (_timer) {
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
}
- (void)dealloc{
    self.passSecond = 0;
    if (_timer) {
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
    if (tool) {
        tool.passSecond = 0;
    }
}



@end
