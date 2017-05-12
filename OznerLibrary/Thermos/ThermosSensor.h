//
//  ThermosSensor.h
//  OznerLibraryDemo
//
//  Created by ZGY on 2017/5/11.
//  Copyright © 2017年 Ozner. All rights reserved.
//
//  Author:        Airfight
//  My GitHub:     https://github.com/airfight
//  My Blog:       http://airfight.github.io/
//  My Jane book:  http://www.jianshu.com/users/17d6a01e3361
//  Current Time:  2017/5/11  上午10:08
//  GiantForJade:  Efforts to do my best
//  Real developers ship.

#import <Foundation/Foundation.h>

@interface ThermosSensor : NSObject
{
    
}
-(void)load:(BytePtr)bytes;
-(void)reset;
/*!
 @function powerPer
 @discussion 获取当前电量百分比
 @result 返回TAP_SENSOR_ERROR没获取到数据
 */
-(float)powerPer;
@property (readonly,nonatomic) int Battery;
@property (readonly,nonatomic) int TDS;


@end
