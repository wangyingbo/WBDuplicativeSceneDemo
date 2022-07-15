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
