//
//  IMTextFieldDelegate.h
//
//
//  Created by 蒋鹏 on 16/9/18.
//  Copyright © 2016年 溪枫狼. All rights reserved.
//
#import <UIKit/UIKit.h>


/****************************************************************************************
 
 1.JKTextFieldObserver用来监听textField输入，过滤字符，默认限制8个字符的汉字、数字、英文
 
 
 2.用法
 2.1     成为strong类型成员属性
 @property (nonatomic, strong)JKTextFieldObserver * textFieldObserver;
 
 2.2     在适当的时候初始化，PS：必须在textField初始化后
 self.textFieldObserver = [[JKTextFieldObserver alloc]initWithTextField:self.textField];
 
 
 2.3     在适当的时候销毁，即停止监听（此行为不强制）
 self.textFieldObserver = nil;
 
 2.4     在TextFeild代理方法中调用：（Copy下面代码）
 - (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
 return [self.textFieldObserver jk_textField:textField range:range shouldChangeString:string];
 }
 
 2.5     如需监听过滤后的字符变化，实现JKTextFieldObserverDelegate代理方法
 - (void)jk_textFieldDidChange:(UITextField *)textField
 
 
 Tips：通过监听UITextFieldTextDidChangeNotification通知，对TextField进行输入监听
 *************************************************************************************/



@protocol JKTextFieldObserverDelegate <NSObject>
@optional
/**
 *  过滤文字后调用
 */
- (void)jk_textFieldDidChange:(UITextField *)textField;
@end


/**    详情及用法见.h文件顶部的介绍    */
@interface JKTextFieldObserver : NSObject
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;


@property (nonatomic, strong) UITextField * textField;


/**
 正则匹配规则，限制TF输入类型    数字^[0-9]\\d*$    英文+数字@"^[A-Za-z0-9]+$"
 */
@property (nonatomic, copy) NSString * matchRegular;


/**    限制长度 (默认11个字符)    */
@property (nonatomic, assign)NSInteger maximumLength;


/**    用来监听处理后的事件    */
@property (nonatomic, weak)id <JKTextFieldObserverDelegate>delegate;





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

@end
