//
//  Person.m
//  GCDDemo
//
//  Created by YQ on 2017/1/16.
//  Copyright © 2017年 杨强. All rights reserved.
//

#import "Person.h"

@implementation Person
// @synthesize的语义是如果你没有手动实现 setter 方法和 getter 方法，那么编译器会自动为你加上这两个方法
// @dynamic 告诉编译器：属性的 setter 与 getter 方法由用户自己实现，不自动生成。

// @synthesize 表示实现属性，如setter和getter方法

/*在声明属性的情况下如果重写setter,getter方法，就需要把未识别的变量在@synthesize中定义，把属性的存取方法作用于变量
 */
@synthesize name = _name;  // name是属性，_name是变量
@synthesize age = _age;  // age是属性，_age是变量

static dispatch_queue_t _concurrentQueue;

// @synchronized 线程安全

#pragma mark -- Life Cycle --
- (instancetype)init {
    self = [super init];
    
    if (self) {
        _concurrentQueue = dispatch_queue_create("com.yangqiang.gcd.person", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

#pragma mark -- Setter & Getter --
- (void)setName:(NSString *)name{
    if (name) {
        dispatch_barrier_async(_concurrentQueue, ^{
            self->_name = [name copy];
        });
    }
}

- (NSString *)name{
    if (!_name) {
        dispatch_sync(_concurrentQueue, ^{
            self->_name = @"小明";
        });
    }
    return _name;
}

- (void)setAge:(NSInteger)age{
    if (age) {
        
        dispatch_barrier_async(_concurrentQueue, ^{
            self->_age = age;
        });

    }
}

- (NSInteger)age{
    if (!_age) {
        dispatch_sync(_concurrentQueue, ^{
            self->_age = 25;
        });
    }
    return _age;
}

@end
