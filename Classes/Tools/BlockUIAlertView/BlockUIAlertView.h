//
//  BlockUIAlertView.h
//  SinaToken
//
//  Created by yang chenghu on 13-5-9.
//  Copyright (c) 2013年 Sina. All rights reserved.
//

#import <Foundation/Foundation.h>

//0 - cancel button; 1 - otherbutton

static const NSInteger iAlertCancelButtonIndex = 0;

typedef void(^AlertBlock)(NSInteger index);

@interface BlockUIAlertView : UIAlertView

@property (nonatomic, copy) AlertBlock block;

//该方法直接配合 show使用
- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
  cancelButtonTitle:(NSString *)cancelButtonTitle
  otherButtonTitles:(NSString *)otherButtonTitles
        clickButton:(AlertBlock)_block;

//支持多个按钮多alertview
- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
  cancelButtonTitle:(NSString *)cancelButtonTitle
  otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

/**
 * @description 带点击block的show方法
 * @param
 * @return
 */
- (void)showWithClickBlock:(AlertBlock)_block;



@end
