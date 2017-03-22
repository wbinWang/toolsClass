//
//  WBLocalInfoManager.m
//  DarkHorse750
//
//  Created by wenbin on 2017/3/3.
//  Copyright © 2017年 beautyWang. All rights reserved.
//

#import "WBLocalInfoManager.h"
#import <NSObject+MJKeyValue.h>

@implementation WBLocalInfoManager

+ (WBSelfInfoModel *)selfInfoModel
{
    NSDictionary *userInfoDict = [[NSDictionary alloc]initWithContentsOfFile:kDocumentSelfInfo];
    WBSelfInfoModel *model = [WBSelfInfoModel ModelWithDict:userInfoDict];
    return model;
}

+ (BOOL)saveUserInfo2LocalWithModel:(WBSelfInfoModel *)model
{
    NSDictionary *dict = [model mj_keyValues];
    return [WBLocalInfoManager saveUserInfo2Local:dict];
}

+ (BOOL)saveUserInfo2Local:(NSDictionary *)infoDict
{
    NSMutableDictionary *newInfoDict = [[NSMutableDictionary alloc]initWithContentsOfFile:kDocumentSelfInfo];
    if (newInfoDict == nil) {
        newInfoDict = [NSMutableDictionary dictionaryWithCapacity:3];
    }
    NSArray *keys = infoDict.allKeys;
    NSArray *values = infoDict.allValues;
    
    for (int i = 0; i < keys.count; i ++) {
        if (values[i] != [NSNull null]) {
            [newInfoDict setValue:values[i] forKey:keys[i]];
        }
    }
    BOOL isSuccess = [newInfoDict writeToFile:kDocumentSelfInfo atomically:YES];
    return isSuccess;
}

+ (BOOL)removeUserInfoInLocal
{
    NSError *error;
    BOOL isSuccess = [[NSFileManager defaultManager]removeItemAtPath:kDocumentSelfInfo error:&error];
    WBLog(@"删除 本地plist = %d error = %@",isSuccess,error);
    if (!error && isSuccess) {
        return YES;
    }
    return NO;
}


@end
