//
//  JDOPathUtil.m
//  JiaodongOnlineNews
//
//  Created by zhang yi on 13-5-20.
//  Copyright (c) 2013年 胶东在线. All rights reserved.
//

#import "JDOPathUtil.h"

@implementation JDOPathUtil

// 获取应用沙箱中Documents目录的路径
+ (NSString *)getDocumentsFilePath:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:fileName];
}

@end