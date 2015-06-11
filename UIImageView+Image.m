//
//  UIImageView+Image.m
//  TestDemo
//
//  Created by cxy on 15/6/10.
//  Copyright (c) 2015年 nandu. All rights reserved.
//

#import "UIImageView+Image.h"

@implementation UIImageView (Image)

- (void)imageWithURL:(NSString *)urlString{
    [self imageWithURL:urlString placeHolder:nil completion:NULL];
}

- (void)imageWithURL:(NSString *)urlString placeHolder:(UIImage *)image{
    [self imageWithURL:urlString placeHolder:image completion:NULL];
}

- (void)imageWithURL:(NSString *)urlString completion:(void (^)(UIImage *, NSError *))completion{
    [self imageWithURL:urlString placeHolder:nil completion:completion];
}

- (void)imageWithURL:(NSString *)urlString placeHolder:(UIImage *)image completion:(void (^)(UIImage *, NSError *))completion{
    if(urlString){
        
        //NSURLSession 方法
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:urlString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
            if(error){
                if(completion){
                    completion(nil, error);
                }
            }else{
                if(completion){
                    UIImage *image = [UIImage imageWithData:data];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.image = image;
                        completion(image, nil);
                    });
                    
                    
                }
            }
        }];
        
        [dataTask resume];
        
        /* //NSURLConnection 方法
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        queue.maxConcurrentOperationCount = 5;
        queue.name = @"DownloadImageQueue";
        
        [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]] queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
            if(error){
                if(completion){
                    completion(nil, error);
                }
            }else{
                if(completion){
                    UIImage *image = [UIImage imageWithData:data];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.image = image;
                        completion(image, nil);
                    });
                    
                    
                }
            }
        }];
         */
    }
}

@end
