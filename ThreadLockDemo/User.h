//
//  User.h
//  GCDDemo
//
//  Created by 杨强 on 14/5/2019.
//  Copyright © 2019 杨强. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface User : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *sex;

@property (nonatomic, strong) NSMutableArray *array;

@end

NS_ASSUME_NONNULL_END
