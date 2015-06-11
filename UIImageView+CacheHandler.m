//
//  UIImageView+CacheHandler.m
//  TestDemo
//
//  Created by cxy on 15/6/10.
//  Copyright (c) 2015年 nandu. All rights reserved.
//

#import "UIImageView+CacheHandler.h"
#import <objc/runtime.h>
#import <CommonCrypto/CommonDigest.h>

static const void * CacheEnable = &"CacheEnable";



@interface UIImageView()


@end

@implementation UIImageView (CacheHandler)

#pragma mark - Property

- (void)setCacheEnable:(BOOL)cacheEnable{
    objc_setAssociatedObject(self, CacheEnable, [NSNumber numberWithBool:cacheEnable], OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)cacheEnable{
    id obj = objc_getAssociatedObject(self, CacheEnable);
    return [obj boolValue];
}

#pragma mark - Instance Method

//删除整个缓存目录
- (void)DeleteCachePath{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *cachePath = [self cachePath];
        if(cachePath){
            BOOL rmSuc = [[NSFileManager defaultManager] removeItemAtPath:cachePath error:nil];
            if(rmSuc){
                NSLog(@"rm CachePath Suc");
            }else{
                NSLog(@"rm Failed");
            }
        }
    });
}

//删除单张缓存
- (void)DeleteCacheImageWithString:(NSString *)string{
    if(string){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *extension = [string pathExtension];
            NSString *cachePath = [self cachePath];
            if(cachePath){
                NSString *imageName = [self md5:string];
                NSString *imagePath = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",imageName,extension]];
                
                if([[NSFileManager defaultManager] fileExistsAtPath:imagePath]){
                    BOOL rmSuc = [[NSFileManager defaultManager] removeItemAtPath:imagePath error:nil];
                    if(rmSuc){
                        NSLog(@"rm Suc");
                    }else{
                        NSLog(@"rm Failed");
                    }
                }else{
                    NSLog(@"file not exist");
                }
            }
        });
    }
}

//缓存图片
- (void)CacheImage:(UIImage *)image WithString:(NSString *)string replace:(BOOL)replace{
    
    if(!string && !image){
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *extension = [string pathExtension];
        NSString *cachePath = [self cachePath];
        if(cachePath){
            NSString *imageName = [self md5:string];
            NSString *imagePath = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",imageName,extension]];
            
            if(![[NSFileManager defaultManager] fileExistsAtPath:imagePath]){
                [self SaveImage:image withString:imagePath extension:extension];
            }else{
                if(replace){
                    [self SaveImage:image withString:imagePath extension:extension];
                }else{
                    NSLog(@"file has exsited");
                }
            }
        }
    });
}

- (void)SaveImage:(UIImage *)image withString:(NSString *)imagePath extension:(NSString *)extension{
    if([extension isEqualToString:@"png"]){
        BOOL saveSuc = [UIImagePNGRepresentation(image) writeToFile:imagePath atomically:YES];
        if(saveSuc){
            NSLog(@"save suc");
        }else{
            NSLog(@"save failed");
        }
    }else if ([extension isEqualToString:@"jpg"]){
        BOOL saveSuc = [UIImageJPEGRepresentation(image, 1.0) writeToFile:imagePath atomically:YES];
        if(saveSuc){
            NSLog(@"save suc");
        }else{
            NSLog(@"save failed");
        }
    }
}

- (NSString *)md5:(NSString *)string{
    const char* cStr = [string UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result);
    return [NSString stringWithFormat:@"%X%X%X%X%X%X%X%X%X%X%X%X%X%X%X%X",
            result[0],result[1],result[2],result[3],
            result[4],result[5],result[6],result[7],
            result[8],result[9],result[10],result[11],
            result[12],result[13],result[14],result[15]];
}

- (NSString *)cachePath{
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES) firstObject];
    NSString *path = [document stringByAppendingPathComponent:@"imageCache"];
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:path]){
        NSError *error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        
        if(error){
            return nil;
        }else{
            return path;
        }
    }else{
        return path;
    }
}

@end
