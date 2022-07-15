//
//  NSString+WBStory.m
//  Pods
//
//  Created by zhangjing13 on 17/3/13.
//
//

#import "NSString+WBStory.h"

@implementation NSString (WBStory)

- (NSUInteger)wbst_charIndexOfMaxWordCount:(NSUInteger)count;
{
    if (count == 0) {
        return NSNotFound;
    }
    
    int i,l = 0, a = 0, b = 0;
    NSUInteger n = [self length];
    
    unichar c;
    
    for (i = 0; i < n; i++)
    {
        c = [self characterAtIndex:i];
        
        if (isblank(c))
        {
            b++;
        }
        else if (isascii(c))
        {
            a++;
        }
        else
        {
            l++;
        }
        
        int wordCount = l + (float)(a + b) / 2.0;
        if (wordCount == count) {
            return i;
        }
        
        if (wordCount > count) {
            return i - 1;
        }
    }

    return n - 1;
}

- (NSString *)wbst_stringWithMaxWordCount:(NSUInteger)count
{
    NSUInteger index = [self wbst_charIndexOfMaxWordCount:count];
    if (index == NSNotFound) {
        return nil;
    }
    
    if (self.length >= index + 1) {
        return [self substringToIndex:index + 1];
    }
    return nil;
}

+ (NSString *)wbst_shortStringForInt:(NSUInteger)number
{
    NSString *string = nil;
    if (number < 10000)
    {
        string = [NSString stringWithFormat:@"%i", (int)number];
    }
    else if (number < 100*10000)
    {
        string = [[NSString stringWithFormat:@"%.4f", (CGFloat)number/(10000)] wbst_removeFloatAllZero];
        NSDecimalNumber *number = [self wbst_deciamalNumberString:string scale:1];
        string = [NSString stringWithFormat:@"%@%@",number,@"万"];
    }else if(number < 10000*10000)
    {
        string = [NSString stringWithFormat:@"%i%@", (int)(number/10000), @"万"];
    }
    else
    {
        string = [[NSString stringWithFormat:@"%.8f", (CGFloat)number/(10000 *10000)] wbst_removeFloatAllZero];
        NSDecimalNumber *number = [self wbst_deciamalNumberString:string scale:1];
        string = [NSString stringWithFormat:@"%@%@",number,@"亿"];
    }
    return string;
}

- (NSString *)wbst_removeFloatAllZero
{
    NSString * tempNumber = self;
    NSString * outNumber = [NSString stringWithFormat:@"%@",@(tempNumber.floatValue)];
    return outNumber;
}

+ (NSDecimalNumber *)wbst_deciamalNumberString:(NSString *)numberStr scale:(NSInteger)scale
{
    NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:scale raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:YES];
    NSDecimalNumber *number = [NSDecimalNumber decimalNumberWithString:numberStr];
    return [number decimalNumberByRoundingAccordingToBehavior:roundUp];
}


@end

@implementation NSString (WBLChineseCharacter)

- (NSInteger)chineseCharacterCount{
    NSInteger count = 0;
    for (int i = 0; i < self.length; i++) {
        NSRange range = NSMakeRange(i, 1);
        NSString *charW = [self substringWithRange:range];
        const char *cChar = [charW UTF8String];
        if (cChar) {
            if (strlen(cChar) == 3) {
                count++;
            }
        }
    }
    return count;
}

- (NSString *)subStringOfMaxLength:(NSInteger)max{
    NSInteger last = 0;
    for (int i = 0; i < self.length ; i++) {
        if ([[self substringToIndex:i] lengthLongThen:max]) {
            break;
        }
        last = i;
    }
    return [self substringToIndex:(last)];
}

- (BOOL)lengthLongThen:(NSInteger)leng{
    float cnCharCount = [self chineseCharacterCount];
    float enCharCount = self.length - cnCharCount;
    
    if ((cnCharCount + enCharCount/2) > leng) {
        return YES;
    }
    return NO;
}

- (BOOL)includeChinese
{
    for(int i=0; i< [self length];i++)
    {
        int a =[self characterAtIndex:i];
        if( a >0x4e00&& a <0x9fff){
            return YES;
        }
    }
    return NO;
}

- (NSInteger)getStringLenthOfBytes
{
    NSInteger length = 0;
    for (int i = 0; i<[self length]; i++) {
        //截取字符串中的每一个字符
        NSString *s = [self substringWithRange:NSMakeRange(i, 1)];
        if ([self validateChineseChar:s]) {
            
            NSLog(@" s 打印信息:%@",s);
            
            length +=2;
        }else{
            length +=1;
        }
        
        NSLog(@" 打印信息:%@  %ld",s,(long)length);
    }
    return length;
}

- (NSString *)subStringEllipsisToIndex:(NSInteger)index
{
    if (self.length > index) {
        return [NSString stringWithFormat:@"%@....", [self subStringOfMaxLength:index]];
    }
    return self;
}


- (NSString *)subBytesOfstringToIndex:(NSInteger)index
{
    NSInteger length = 0;
    
    NSInteger chineseNum = 0;
    NSInteger zifuNum = 0;
    
    for (int i = 0; i<[self length]; i++) {
        //截取字符串中的每一个字符
        NSString *s = [self substringWithRange:NSMakeRange(i, 1)];
        if ([self validateChineseChar:s])
        {
            if (length + 2 > index)
            {
                return [self substringToIndex:chineseNum + zifuNum];
            }
            
            length +=2;
            
            chineseNum +=1;
        }
        else
        {
            if (length +1 >index)
            {
                return [self substringToIndex:chineseNum + zifuNum];
            }
            length+=1;
            
            zifuNum +=1;
        }
    }
    return [self substringToIndex:index];
}

//检测中文或者中文符号
- (BOOL)validateChineseChar:(NSString *)string
{
    NSString *nameRegEx = @"[\\u0391-\\uFFE5]";
    if (![string isMatchesRegularExp:nameRegEx]) {
        return NO;
    }
    return YES;
}

//检测中文
- (BOOL)validateChinese:(NSString*)string
{
    NSString *nameRegEx = @"[\u4e00-\u9fa5]";
    if (![string isMatchesRegularExp:nameRegEx]) {
        return NO;
    }
    return YES;
}

- (BOOL)isMatchesRegularExp:(NSString *)regex {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

@end


#define IS_CH_SYMBOL(chr) ((int)(chr)>127)
@implementation NSString (WBFreshNewsTextFormat)

+ (NSString *)maxSourceTitle:(NSString *)str maxLen:(NSInteger)maxLen
{
    NSInteger length = 0;
    NSString *string = nil;
    for (int i=0; i<str.length; i++) {
        unichar singleChar = [str characterAtIndex:i];
        if (IS_CH_SYMBOL(singleChar)) {
            length +=2;
        }else{
            length +=1;
        }
        
        if (length == maxLen-1) {
            if (IS_CH_SYMBOL([str  characterAtIndex:i+1])) {
                return [NSString stringWithFormat:@"%@",[str substringToIndex:i+1]];
            }
        }
        
        if (length == maxLen) {
            return [NSString stringWithFormat:@"%@",[str substringToIndex:i+1]];
        }
    }
    return string;
}
+ (NSInteger)sourceTitleLength:(NSString *)str
{
    NSInteger length = 0;
    for (int i =0; i<str.length; i++) {
        unichar singleChar = [str characterAtIndex:i];
        if (IS_CH_SYMBOL(singleChar)) {
            length +=2;
        }else{
            length +=1;
        }
    }
    return length;
}

@end
