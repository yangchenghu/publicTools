//
//  UIImage.h
//  GroupIM
//
//  Created by mac on 11-6-4.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIImage(Extras)

/**
 * @description 将图片转换到指定size
 * @param
 * @return
 */
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;

/**
 * @description 获取UIImage转换到png的NSData
 * @param
 * @return
 */
- (NSData *)pngData;

/**
 * @description 获取UIImage转换到jpg的NSData
 * @param
 * @return
 */
- (NSData *)jpgData;

/**
 * @description 保存到相册
 * @param
 * @return
 */
- (void)saveToAlbumCompletionTarget:(id)target action:(SEL)action;

/**
 * @description 截取图片中的部分图片
 * @param
 * @return
 */
- (UIImage*)getSubImage:(CGRect)rect;

/**
 * @description 旋转弧度
 * @param
 * @return
 */
- (UIImage *)imageRotatedByRadians:(CGFloat)radians;

/**
 * @description 旋转角度
 * @param
 * @return
 */
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;

/**
 * @description 转化成灰度图
 * @param
 * @return
 */
- (UIImage *)convertGrayImage;

/**
 * @description 通过CoreImage使用GPU将图片转化成灰度图
 * @param
 * @return
 */
- (UIImage *)convertGrayImageGPU;

/**
 * @description 使用uicoloer创建一个uiimage
 * @param
 * @return
 */
+ (UIImage *)createImageWithColor:(UIColor *)color;

/**
 * @description 实时对图片进行高斯模糊
 * @param
 * @return
 */
+ (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur;

@end
