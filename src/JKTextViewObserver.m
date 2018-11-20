//
//  JKTextViewObserver.m
//  
//
//  Created by 蒋鹏 on 16/9/18.
//  Copyright © 2016年 www.sinterchina.com. All rights reserved.
//

#import "JKTextViewObserver.h"
#import "NSString+Emoji.h"

@interface JKTextViewObserver ()

@property (nonatomic, copy)NSString * memoryAddress;


@end




@implementation JKTextViewObserver

static const NSInteger kUserNameMaxLength = 11;


+ (instancetype)observerWithTextView:(UITextView *)textView {
    return [[JKTextViewObserver alloc]initWithTextView:textView];
}

- (instancetype)initWithTextView:(UITextView *)textView {
    if (self = [super init]) {
        self.textView = textView;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidChangeText:) name:UITextViewTextDidChangeNotification object:nil];
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
}


- (BOOL)jk_textView:(UITextView *)textView range:(NSRange)range shouldChangeString:(NSString *)string {
    if ([textView.accessibilityIdentifier isEqualToString:self.memoryAddress] == NO) {
        return YES;
    } else if (range.length >= 1 && [string isEqualToString:@""]) {
        return YES;// 删除
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
            NSInteger maxLenght = kUserNameMaxLength;
            if (self.maximumLength) {
                maxLenght = self.maximumLength;
            }
            
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
