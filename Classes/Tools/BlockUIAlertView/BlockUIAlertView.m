//
//  BlockUIAlertView.m
//  SinaToken
//
//  Created by yang chenghu on 13-5-9.
//  Copyright (c) 2013年 Sina. All rights reserved.
//

#import "BlockUIAlertView.h"

@implementation BlockUIAlertView

@synthesize block;

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
  cancelButtonTitle:(NSString *)cancelButtonTitle
  otherButtonTitles:(NSString *)otherButtonTitles
        clickButton:(AlertBlock)_block
{
    self = [super initWithTitle:title
                        message:message
                       delegate:self
              cancelButtonTitle:cancelButtonTitle
              otherButtonTitles:otherButtonTitles, nil];
    
    if (self)
    {
        self.block = _block;
    }
    
    return self;
}

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
  cancelButtonTitle:(NSString *)cancelButtonTitle
  otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION
{
    self = [super initWithTitle:title
                        message:message
                       delegate:self
              cancelButtonTitle:cancelButtonTitle
              otherButtonTitles:otherButtonTitles, nil];
    
    id eachObject = nil;
    
    va_list argumentList;  
    if (otherButtonTitles)              // The first argument isn't part of the varargs list,
    {                                   // so we'll handle it separately.
        va_start(argumentList, otherButtonTitles); // Start scanning for arguments after firstObject.
        eachObject = va_arg(argumentList, id);
        while (eachObject != nil) // As many times as we can get an argument of type "id"
        {
            [self addButtonWithTitle:eachObject]; // that isn't nil, add it to self's contents.
            eachObject = va_arg(argumentList, id);
        }
        va_end(argumentList);
    }

    if (self)
    {
    }
    
    return self;
}

- (void)showWithClickBlock:(AlertBlock)_block
{
    self.block = _block;
    
    [self show];
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    self.block(buttonIndex);
}
@end
