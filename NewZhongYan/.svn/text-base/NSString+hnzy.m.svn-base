//
//  NSString+hnzy.m
//  NewZhongYan
//
//  Created by lilin on 13-10-29.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import "NSString+hnzy.h"

@implementation NSString (hnzy)
-(BOOL)firstCharaterNumber
{
    char ch = [self characterAtIndex:0];
    return ((ch>=48) && (ch<=57));
}

-(NSMutableArray*)componentsSeparatedByWhiteSpace
{
    //将字符串分割 但是分割的模块中可能有 "" 这种要去掉
    NSCharacterSet *whitespaces = [NSCharacterSet whitespaceCharacterSet];
    NSArray *parts = [self componentsSeparatedByCharactersInSet:whitespaces];
    
    //用正则去掉其中的""
    NSPredicate *noEmptyStrings = [NSPredicate predicateWithFormat:@"SELF != ''"];
    NSMutableArray *filteredArray = [NSMutableArray arrayWithArray:[parts filteredArrayUsingPredicate:noEmptyStrings]];
    if (filteredArray.count > 1) {
        [filteredArray addObject: [filteredArray componentsJoinedByString:@" "]];
    }
    return filteredArray;
}

//不加上原来的字符创的组合
-(NSMutableArray*)componentsSeparatedByWhiteSpaceWithoutself
{
    //将字符串分割 但是分割的模块中可能有 "" 这种要去掉
    NSCharacterSet *whitespaces = [NSCharacterSet whitespaceCharacterSet];
    NSArray *parts = [self componentsSeparatedByCharactersInSet:whitespaces];
    
    //用正则去掉其中的""
    NSPredicate *noEmptyStrings = [NSPredicate predicateWithFormat:@"SELF != ''"];
    return[NSMutableArray arrayWithArray:[parts filteredArrayUsingPredicate:noEmptyStrings]];
}
@end
