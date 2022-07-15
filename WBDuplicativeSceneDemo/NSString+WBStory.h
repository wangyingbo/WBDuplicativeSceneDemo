//
//  NSString+WBStory.h
//  Pods
//
//  Created by zhangjing13 on 17/3/13.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (WBStory)

/**
 *  字符串字数
 *  中文为 1 位，英文为 0.5 个
 *
 *  @return 字符串字数
 */
- (NSInteger)WBLStringCount;

- (NSUInteger)wbst_charIndexOfMaxWordCount:(NSUInteger)count; //word count

- (NSString *)wbst_stringWithMaxWordCount:(NSUInteger)count; //word count

+ (NSString *)wbst_shortStringForInt:(NSUInteger)number;

@end

@interface NSString (WBLChineseCharacter)


/**
 返回当前string 中汉字的个数

 @return 汉字个数
 */
- (NSInteger)chineseCharacterCount;


/**
 获取最大字符个数

 @param max 最大个数
 @return sub
 */
- (NSString *)subStringOfMaxLength:(NSInteger)max;



- (NSInteger)getStringLenthOfBytes;

- (NSString *)subBytesOfstringToIndex:(NSInteger)index;


/// 截取指定字符串汉字长度  （两个字母 算一个汉字长度），多余部分为....
/// @param index 汉字长度
- (NSString *)subStringEllipsisToIndex:(NSInteger)index;

@end

@interface NSString (WBFreshNewsTextFormat)
+ (NSString *)maxSourceTitle:(NSString *)str maxLen:(NSInteger)maxLen;
+ (NSInteger)sourceTitleLength:(NSString *)str;
@end


/*!
 *  文字计数相关工具方法
 */
@interface NSString (WBTCountWord)

/*!
 *  返回当前字符串的字数
 *
 *  @return 字数
 */
- (int)wbt_wordCount;

/*!
 *  返回 ASCII 字符的长度，如：英文占1，中文占2
 *
 *  @return 长度
 */
- (int)wbt_asciiCount;

/*!
 *  判断当前字符串是否有非空字符
 *
 *  @return YES为空，NO不为空
 */
- (BOOL)wbt_isEmpty;


@end
