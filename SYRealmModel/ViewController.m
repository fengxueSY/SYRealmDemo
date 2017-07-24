//
//  ViewController.m
//  SYRealmModel
//
//  Created by 666gps on 2017/7/21.
//  Copyright © 2017年 666gps. All rights reserved.
//

#import "ViewController.h"
#import "SYDog.h"


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UIButton *deleageButton;
@property (weak, nonatomic) IBOutlet UIButton *changeButton;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UITextField *textFiled;

@property (nonatomic,copy) NSArray * palceArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.palceArray = @[@"中国",@"汉朝",@"明朝",@"魏国",@"蜀国",@"夏朝",@"秦朝",@"商朝",@"东晋",@"隋朝",@"唐朝"];
    [self.searchButton addTarget:self action:@selector(searchButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.deleageButton addTarget:self action:@selector(deleageButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.changeButton addTarget:self action:@selector(changeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.addButton addTarget:self action:@selector(addDataRealm) forControlEvents:UIControlEventTouchUpInside];
    
    //首先清除一次数据库，方便测试，如果是正式环境不可以执行该操作
    [self cleanRealm];
    
    //添加数据库
    [self addDataRealm];
    
    //这里打印沙盒路径，方便查看数据
    [self nslogShow];
}
//清除一次数据库
-(void)cleanRealm{
    
    NSFileManager *manager = [NSFileManager defaultManager];
    RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
    NSArray<NSURL *> *realmFileURLs = @[
                                        config.fileURL,
                                        [config.fileURL URLByAppendingPathExtension:@"lock"],
                                        [config.fileURL URLByAppendingPathExtension:@"management"],
                                        ];
    for (NSURL *URL in realmFileURLs) {
        NSError *error = nil;
        [manager removeItemAtURL:URL error:&error];
        if (error) {
            NSLog(@"clean realm error:%@", error);
        }else{
            NSLog(@"清楚成功");
        }
    }
    
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString * pathName = [path stringByAppendingString:@"/realmTest.realm"];
    RLMRealm * realm = [RLMRealm realmWithURL:[NSURL URLWithString:pathName]];
    [realm transactionWithBlock:^{
        [realm deleteAllObjects];
    }];
}
//*******************************************************
/*
 
 这里创建数据库的时候，选择的是自定义数据库路径
 NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
 NSString * pathName = [path stringByAppendingString:@"/realmTest.realm"];
 RLMRealm * realm = [RLMRealm realmWithURL:[NSURL URLWithString:pathName]];
 所以后面的查询操作统一使用以下方式去操作，否则拿不到数据库的数据
 NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
 NSString * pathName = [path stringByAppendingString:@"/realmTest.realm"];
 RLMRealm * realm = [RLMRealm realmWithURL:[NSURL URLWithString:pathName]];
 //获取某一模型所有数据
 RLMResults * presons = [SYPreson allObjectsInRealm:realm];
 //获取某一模型单一数据
 RLMResults * ages = [SYPreson objectsInRealm:realm where:@"age = 12"];
 
 
 如果创建方式为默认方式创建
 RLMRealm * realm = [RLMRealm defaultRealm];
 //获取单一模型所有数据
 RLMResults * res = [SYPreson allObjects];
 //获取但一模型单一数据
 RLMResults * res1 = [SYPreson objectsWhere:@"age = 12"];
 */
//*******************************************************
//添加数据到数据库
-(void)addDataRealm{
    //循环添加一种数据到数据库
    for (int i = 0; i < 100; i++) {
        SYDog * dog = [[SYDog alloc]init];
        dog.name = [NSString stringWithFormat:@"dog_%u",arc4random()%10];
        dog.owner = [NSString stringWithFormat:@"%d",i];
        dog.sex = arc4random()%2;
        //默认数据库路径以及名字
        /*
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm transactionWithBlock:^{
            [realm addObject:dog];
        }];
        */
        
        //自定义数据库名字和路径
        NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
        NSString * pathName = [path stringByAppendingString:@"/realmTest.realm"];
        RLMRealm * realm = [RLMRealm realmWithURL:[NSURL URLWithString:pathName]];
        [realm transactionWithBlock:^{
            [realm addObject:dog];
        }];
    }
    
    //循环添加嵌套式的数据
    for (int i = 0; i < 100; i++) {
        SYPreson * presen = [[SYPreson alloc]init];
        presen.name = [NSString stringWithFormat:@"地主——%d",i];
        presen.age = arc4random()%20;
        if (arc4random()%2 == 1) {
            presen.isMan = YES;
        }else{
            presen.isMan = NO;
        }
        NSInteger a = arc4random()%self.palceArray.count;
        presen.adress = [NSString stringWithFormat:@"%@",self.palceArray[a]];
        for (int i = 0; i < 10; i++) {
            SYDog * dog = [[SYDog alloc]init];
            dog.name = [NSString stringWithFormat:@"dog_%u",arc4random()%10];
            dog.owner = [NSString stringWithFormat:@"%d",i];
            dog.sex = arc4random()%2;
            [presen.dogs addObject:dog];
        }
        //默认数据库路径
        /*
        RLMRealm * realm = [RLMRealm defaultRealm];
        [realm transactionWithBlock:^{
            [realm addObject:presen];
        }];
        */
        
        //自定义数据库名字和路径
        NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
        NSString * pathName = [path stringByAppendingString:@"/realmTest.realm"];
        RLMRealm * realm = [RLMRealm realmWithURL:[NSURL URLWithString:pathName]];
        [realm transactionWithBlock:^{
            [realm addObject:presen];
        }];
    }
}
//数据库查询操作
-(void)searchButtonAction{
    
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString * pathName = [path stringByAppendingString:@"/realmTest.realm"];
    RLMRealm * realm = [RLMRealm realmWithURL:[NSURL URLWithString:pathName]];
    
    //查询所有
    RLMResults * presons = [SYPreson allObjectsInRealm:realm];
//    NSLog(@" === %@",presons);
    for (SYPreson * pre in presons) {
//        NSLog(@"pwer == %@",pre.name);
    }
    
    //按照年龄查询，年龄为int类型
    RLMResults * ages = [SYPreson objectsInRealm:realm where:@"age = 12"];
    for (SYPreson * age in ages) {
//        NSLog(@"age === %@ %ld",age.name,age.age);
    }
    
    //按照名字查询，名字是string类型
    RLMResults * dogs = [SYDog objectsInRealm:realm where:@"name = 'dog_2'"];
    for (SYDog * dog in dogs) {
//        NSLog(@"dog === %@  %@",dog.name,dog.owner);
    }
    
    //多种条件查询
    RLMResults * res = [SYPreson objectsInRealm:realm where:@"age < 12 AND adress = '秦朝'"];
    for (SYPreson * p in res) {
//        NSLog(@"------ %@ %@ %ld",p.name,p.adress,p.age);
    }
    
    //断言查询，查询速度比较快，推荐使用
    //断言查询单个数据
    NSPredicate * pre = [NSPredicate predicateWithFormat:@"ANY dogs.sex = %ld",1];
    RLMResults * resPre = [SYPreson objectsInRealm:realm withPredicate:pre];
    for (SYPreson * pres in resPre) {
//        NSLog(@"------ %@ %@ %ld",pres.name,pres.adress,pres.age);
    }
    //断言查询多个数据条件
    NSPredicate * pres = [NSPredicate predicateWithFormat:@"ANY dogs.sex = %ld AND dogs.name = '%@'",1,@"dog_3"];
    RLMResults * resPres = [SYPreson objectsInRealm:realm withPredicate:pres];
    for (SYPreson * pr in resPres) {
        NSLog(@"------ %@ %@ %ld",pr.name,pr.adress,pr.age);
    }
}
//删除数据库
-(void)deleageButtonAction{
   
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString * pathName = [path stringByAppendingString:@"/realmTest.realm"];
    RLMRealm * realm = [RLMRealm realmWithURL:[NSURL URLWithString:pathName]];
    
    //删除某一类元素，这里的查询操作跟上面查询操作一样，查询到单个或者多个数据，使用delete方法直接删除
    RLMResults * ages = [SYPreson objectsInRealm:realm where:@"age > 14"];
    [realm transactionWithBlock:^{
        [realm deleteObjects:ages];
    }];
    
    //直接删除所有数据
    RLMResults * per = [SYPreson allObjectsInRealm:realm];
    [realm transactionWithBlock:^{
        //单独删除每个数据，如果要删除所有的，要使用循环删除
//        [realm deleteObject:per.lastObject];
        //一次性删除一个数组的数据
        [realm deleteObjects:per];
    }];
}
//修改数据库
-(void)changeButtonAction{
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString * pathName = [path stringByAppendingString:@"/realmTest.realm"];
    RLMRealm * realm = [RLMRealm realmWithURL:[NSURL URLWithString:pathName]];
    
    //查询出年龄为1的person
    RLMResults * per = [SYPreson objectsInRealm:realm where:@"age = 1"];
    for (SYPreson * p in per) {
        [realm transactionWithBlock:^{
           p.name = @"年龄为1，修改名字";
        }];
    }
}
//打印
-(void)nslogShow{
    NSString *path = NSHomeDirectory();//主目录
    NSLog(@"NSHomeDirectory:%@",path);
    NSString *userName = NSUserName();//与上面相同
    NSString *rootPath = NSHomeDirectoryForUser(userName);
    NSLog(@"NSHomeDirectoryForUser:%@",rootPath);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory=[paths objectAtIndex:0];//Documents目录
    NSLog(@"NSDocumentDirectory:%@",documentsDirectory);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
