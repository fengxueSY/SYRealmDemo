//
//  SYDog.h
//  SYRealmModel
//
//  Created by 666gps on 2017/7/21.
//  Copyright © 2017年 666gps. All rights reserved.
//

#import <Realm/Realm.h>

@interface SYDog : RLMObject
@property NSString * name;
@property NSString * owner;
@property NSInteger sex;
@end
RLM_ARRAY_TYPE(SYDog)

@interface SYPreson : RLMObject
@property NSString * name;
@property NSInteger age;
@property NSString * adress;
@property BOOL isMan;
@property RLMArray<SYDog> * dogs;
@end
