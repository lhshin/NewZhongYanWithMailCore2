//
//  FileUtils.m
//  NewZhongYan
//
//  Created by lilin on 13-10-8.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import "FileUtils.h"
#include "sys/stat.h"
#include <dirent.h>
@implementation FileUtils

+ (long long) folderSizeAtPath:(NSString*) folderPath{
    return [self _folderSizeAtPath:[folderPath cStringUsingEncoding:NSUTF8StringEncoding]];
}

+ (long long) _folderSizeAtPath: (const char*)folderPath{
    long long folderSize = 0;
    DIR* dir = opendir(folderPath);
    if (dir == NULL) return 0;
    struct dirent* child;
    while ((child = readdir(dir))!=NULL) {
        if (child->d_type == DT_DIR && (
                                        (child->d_name[0] == '.' && child->d_name[1] == 0) || // 忽略目录 .
                                        (child->d_name[0] == '.' && child->d_name[1] == '.' && child->d_name[2] == 0) // 忽略目录 ..
                                        )) continue;
        
        size_t folderPathLength = strlen(folderPath);
        char childPath[1024]; // 子文件的路径地址
        stpcpy(childPath, folderPath);
        if (folderPath[folderPathLength-1] != '/'){
            childPath[folderPathLength] = '/';
            folderPathLength++;
        }
        stpcpy(childPath+folderPathLength, child->d_name);
        childPath[folderPathLength + child->d_namlen] = 0;
        if (child->d_type == DT_DIR){ // directory
            folderSize += [self _folderSizeAtPath:childPath]; // 递归调用子目录
            // 把目录本身所占的空间也加上
            struct stat st;
            if(lstat(childPath, &st) == 0) folderSize += st.st_size;
        }else if (child->d_type == DT_REG || child->d_type == DT_LNK){ // file or link
            struct stat st;
            if(lstat(childPath, &st) == 0) folderSize += st.st_size;
        }
    }
    closedir(dir);//add by lilin for leak
    return folderSize;
}

+ (NSString *)formattedFileSize:(unsigned long long)size
{
    //取整 edit by ysf
	NSString *formattedStr = nil;
    if (size == 0)
		formattedStr = @"0 B";
	else
		if (size > 0 && size < 1024)
            //			formattedStr = [NSString stringWithFormat:@"%qu bytes", size];
            formattedStr = [NSString stringWithFormat:@"%.0llu B", size];
        else
            if (size >= 1024 && size < pow(1024, 2))
                //                formattedStr = [NSString stringWithFormat:@"%.1f KB", (size / 1024.)];
                formattedStr = [NSString stringWithFormat:@"%.0f KB", (size / 1024.)];
            else
                if (size >= pow(1024, 2) && size < pow(1024, 3))
                    //                    formattedStr = [NSString stringWithFormat:@"%.2f MB", (size / pow(1024, 2))];
                    formattedStr = [NSString stringWithFormat:@"%.00f MB", (size / pow(1024, 2))];
                else
                    if (size >= pow(1024, 3))
                        //                        formattedStr = [NSString stringWithFormat:@"%.3f GB", (size / pow(1024, 3))];
                        formattedStr = [NSString stringWithFormat:@"%.00f GB", (size / pow(1024, 3))];
	return formattedStr;
}
+(BOOL)isElementVisible:(element*)e
{
    if (![[e.elementDict objectForKey:@"visible"] isEqualToString:@"false"]) {
        return YES;
    }else{
        return NO;
    }
}

+(SKColumnTyped)columnType:(column*)c
{
    NSString* typeString = [c.columnDict objectForKey:@"type"];
    if ([typeString hasPrefix:@"application"]) {
        return SKFile;
    }else if([typeString hasPrefix:@"text"]){
        return SKtext;
    }else if([typeString hasPrefix:@"mixed"]){
        return SKMixed;
    }else if([typeString hasPrefix:@"image"]){
        return SKImage;
    }else{
        return -1;
    }
}

//获取column类型
+(rwType)getRWType:(NSDictionary *)dic
{
    rwType result = rwTypeR;
    if ([dic.allKeys containsObject:@"extend"] && [[dic objectForKey:@"extend"] isEqualToString:@""]) {
        result = rwTypeW0;
    }
    
    if ([dic.allKeys containsObject:@"rw"]) {
        NSString *rwStr=[dic objectForKey:@"rw"];
        NSRange rangeR=[rwStr rangeOfString:@"r"];
        NSRange rangeW=[rwStr rangeOfString:@"w"];
        NSRange range0=[rwStr rangeOfString:@"0"];//不一定要必填
        NSRange range1=[rwStr rangeOfString:@"1"];//必填
        NSRange rangeA=[rwStr rangeOfString:@"a"];
        NSRange rangeS=[rwStr rangeOfString:@"s"];
        NSRange rangeD=[rwStr rangeOfString:@"d"];
        NSRange rangeI=[rwStr rangeOfString:@"i"];
        NSRange rangeB=[rwStr rangeOfString:@"b"];
        NSRange rangeN=[rwStr rangeOfString:@"n"];
        NSRange rangeT=[rwStr rangeOfString:@"t"];
        NSRange rangeE=[rwStr rangeOfString:@"e"];
        NSRange rangeU=[rwStr rangeOfString:@"u"];
        if (rangeR.location != NSNotFound)
        {
            result = rwTypeR;
        }
        
        if ([dic.allKeys containsObject:@"extend"] && [[dic objectForKey:@"extend"] isEqualToString:@"phrase"]) {
            result = rwTypeW0;
        }
        
        if (rangeW.location != NSNotFound)
        {
            if (range0.location != NSNotFound)
            {
                if (rangeA.location!=NSNotFound)
                {
                    result=rwTypeWA0;
                }
                else if(rangeB.location!=NSNotFound)
                {
                    result=rwTypeWB0;
                }
                else if(rangeD.location!=NSNotFound)
                {
                    result=rwTypeWD0;
                }
                else if(rangeS.location!=NSNotFound)
                {
                    result=rwTypeWS0;
                }
                else if(rangeI.location!=NSNotFound)
                {
                    result=rwTypeWI0;
                }
                else if(rangeN.location!=NSNotFound)
                {
                    result=rwTypeWN0;
                }
                else if(rangeT.location!=NSNotFound)
                {
                    result=rwTypeWT0;
                }
                else if(rangeE.location!=NSNotFound)
                {
                    result=rwTypeWE0;
                }
                else if(rangeU.location!=NSNotFound)
                {
                    result=rwTypeWU0;
                }
                else
                {
                    result =  rwTypeW0;
                }
            }
            else if(range1.location != NSNotFound)
            {
                if (rangeA.location!=NSNotFound)
                {
                    result=rwTypeWA1;
                }
                else if(rangeB.location!=NSNotFound)
                {
                    result=rwTypeWB1;
                }
                else if(rangeD.location!=NSNotFound)
                {
                    result=rwTypeWD1;
                }
                else if(rangeS.location!=NSNotFound)
                {
                    result=rwTypeWS1;
                }
                else if(rangeI.location!=NSNotFound)
                {
                    result=rwTypeWI1;
                }
                else if(rangeN.location!=NSNotFound)
                {
                    result=rwTypeWN1;
                }
                else if(rangeT.location!=NSNotFound)
                {
                    result=rwTypeWT1;
                }
                else if(rangeE.location!=NSNotFound)
                {
                    result=rwTypeWE1;
                }
                else if(rangeU.location!=NSNotFound)
                {
                    result=rwTypeWU1;
                }
                else
                {
                    result =  rwTypeW1;
                }
            }
        }
    }
    return result;
}

//针对代办的column 和element
+(BOOL)isWrited:(NSDictionary*)dict
{
    //rw
    if ([dict.allKeys containsObject:@"rw"]) {
        NSRange wRange = [[dict objectForKey:@"rw"] rangeOfString:@"w"];
        return wRange.location != NSNotFound;
    }
    
    //extend
    if ([dict.allKeys containsObject:@"extend"]) {
        return [[dict objectForKey:@"extend"] isEqualToString:@"phrase"];
    }
    return NO;
}

//数据的操作权限
+(BOOL)isWriteType:(NSString*)rwString
{
    if ( !rwString ||rwString.length > 3 || rwString.length < 1) {
        return NO;//因为默认是可读的
    }
    if ([rwString characterAtIndex:0] == 'w' ) {
        return YES;
    }else{
        return NO;
    }
}

+(BOOL)isCanBeNull:(NSString*)rwString
{
    if (!rwString || rwString.length > 3  || rwString.length < 1 ||[rwString characterAtIndex:rwString.length - 1] == '0' ) {
        return YES;
    }else{
        return NO;
    }
}

+(SKColumnRWTyped)ClassType:(NSString*)rwString
{
    if (!rwString || rwString.length > 3) {
        return -1;
    }
    SKColumnRWTyped result = 0;
    char c = [rwString characterAtIndex:1];
    switch (c) {
        case 'a':
            result = SKAnyType;
            break;
        case 's':
            result = SKStringType;
            break;
        case 'd':
            result = SKDateType;
            break;
        case 'i':
            result = SKIntType;
            break;
        case 'b':
            result = SKBinaryType;
            break;
        case 'n':
            result = SKNumberType;
            break;
        case 'e':
            result = SKMAilType;
            break;
        case 'u':
            result = SKUrlType;
            break;
        default:
            result = -1;
            break;
    }
    return result;
}

//插件的类型
+(SKExtendTyped)extendType:(column*)c
{
    NSString* extendstring = [c.columnDict objectForKey:@"extend"];
    if ([extendstring isEqualToString:@"phrase"]) {
        return SKPhrase;
    }else if([extendstring isEqualToString:@"phonecall"]){
        return SKPhonecall;
    }else if([extendstring isEqualToString:@"emailto"]){
        return SKEmailto;
    }else if([extendstring isEqualToString:@"signature"]){
        return SKSignature;
    }else if([extendstring isEqualToString:@"dateinput"]){
        return SKDateinput;
    }else {
        return SKNone;
    }
}

//插件的类型
+(SKExtendTyped)extendTypeWithElement:(element*)e
{
    NSString* extendstring = [e.elementDict objectForKey:@"extend"];
    if ([extendstring isEqualToString:@"phrase"]) {
        return SKPhrase;
    }else if([extendstring isEqualToString:@"phonecall"]){
        return SKPhonecall;
    }else if([extendstring isEqualToString:@"emailto"]){
        return SKEmailto;
    }else if([extendstring isEqualToString:@"signature"]){
        return SKSignature;
    }else if([extendstring isEqualToString:@"dateinput"]){
        return SKDateinput;
    }else if([extendstring isEqualToString:@"columndetail"]){
        return SKColumnDetail;
    }else {
        return SKNone;
    }
}


+ (NSString *)documentPath
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	return [paths objectAtIndex:0];
}

#pragma mark - 关于Plist的操作
//从plist文件中读数据 eg keyString 为 AllUnitLUPT 则是取得所有部门上次刷新的时间
//keyString 为 gpsw 则是取得保护密码
+(id)valueFromPlistWithKey:(NSString*)keyString
{
    NSString *filename=[[self documentPath] stringByAppendingPathComponent:@"config.plist"];
    return [[NSMutableDictionary dictionaryWithContentsOfFile:filename] objectForKey:keyString];
}

//写入plist文件 eg keyString 为 AllUnitLUPT 则是写入所有部门上次刷新的时间
//如果keyString为gpsw 则是设置保护密码
+(void)setvalueToPlistWithKey:(NSString*)keyString Value:(id)valueString
{
    NSString *filePath=[[self documentPath] stringByAppendingPathComponent:@"config.plist"];
    NSFileManager* fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:filePath])
    {
        [fileManager createFileAtPath:filePath contents:nil attributes:nil];
        NSMutableDictionary *dic=[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"1",@"2", nil];
        [dic writeToFile:filePath atomically:YES];
    }
    NSMutableDictionary* dict = [ [ NSMutableDictionary alloc ] initWithContentsOfFile:filePath];
    [ dict setObject:valueString forKey:keyString];
    [ dict writeToFile:filePath atomically:YES ];
}

+(NSMutableArray*)Phrase
{
    NSString *filename=[[self documentPath] stringByAppendingPathComponent:@"phrase.plist"];
    NSMutableArray* phrase = [[NSDictionary dictionaryWithContentsOfFile:filename] objectForKey:@"phrase"];
    return phrase;
}

+(void)setPhrase:(NSMutableArray*)phrase
{
    NSString *filePath=[[self documentPath] stringByAppendingPathComponent:@"phrase.plist"];
    NSFileManager* fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:filePath])
    {
        [fileManager createFileAtPath:filePath contents:nil attributes:nil];
    }
    NSMutableDictionary* dict = [ [ NSMutableDictionary alloc ] init];
    [ dict setObject:phrase forKey:@"phrase"];
    if (![ dict writeToFile:filePath atomically:YES ]) {
        NSLog(@"写入不成功");
    }
}
@end
