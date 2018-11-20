//
//  JKTextViewObserver.h
//
//
//  Created by 蒋鹏 on 16/9/18.
//  Copyright © 2016年 溪枫狼. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol JKTextViewObserverDelegate <NSObject>
@optional
/**
 *  过滤文字后调用
 */
- (void)jk_textViewDidChange:(UITextView *)textView;
@end







@interface JKTextViewObserver : NSObject


- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;


@property (nonatomic, strong) UITextView * textView;


/**
 正则匹配规则，限制TF输入类型    数字^[0-9]\\d*$    英文+数字@"^[A-Za-z0-9]+$"
 */
@property (nonatomic, copy) NSString * matchRegular;


/**    限制长度 (默认11个字符)    */
@property (nonatomic, assign)NSInteger maximumLength;


/**    用来监听处理后的事件    */
@property (nonatomic, weak)id <JKTextViewObserverDelegate>delegate;





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
