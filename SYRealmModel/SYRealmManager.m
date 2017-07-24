//
//  SYRealmManager.m
//  SYRealmModel
//
//  Created by 666gps on 2017/7/21.
//  Copyright © 2017年 666gps. All rights reserved.
//

#import "SYRealmManager.h"

@implementation SYRealmManager
+(RLMRealm *)creatDefaultName{
    RLMRealm * realm = [RLMRealm defaultRealm];
    return realm;
}

+(void)addDataRealm:(RLMObject *)obj{
    RLMRealm * realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm addObject:obj];
    [realm commitWriteTransaction];
}
@end
