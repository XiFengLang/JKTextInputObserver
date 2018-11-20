//
//  JKTextInputObserver.h
//  JKTextInputObserver
//
//  Created by 蒋鹏 on 2018/11/21.
//  Copyright © 2018 溪枫狼. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol JKTextInputObserverDelegate <NSObject>
@optional
/**
 *  过滤文字后调用,监听过滤后的文本内容
 */
- (void)jk_textFieldDidChange:(UITextField *)textField;


/**
 *  过滤文字后调用,监听过滤后的文本内容
 */
- (void)jk_textViewDidChange:(UITextView *)textView;


@end




// ====================================== JKTextInputObserver  ====================================




/**
 整合JKTextFieldObserver和JKTextViewObserver，但是JKTextInputObserver不能同时监听UITextField和UITextView，initWithTextField：和initWithTextView:决定接收某种文本输入框的文本变化通知
 */
@interface JKTextInputObserver : NSObject

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;


/**
 正则匹配规则，限制内容输入    数字^[0-9]\\d*$    英文+数字@"^[A-Za-z0-9]+$"
 */
@property (nonatomic, copy) NSString * matchRegular;


/**    限制长度 (默认11个字符)    */
@property (nonatomic, assign) NSInteger maximumLength;


/**    用来监听处理后的事件    */
@property (nonatomic, weak) id <JKTextInputObserverDelegate>delegate;





// ====================================== UITextField  ====================================

#pragma mark - UITextField

@property (nonatomic, strong) UITextField * textField;

/**    初始化方法，会对textField输入进行监听以及过滤文字    */
- (instancetype)initWithTextField:(UITextField *)textField;
+ (instancetype)observerWithTextField:(UITextField *)textField;


/**
 *  在textField代理方法中调用，\
 @selector(textField: shouldChangeCharactersInRange:replacementString:)
 */
- (BOOL)jk_textField:(UITextField *)textField range:(NSRange)range shouldChangeString:(NSString *)string;


/**    删除textField首尾的空格字符    */
- (void)jk_trimmingCharactersForTextField:(UITextField *)textField;






// ====================================== UITextView  ====================================

#pragma mark - UITextView


@property (nonatomic, strong) UITextView * textView;


/**    初始化方法，会对textView输入进行监听以及过滤文字    */
- (instancetype)initWithTextView:(UITextView *)textView;
+ (instancetype)observerWithTextView:(UITextView *)textView;


/**
 *  在textView代理方法中调用，\
 @selector(textView: shouldChangeCharactersInRange:replacementString:)
 */
- (BOOL)jk_textView:(UITextView *)textView range:(NSRange)range shouldChangeString:(NSString *)string;


/**    删除textView首尾的空格字符    */
- (void)jk_trimmingCharactersForTextView:(UITextView *)textView;


@end

NS_ASSUME_NONNULL_END
