//
//  SYRealmManager.h
//  SYRealmModel
//
//  Created by 666gps on 2017/7/21.
//  Copyright © 2017年 666gps. All rights reserved.
//

#import <Realm/Realm.h>

@interface SYRealmManager : RLMObject
//创建默认路径的数据库
+(RLMRealm *)creatDefaultName;
//添加数据到数据库
+(void)addDataRealm:(RLMRealm *)obj;

@end
