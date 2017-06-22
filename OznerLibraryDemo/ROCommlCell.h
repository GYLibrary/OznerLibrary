//
//  ROCommlCell.h
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


#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"
#import "ROWaterPurufier.h"
@interface ROCommlCell :BaseTableViewCell
{
    ROWaterPurufier *comml;
    BOOL update;
}
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end
