//
//  UIImageView+CacheHandler.h
//  TestDemo
//
//  Created by cxy on 15/6/10.
//  Copyright (c) 2015年 nandu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (CacheHandler)

@property (nonatomic, assign) BOOL cacheEnable;

//缓存单张图片，利用MD5加密,如果已经存在，当replace为YES时，替换掉原来的图片，否则不替换
- (void)CacheImage:(UIImage *)image WithString:(NSString *)string replace:(BOOL)replace;
//删除单张缓存图片
- (void)DeleteCacheImageWithString:(NSString *)string;
//删除整个缓存目录
- (void)DeleteCachePath;

@end
