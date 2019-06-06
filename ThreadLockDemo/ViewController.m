//
//  ViewController.m
//  ThreadLockDemo
//
//  Created by 杨强 on 15/5/2019.
//  Copyright © 2019 杨强. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import "User.h"


@interface ViewController ()

@property (nonatomic, copy) NSString *string;

@property (nonatomic, strong) NSLock *lock;


@end

@implementation ViewController

//@synthesize string = _string;

//静态变量
static dispatch_queue_t _concurrentQueue;
static dispatch_semaphore_t _semaphore;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _concurrentQueue = dispatch_queue_create("com.yangqiang.gcd.concurrent", DISPATCH_QUEUE_CONCURRENT);
    _semaphore = dispatch_semaphore_create(1);
    
    
//    [self GCD_Person_Safe];
    
//    [self GCD_User_Safe];
    
    [self Thread_UnSafe];
    
//    self.lock = [[NSLock alloc] init];
//
//    [self Thread_Lock_Safe];
    
}

- (void)Thread_UnSafe {
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_queue_t gloabelQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //Thread A
    dispatch_group_async(group, gloabelQueue, ^{
        for (int i = 0; i < 20; i ++) {
            if (i % 2 == 0) {
                self.string = @"a very long string";
            }
            else {
                self.string = @"string";
            }
            NSLog(@"Thread A: %@\n", self.string);
        }
    });
    
    //Thread B
    dispatch_group_async(group, gloabelQueue, ^{
        for (int i = 0; i < 20; i ++) {
            if (self.string.length >= 10) {
                NSString *subStr = [self.string substringWithRange:NSMakeRange(0, 10)];
                NSLog(@"substring %@", subStr);
            }
            NSLog(@"Thread B: %@\n", self.string);
        }
    });
    
    dispatch_group_notify(group, gloabelQueue, ^{
        dispatch_sync(dispatch_get_main_queue(), ^{
            
        });
    });
    
}

- (void)Thread_Lock_Safe {
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_queue_t gloabelQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
   
    dispatch_group_async(group, gloabelQueue, ^{
        [self->_lock lock];
        for (int i = 0; i < 20; i ++) {
            if (i % 2 == 0) {
                self.string = @"a very long string";
            }
            else {
                self.string = @"string";
            }
            NSLog(@"Thread A: %@\n", self.string);
        }
        [self->_lock unlock];
    });
    
    dispatch_group_async(group, gloabelQueue, ^{
        [self->_lock lock];
        for (int i = 0; i < 20; i ++) {
            if (self.string.length >= 10) {
                NSString *subStr = [self.string substringWithRange:NSMakeRange(0, 10)];
                NSLog(@"substring %@", subStr);
            }
            NSLog(@"Thread B: %@\n", self.string);
        }
        [self->_lock unlock];
    });
    
    dispatch_group_notify(group, gloabelQueue, ^{
        dispatch_sync(dispatch_get_main_queue(), ^{
            
        });
    });
}


- (void)GCD_Person_Safe {
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_queue_t gloabelQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    Person *person0 = [[Person alloc] init];
    
    dispatch_group_async(group, gloabelQueue, ^{
        person0.name = @"甲";
        person0.age = 10;
        NSLog(@"* %@, * %ld", person0.name, (long)person0.age);
    });
    
    dispatch_group_async(group, gloabelQueue, ^{
        person0.name = @"乙";
        person0.age = 20;
        NSLog(@"** %@, ** %ld", person0.name, (long)person0.age);
    });
    
    dispatch_group_async(group, gloabelQueue, ^{
        person0.name = @"丙";
        person0.age = 30;
        NSLog(@"*** %@, *** %ld", person0.name, (long)person0.age);
    });
    
    dispatch_group_notify(group, gloabelQueue, ^{
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSLog(@"%@===%ld", person0.name, person0.age);
        });
    });
    
}

- (void)GCD_User_Safe {
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_queue_t gloabelQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    User *user0 = [[User alloc] init];
    
    dispatch_group_async(group, gloabelQueue, ^{
        for (NSInteger i = 0; i < 10; i++) {
            NSInteger number = i;
            NSLog(@"%ld", (long)number);
        }
        NSLog(@"*0 %@, *0 %@", user0.name, user0.sex);
        user0.name = @"甲";
        user0.sex = @"男";
        NSLog(@"* %@, * %@", user0.name, user0.sex);
    });
    
    dispatch_group_async(group, gloabelQueue, ^{
        NSLog(@"**0 %@, **0 %@", user0.name, user0.sex);
        user0.name = @"丙";
        user0.sex = @"人妖";
        NSLog(@"** %@, ** %@", user0.name, user0.sex);
    });
    
    dispatch_group_async(group, gloabelQueue, ^{
        NSLog(@"***0 %@, ***0 %@", user0.name, user0.sex);
        user0.name = @"乙";
        user0.sex = @"女";
        NSLog(@"*** %@, *** %@", user0.name, user0.sex);
    });
    
    dispatch_group_notify(group, gloabelQueue, ^{
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSLog(@"%@===%@", user0.name, user0.sex);
        });
    });
}

#pragma mark - Setter & Getter
- (void)setString:(NSString *)string {
    if (string) {
        dispatch_barrier_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            self->_string = string;
        });
    }
}

//- (void)setString:(NSString *)string {
//    if (string) {
//        dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
//        _string = string;
//        dispatch_semaphore_signal(_semaphore);
//    }
//}

//- (void)setString:(NSString *)string {
//    if (string) {
//        [self.lock lock];
//        _string = string;
//        [self.lock unlock];
//    }
//}

//- (NSLock *)lock {
//    if (!_lock) {
//        _lock = [[NSLock alloc] init];
//    }
//    return _lock;
//}

@end
