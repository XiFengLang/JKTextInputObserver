//
//  JKTextInputObserver.m
//  JKTextInputObserver
//
//  Created by 蒋鹏 on 2018/11/21.
//  Copyright © 2018 溪枫狼. All rights reserved.
//

#import "JKTextInputObserver.h"
#import "NSString+Emoji.h"

@interface JKTextInputObserver ()

@property (nonatomic, copy) NSString * memoryAddress;/**<  被监听对象的内存地址  */
@property (nonatomic, assign) BOOL isObserveTextField;/**<  当前实例对象只能单独监听TextFeild或TextView  */

@end




@implementation JKTextInputObserver

/**    默认的最大长度    */
static const NSInteger kTextInputObserverDefaultLength = 11;


+ (instancetype)observerWithTextField:(UITextField *)textField {
    return [[self alloc]initWithTextField:textField];
}

- (instancetype)initWithTextField:(UITextField *)textField {
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChangeText:) name:UITextFieldTextDidChangeNotification object:nil];
        self.isObserveTextField = true;
        self.textField = textField;
        self.maximumLength = kTextInputObserverDefaultLength;
    }return self;
}


- (void)setTextField:(UITextField *)textField {
    _textField = textField;
    if (textField) {
        textField.accessibilityIdentifier = [NSString stringWithFormat:@"%p",self];
        self.memoryAddress = textField.accessibilityIdentifier;
    } else {
        self.memoryAddress = nil;
    }
    
    if (self.isObserveTextField == false) {
        NSLog(@"======================== JKTextInputObserver  =========================");
        NSLog(@"============Error: 使用initWithTextView:实例后只能设置textView============");
        NSLog(@"======================== JKTextInputObserver  =========================");
    }
}


- (BOOL)jk_textField:(UITextField *)textField range:(NSRange)range shouldChangeString:(NSString *)string {
    if ([textField.accessibilityIdentifier isEqualToString:self.memoryAddress] == NO) {
        return YES;
    } else if (range.length >= 1 && [string isEqualToString:@""]) {
        return YES;// 删除
    } else if (textField.text.length >= self.maximumLength) {
        return false;
    } else if (
               (range.length != 1 && [string isEqualToString:@""]) ||
               ([string isEqualToString:@""] &&
                [string isKindOfClass:NSClassFromString(@"__NSCFString")] &&
                ![string isKindOfClass:NSClassFromString(@"__NSCFConstantString")]
                )
               ) {
        return NO;// 屏蔽iPad上的撤销输入功能(可以撤销删除)
    } else if (self.matchRegular){
        NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", self.matchRegular];
        return [regextestmobile evaluateWithObject:string];
    }
    
    
    // 过滤特殊字符
    NSCharacterSet * doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"'\"\\&+⛑⛸☘☄✨⛈⛷☃☂⛴⛰⛩⌨⏰⏲⏱⏳⚖⛏⚒⚙⛓☠⚔⚰⚱⚗⛱⛎✡☯☦☸☪✝☮❣❌⚛☢☣➿❎✅⚜❔❓❕✊⏸⏯⏹⏺⏭⏮⏩⏪⏫⏬〰➰➗➖➕©®™"];
    NSString * tempString = [[string componentsSeparatedByCharactersInSet:doNotWant]componentsJoinedByString:@""];
    BOOL ret = [string isEqualToString:tempString];
    return ret;
}



- (void)textFieldDidChangeText:(NSNotification *)notification{
    // 限制输入文字的长度，兼容表情和拼音，http://www.jianshu.com/p/2d1c06f2dfa4
    UITextField *textField = (UITextField *)notification.object;
    if (self.textField && [textField.accessibilityIdentifier isEqualToString:self.memoryAddress]) {
        
        // 过滤掉Emoji
        if ([textField.text hasEmoji]) {
            textField.text = [textField.text removedEmojiString];
        }
        
        NSString *toBeString = textField.text;
        
        //获取高亮部分
        UITextRange *selectedRange = [textField markedTextRange];
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制(8个字)
        if (!position){
            
            // 长度
            NSInteger maxLenght = self.maximumLength;
            
            if (toBeString.length > maxLenght){
                NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:maxLenght];
                if (rangeIndex.length == 1){
                    textField.text = [toBeString substringToIndex:maxLenght];
                } else {
                    NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, maxLenght)];
                    textField.text = [toBeString substringWithRange:rangeRange];
                }
            }
        }
        
        // 代理方法
        if ([self.delegate respondsToSelector:@selector(jk_textFieldDidChange:)]) {
            [self.delegate jk_textFieldDidChange:textField];
        }
    }
}

- (void)jk_trimmingCharactersForTextField:(UITextField *)textField {
    textField.text = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}


#pragma mark - UITextView


+ (instancetype)observerWithTextView:(UITextView *)textView {
    return [[self alloc]initWithTextView:textView];
}

- (instancetype)initWithTextView:(UITextView *)textView {
    if (self = [super init]) {
        self.textView = textView;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidChangeText:) name:UITextViewTextDidChangeNotification object:nil];
        self.isObserveTextField = false;
        self.maximumLength = kTextInputObserverDefaultLength;
    }return self;
}


- (void)setTextView:(UITextView *)textView {
    _textView = textView;
    if (textView) {
        textView.accessibilityIdentifier = [NSString stringWithFormat:@"%p",self];
        self.memoryAddress = textView.accessibilityIdentifier;
    } else {
        self.memoryAddress = nil;
    }
    
    if (self.isObserveTextField == true) {
        NSLog(@"======================== JKTextInputObserver  =========================");
        NSLog(@"============Error: 使用initWithTextField:实例后只能设置textField============");
        NSLog(@"======================== JKTextInputObserver  =========================");
    }
}


- (BOOL)jk_textView:(UITextView *)textView range:(NSRange)range shouldChangeString:(NSString *)string {
    if ([textView.accessibilityIdentifier isEqualToString:self.memoryAddress] == NO) {
        return YES;
    } else if (range.length >= 1 && [string isEqualToString:@""]) {
        return YES;// 删除
    } else if (textView.text.length >= self.maximumLength) {
        return false;
    } else if (
               (range.length != 1 && [string isEqualToString:@""]) ||
               ([string isEqualToString:@""] &&
                [string isKindOfClass:NSClassFromString(@"__NSCFString")] &&
                ![string isKindOfClass:NSClassFromString(@"__NSCFConstantString")]
                )
               ) {
        return NO;// 屏蔽iPad上的撤销输入功能(可以撤销删除)
    } else if (self.matchRegular){
        NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", self.matchRegular];
        return [regextestmobile evaluateWithObject:string];
    }
    
    
    // 过滤特殊字符
    NSCharacterSet * doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"'\"\\&+⛑⛸☘☄✨⛈⛷☃☂⛴⛰⛩⌨⏰⏲⏱⏳⚖⛏⚒⚙⛓☠⚔⚰⚱⚗⛱⛎✡☯☦☸☪✝☮❣❌⚛☢☣➿❎✅⚜❔❓❕✊⏸⏯⏹⏺⏭⏮⏩⏪⏫⏬〰➰➗➖➕©®™"];
    NSString * tempString = [[string componentsSeparatedByCharactersInSet:doNotWant]componentsJoinedByString:@""];
    BOOL ret = [string isEqualToString:tempString];
    return ret;
}



- (void)textViewDidChangeText:(NSNotification *)notification{
    // 限制输入文字的长度，兼容表情和拼音，http://www.jianshu.com/p/2d1c06f2dfa4
    UITextView *textView = (UITextView *)notification.object;
    if (self.textView && [textView.accessibilityIdentifier isEqualToString:self.memoryAddress]) {
        
        // 过滤掉Emoji
        if ([textView.text hasEmoji]) {
            textView.text = [textView.text removedEmojiString];
        }
        
        NSString *toBeString = textView.text;
        
        //获取高亮部分
        UITextRange *selectedRange = [textView markedTextRange];
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制(8个字)
        if (!position){
            
            // 长度
            NSInteger maxLenght = self.maximumLength;
            
            if (toBeString.length > maxLenght){
                NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:maxLenght];
                if (rangeIndex.length == 1){
                    textView.text = [toBeString substringToIndex:maxLenght];
                } else {
                    NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, maxLenght)];
                    textView.text = [toBeString substringWithRange:rangeRange];
                }
            }
        }
        
        // 代理方法
        if ([self.delegate respondsToSelector:@selector(jk_textViewDidChange:)]) {
            [self.delegate jk_textViewDidChange:textView];
        }
    }
}

- (void)jk_trimmingCharactersForTextView:(UITextView *)textView {
    textView.text = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
