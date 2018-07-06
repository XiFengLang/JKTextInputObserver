//
//  NSString+Emoji.h
//  
//
//  Created by 蒋鹏 on 16/12/23.
//  Copyright © 2016年 溪枫狼. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Emoji)

/**
 是否有Emoji
 
 @return hasEmoji
 */
- (BOOL)hasEmoji;



/**
 移除Emoji
 
 @return 移除Emoji
 */
- (NSString *)removedEmojiString;

@end
