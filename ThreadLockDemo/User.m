//
//  User.m
//  GCDDemo
//
//  Created by 杨强 on 14/5/2019.
//  Copyright © 2019 杨强. All rights reserved.
//

#import "User.h"


@implementation User

/*在声明属性的情况下如果重写setter,getter方法，就需要把未识别的变量在@synthesize中定义，把属性的存取方法作用于变量
 */
@synthesize name = _name;  // name是属性，_name是变量
@synthesize sex = _sex;  // sex是属性，_sex是变量

static dispatch_semaphore_t _semaphore;

- (instancetype)init {
    self = [super init];
    if (self) {
        _semaphore = dispatch_semaphore_create(1);
        _array = [NSMutableArray arrayWithArray:@[@"1", @"2", @"3"]];
    }
    return self;
}

#pragma mark - Setter & Getter
- (void)setName:(NSString *)name {
    if (name) {
        dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
        _name = name;
        dispatch_semaphore_signal(_semaphore);
    }
}

//- (NSString *)name {
//    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
//    return _name;
//    dispatch_semaphore_signal(_semaphore);
//}

- (void)setSex:(NSString *)sex {
    if (sex) {
        dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
        _sex = sex;
        dispatch_semaphore_signal(_semaphore);
    }
}

//- (NSString *)sex {
//    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
//    return _sex;
//    dispatch_semaphore_signal(_semaphore);
//}

- (void)setArray:(NSMutableArray *)array {
    if (array) {
        _array = array;
    }
}


@end
