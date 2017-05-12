//
//  Thermos.h
//  OznerLibraryDemo
//
//  Created by ZGY on 2017/5/11.
//  Copyright © 2017年 Ozner. All rights reserved.
//
//  Author:        Airfight
//  My GitHub:     https://github.com/airfight
//  My Blog:       http://airfight.github.io/
//  My Jane book:  http://www.jianshu.com/users/17d6a01e3361
//  Current Time:  2017/5/11  上午10:00
//  GiantForJade:  Efforts to do my best
//  Real developers ship.

#import <Foundation/Foundation.h>
#import "OznerDevice.h"

@class Thermos;

@protocol ThermosDelegate <NSObject>
-(void)Thermos:(Thermos*)thermos recvMAC:(NSString*)mac;
@end;

@interface Thermos : OznerDevice

@end
