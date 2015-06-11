//
//  UIImageView+Image.h
//  TestDemo
//
//  Created by cxy on 15/6/10.
//  Copyright (c) 2015年 nandu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Image)

- (void)imageWithURL:(NSString *)urlString;
- (void)imageWithURL:(NSString *)urlString placeHolder:(UIImage *)image;
- (void)imageWithURL:(NSString *)urlString completion:(void(^)(UIImage *image, NSError *error))completion;
- (void)imageWithURL:(NSString *)urlString placeHolder:(UIImage *)image completion:(void(^)(UIImage *image, NSError *error))completion;

@end
