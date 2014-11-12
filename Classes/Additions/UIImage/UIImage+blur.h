//
//  UIImage+blur.h
//  SinaToken
//
//  Created by yangchenghu on 13-8-20.
//  Copyright (c) 2013年 Sina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage (blur)

/**
 * @description >iOS 6.0 基于CoreImage.Framework框架
 * @param   blur 0.0 - 不清楚
 * @return
 */
- (UIImage *)blurryWithBlurLevel:(CGFloat)blur;

/**
 * @description >iOS 5.0 基于Accelerate.Framework框架的模糊
 * @param blur 0.0 - 1.0f
 * @return
 */
- (UIImage *)blurryBlurLevel:(CGFloat)blur;

@end
