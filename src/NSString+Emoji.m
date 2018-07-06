//
//  NSString+Emoji.m
//  
//
//  Created by 蒋鹏 on 16/12/23.
//  Copyright © 2016年 溪枫狼. All rights reserved.
//

#import "NSString+Emoji.h"

@implementation NSString (Emoji)
- (BOOL)hasEmoji{
    __block BOOL value = NO;
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length])
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock: ^(NSString* substring, NSRange substringRange, NSRange enclosingRange, BOOL* stop) {
                              NSData *data = [substring dataUsingEncoding:NSUTF8StringEncoding];
                              if (data.length > 3) {
                                  value = YES;
                                  *stop = YES;
                              }
                          }];
    return value;
}


- (NSString *)removedEmojiString {
    NSMutableString* __block buffer = [NSMutableString stringWithCapacity:[self length]];
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length])
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock: ^(NSString* substring, NSRange substringRange, NSRange enclosingRange, BOOL* stop) {
                              [buffer appendString:([substring hasEmoji])? @"": substring];
                          }];
    return buffer.copy;
}

@end
