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
@property NSString * colorStr;
@end
RLM_ARRAY_TYPE(SYDog)

@interface SYClass : RLMObject
@property NSString * className;
@property NSString * classNumber;
@end
RLM_ARRAY_TYPE(SYClass)

@interface SYPreson : RLMObject
@property NSString * name;
@property NSInteger age;
@property NSString * adress;
@property BOOL isMan;
@property RLMArray<SYDog> * dogs;
@property RLMArray<SYClass> * classs;
@end

