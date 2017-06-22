//
//  ROWaterPurufier.m
//  OznerLibraryDemo
//
//  Created by Zhiyongxu on 2016/10/24.
//  Copyright © 2016年 Ozner. All rights reserved.
//

#import "ROWaterPurufier.h"
#import "../Device/OznerDevice.hpp"

@implementation ROWaterPurufier

#define opCode_request_info 0x20
#define opCode_reset 0xa0
#define opCode_respone_setting 0x21
#define opCode_respone_water 0x22
#define opCode_respone_filter 0x23
#define opCode_respone_filterTime 0x24
#define opCode_respone_SettingInfo 0x25

#define opCode_update_setting 0x40

#define opCode_update_Temp 0x41

#define type_status  1
#define type_sensor  2
#define type_filter  3
#define type_a2dp  4
#define type_SettingTwo 5



-(instancetype)init:(NSString *)identifier Type:(NSString *)type Settings:(NSString *)json
{
    if (self=[super init:identifier Type:type Settings:json])
    {
        _filterInfo=[[RO_FilterInfo alloc] init];
        _settingInfo=[[ROWaterSettingInfo alloc] init];
        _waterInfo=[[RO_WaterInfo alloc] init];
        _twoInfo = [[ROWaterSettingTwoInfo alloc] init];
    }
    return self;
}

-(void)DeviceIODidDisconnected:(BaseDeviceIO *)io
{
    [_filterInfo reset];
    [_settingInfo reset];
    [_filterInfo reset];
    [_twoInfo rest];
}



Byte calcSum(Byte* data,int size)
{
    Byte sum=0;
    for (int i=0;i<size;i++)
        sum+=data[i];
    return sum;
}
-(void)requestSettingInfo
{
    if (!io) return;
    NSMutableData* data=[[NSMutableData alloc] init];
    Byte bytes[3];
    bytes[0]=opCode_request_info;
    bytes[1]=1;
    bytes[2]=calcSum(bytes,2);
    [data appendBytes:bytes length:3];
    
    [io send:data];
}

-(void)requestWaterInfo
{
    if (!io) return;
    NSMutableData* data=[[NSMutableData alloc] init];
    Byte bytes[3];
    bytes[0]=opCode_request_info;
    bytes[1]=2;
    bytes[2]=calcSum(bytes,2);
    [data appendBytes:bytes length:3];
    
    [io send:data];
}

-(void)requestFilterInfo
{
    if (!io) return;
    NSMutableData* data=[[NSMutableData alloc] init];
    Byte bytes[3];
    bytes[0]=opCode_request_info;
    bytes[1]=3;
    bytes[2]=calcSum(bytes,2);
    [data appendBytes:bytes length:3];
    
    [io send:data];
}

/*!
 滤芯历史信息
 */
-(void)requestFilterHisInfo
{
    if (!io) return;
    NSMutableData* data=[[NSMutableData alloc] init];
    Byte bytes[3];
    bytes[0]=opCode_request_info;
    bytes[1]=3;
    bytes[2]=calcSum(bytes,2);
    [data appendBytes:bytes length:3];
    
    [io send:data];
}
-(BOOL)updateSetting:(int)interval Ozone_WorkTime:(int)worktime ResteFilter:(BOOL)reset
{
    if (!io) return false;
    NSMutableData* data=[[NSMutableData alloc] init];
    Byte bytes[11];
    bytes[0]=opCode_update_setting;
    NSDate* time=[NSDate dateWithTimeIntervalSinceNow:0];
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *dateComps = [cal components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:time];
    
    bytes[1]=[dateComps year]-2000;
    bytes[2]=[dateComps month];
    bytes[3]=[dateComps day];
    bytes[4]=[dateComps hour];
    bytes[5]=[dateComps minute];
    bytes[6]=[dateComps second];
    
    bytes[7]=interval;
    bytes[8]=worktime;
    bytes[9]=reset?1:0;
    bytes[10]=calcSum(bytes,10);
    [data appendBytes:bytes length:11];
    
    return [io send:data];
    
}

-(BOOL) reset
{
    if (!io) return false;
    NSMutableData* data=[[NSMutableData alloc] init];
    Byte bytes[3];
    bytes[0]=opCode_reset;
    bytes[1]=calcSum(bytes,1);
    [data appendBytes:bytes length:2];
    
    return [io send:data];
}

//
- (BOOL)requestFilterTime {
    
    NSMutableData* data=[[NSMutableData alloc] init];
    Byte bytes[3];
    bytes[0]=opCode_request_info;
    bytes[1]=4;
    bytes[2]=calcSum(bytes,2);
    [data appendBytes:bytes length:3];
    
    return [io send:data];
}

- (BOOL)requestSetting {
    
    NSMutableData* data=[[NSMutableData alloc] init];
    Byte bytes[3];
    bytes[0]=opCode_request_info;
    bytes[1]=5;
    bytes[2]=calcSum(bytes,2);
    [data appendBytes:bytes length:3];
    
    return [io send:data];
}

//
////
//- (BOOL)requestSetting {
//    
//    Byte byte[1] = {type_SettingTwo};
//    return [self send:opCode_Request Data:[NSData dataWithBytes:byte length:sizeof(byte)]];
//    
//}


-(BOOL)DeviceIOWellInit:(BaseDeviceIO *)io
{
    
//    sleep(0.1f);
//    if (![self requestFilterTime])
//    return false;
//    sleep(0.1f);
//    if ([self requestSetting])
//    return false;
    
    return true;
}
-(NSString *)description
{
    return [NSString stringWithFormat:@"%@\n%@\n%@\n%@",[_settingInfo description],
            [_waterInfo description],[_filterInfo description],[_twoInfo description]];
    //return [NSString stringWithFormat:@"status:%@",[_status description]];
}

-(void)DeviceIO:(BaseDeviceIO *)io recv:(NSData *)data
{
    if (data==nil) return;
    if (data.length<1) return;
    BytePtr bytes=(BytePtr)[data bytes];
    Byte opCode=bytes[0];
    lastDataTime=[NSDate dateWithTimeIntervalSinceNow:0];
    switch (opCode) {
        case opCode_respone_setting:
            [_settingInfo load:data];
            [self doSensorUpdate];
            //settingInfo.fromBytes(data);
            break;
        case opCode_respone_water:
            [_waterInfo load:data];
            [self doSensorUpdate];
            //waterInfo.fromBytes(data);
            break;
        case opCode_respone_filter:
            [_filterInfo load:data];
            [self doSensorUpdate];
            break;
        case opCode_respone_filterTime:
            break;
        case opCode_respone_SettingInfo:
        {
//            NSLog(@"----------- %@",self.type);
//            Byte* bytes=(Byte*)[data bytes];
//            _hottempSet = bytes[1];
//            NSLog(@"%d",_hottempSet);
            [_twoInfo load:data];
            [self doSensorUpdate];
            
        }
            break;
            
            
            //filterInfo.fromBytes(data);
    }
}


-(void)DeviceIODidReadly:(BaseDeviceIO *)io
{
    [self start_auto_update];
}

-(void)stop_auto_update
{
    if (self->updateTimer)
    {
        [updateTimer invalidate];
        updateTimer=nil;
    }
}

-(void)start_auto_update
{
    if (updateTimer)
        [self stop_auto_update]; 
    if (!updateTimer)
    {
        updateTimer=[NSTimer scheduledTimerWithTimeInterval:3 target:self
                                                   selector:@selector(auto_update)
                                                   userInfo:nil repeats:YES];
        [updateTimer fire];
    }
}


-(void)auto_update
{
    if ((requestCount%2)==0)
    {
        [self requestFilterInfo];
    }else
        [self requestWaterInfo];
        [self requestSetting];
    requestCount++;
}


/**
 设置加热温度 （厨上式水机）

 @return return value description
 */
-(BOOL)setHotTemp:(int)temp {
    
    if (temp == _twoInfo.hottempSet) return true;
    
    NSMutableData* data=[[NSMutableData alloc] init];
    Byte bytes[10];
    bytes[0]=opCode_update_Temp;
    bytes[1]=temp;
    bytes[2]=_twoInfo.isPower?1:0;
    bytes[3]=_twoInfo.openPowerTime;
    bytes[4]=_twoInfo.closePowerTime;
    bytes[5]=_twoInfo.isHot;
    bytes[6]=_twoInfo.startHotTime;
    bytes[7]=_twoInfo.endHotTime;
    bytes[8]=_twoInfo.isCold;
    bytes[9]=calcSum(bytes, 9);
    [data appendBytes:bytes length:10];
    
    return [io send:data];

}

//-(void)setStatus:(NSData*)data Callback:(OperateCallback)cb
//{
//    if (!io)
//    {
//        if (cb)
//        {
//            cb([NSError errorWithDomain:@"Connection Closed" code:0 userInfo:nil]);
//        }
//        return;
//    }
//    [io send:];
//    [self reqeusetStatsus];
//}

- (BOOL)updateTemp:(int)tmp {
    
    if (!io) return false;

    NSMutableData* data=[[NSMutableData alloc] init];
    Byte bytes[11];
    bytes[0]=opCode_update_Temp;
    
    return false;
    
}

//重置滤芯时间
-(BOOL) resetFilter
{
    if (_settingInfo.Ozone_Interval<=0) return false;
    if (_settingInfo.Ozone_WorkTime<=0) return false;
    
    return [self updateSetting:_settingInfo.Ozone_Interval Ozone_WorkTime:_settingInfo.Ozone_WorkTime ResteFilter:true];
    
}
//返回是否允许滤芯重置
-(BOOL) isEnableFilterReset
{
    return true;
}

+(BOOL)isBindMode:(BluetoothIO*)io
{
    if (io)
    {
        if (io.scanResponseData)
        {
            Byte flag=((Byte*)[io.scanResponseData bytes])[0];
            return flag;
        }else
            return false;
    }
    else
        return false;
}
@end
