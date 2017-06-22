//
//  ROCommlCell.m
//  OznerLibraryDemo
//
//  Created by ZGY on 2017/6/22.
//  Copyright © 2017年 Ozner. All rights reserved.
//
//  Author:        Airfight
//  My GitHub:     https://github.com/airfight
//  My Blog:       http://airfight.github.io/
//  My Jane book:  http://www.jianshu.com/users/17d6a01e3361
//  Current Time:  2017/6/22  上午9:54
//  GiantForJade:  Efforts to do my best
//  Real developers ship.


#import "ROCommlCell.h"
#import "ROWaterPurufier.h"

@implementation ROCommlCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)sendTemp:(id)sender {
    
//    ROWaterPurufier *device = (ROWaterPurufier *)self.device;
    [_textField resignFirstResponder];
    [self.deviceInfo startSend];
    
    if (comml.connectStatus == Connected) {
        
    if  ([comml setHotTemp:(_textField.text).intValue]) {
        NSLog(@"设置成功");
        [self.deviceInfo printStatus:@"设置成功"];
    } else {
        NSLog(@"设置失败");
        [self.deviceInfo printStatus:@"设置失败"];
    };
    } else {
        [self.deviceInfo printStatus:@"设备未连接"];
    }
}

- (void)setDevice:(OznerDevice *)device{
    
    update=false;
    comml=(ROWaterPurufier*)device;
    [super setDevice:device];
    
}

-(void)update
{
    if (!update)
    {
//        [self->_SpeedSlider setValue:air.status.RPM];
//        [self.SpeedValue setText:[NSString stringWithFormat:@"%d%%",(int)_SpeedSlider.value]];
        
    }
    [super update];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
