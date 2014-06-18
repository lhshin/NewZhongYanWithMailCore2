//
//  SKAttachManger.m
//  NewZhongYan
//
//  Created by lilin on 13-10-24.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import "SKAttachManger.h"
#import "DataServiceURLs.h"
@implementation SKAttachManger
@synthesize tid = _tid;
@synthesize aid = _aid;
@synthesize doctype = _doctype;
@synthesize paperID;

-(id)initWithCMSInfo:(NSMutableDictionary*)cmsInfo
{
    self = [super init];
    if (self) {
        self.CMSInfo = [NSMutableDictionary dictionaryWithDictionary:cmsInfo];
        self.tid = [cmsInfo objectForKey:@"TID"];
        self.doctype = SKNews;//默认值
        [self praseAttachmentItem];
    }
    return self;
}

-(id)initWithECMInfo:(NSDictionary*)ecmInfo
{
    self = [super init];
    if (self) {
        self.ECMInfo = [NSDictionary dictionaryWithDictionary:ecmInfo];
        self.paperID = ecmInfo[@"PAPERID"];
        self.doctype = SKECMInfo;//默认值
    }
    return self;
}

-(void)praseAttachmentItem
{
    _attachItems = [[NSMutableArray alloc] initWithCapacity:0];
    NSString* attachmentString = [_CMSInfo objectForKey:@"ATTS"] ;
    NSArray* tmp = [attachmentString componentsSeparatedByString:@","];
    for (__strong NSString* string in tmp) {
        string = [string stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\"[]"]];
        [_attachItems addObject:string];
    }
    [_attachItems removeObjectAtIndex:0];
}

-(NSString*)TIDPath
{
    return [SKAttachManger TIDPath:self.doctype Tid:self.tid];
}


-(BOOL)containAttachement
{
    return [_attachItems count] > 0;
}

-(BOOL)pictureNews
{
    return [self.attachItems count] > 0;
    /**
     *  后面的是备注的情况可能更加完善 但是现在用不到
     */
    return [[self.CMSInfo allKeys] containsObject:@"TNAME"]
    && [[self.CMSInfo objectForKey:@"TNAME"] isEqualToString:@"图片新闻"]
    && [self.attachItems count] > 1;
}

-(BOOL)imageExisted
{
    return [[NSFileManager defaultManager] fileExistsAtPath:[self imagePath] isDirectory:0];
}

-(NSString*)imageName
{
    return  [self pictureNews] ? [self.attachItems objectAtIndex:0] : nil;
}

-(NSString*)imagePath
{
    if (_attachItems.count > 0 && doctype == SKNews) {
        return [[self TIDPath] stringByAppendingPathComponent:[_attachItems objectAtIndex:0]];
    }else{
        return nil;
    }
}

-(NSURL*)imageURL
{
    DataServiceURLs* service = [DataServiceURLs DataServiceURLs:[LocalDataMeta sharedNews]];
    return [service attmsURL:[self imageName] attach:_tid];
}

//这里还需要改
-(NSURL*)ContentURL
{
    DataServiceURLs* service = [DataServiceURLs DataServiceURLs:[self metaData]];
    return [service attmsURL:@"CONTENT" attach:_tid];
}

-(BOOL)attachmentExisted:(NSString*)attsName
{
    return [[NSFileManager defaultManager] fileExistsAtPath:[self attachmentPathWithName:attsName] isDirectory:0];
}


-(NSString*)attachmentPathWithName:(NSString*)attachName
{
    if (_attachItems.count > 0 && [_attachItems containsObject:attachName]) {
        return [[self TIDPath] stringByAppendingPathComponent:attachName];
    }else{
        return nil;
    }
}

-(BOOL)fileExisted:(NSString *) path
{
    return [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:0];
}

-(BOOL)contentExisted
{
    return [[NSFileManager defaultManager] fileExistsAtPath:[self contentPath] isDirectory:0];
}

-(NSString*)contentPath
{
    return [[self TIDPath] stringByAppendingPathComponent:@"CONTENT"];
}

-(LocalDataMeta*)metaData
{
    switch (self.doctype) {
        case SKNews:
            return [LocalDataMeta sharedNews];
        case SKNotify:
            return [LocalDataMeta sharedNotify];
        case SKCodocs:
            return [LocalDataMeta sharedCompanyDocumentsType];
        case SKWorkNews:
            return [LocalDataMeta sharedWorkNews];
        case SKMeet:
            return [LocalDataMeta sharedMeeting];
        case SKAnnounce:
            return [LocalDataMeta sharedAnnouncement];
        default:
            return nil;
    }
}

+(NSString*)TIDPathWithOutCreate:(SKDocType)doctype Tid:(NSString *)tid
{
    NSString* path;
    switch (doctype) {
        case SKNews:
            path = [[self newsPath] stringByAppendingPathComponent:tid];
            break;
        case SKNotify:
            path = [[self notifyPath] stringByAppendingPathComponent:tid];
            break;
        case SKCodocs:
            path= [[self codocsPath] stringByAppendingPathComponent:tid];
            break;
        case SKWorkNews:
            path = [[self workNewsPath] stringByAppendingPathComponent:tid];
            break;
        case SKMeet:
            path = [[self meetPath] stringByAppendingPathComponent:tid];
            break;
        case SKAnnounce:
            path = [[self announcePath] stringByAppendingPathComponent:tid];
            break;
        default:
            path= nil;
            return nil;
    }
    return path;
}

+(NSString*)TIDPath:(SKDocType)doctype Tid:(NSString*)tid
{
    NSString* path;
    switch (doctype) {
        case SKNews:
            path = [[self newsPath] stringByAppendingPathComponent:tid];
            break;
        case SKNotify:
            path = [[self notifyPath] stringByAppendingPathComponent:tid];
            break;
        case SKMeet:
            path = [[self meetPath] stringByAppendingPathComponent:tid];
            break;
        case SKAnnounce:
            path = [[self announcePath] stringByAppendingPathComponent:tid];
            break;
        case SKCodocs:
            path= [[self codocsPath] stringByAppendingPathComponent:tid];
            break;
        case SKWorkNews:
            path = [[self workNewsPath] stringByAppendingPathComponent:tid];
            break;
        case SKMail:
            path = [[self mailPath] stringByAppendingPathComponent:tid];
            break;
        default:
            path= nil;
            return nil;
    }
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:0])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:0];
    }
    return path;
}

-(BOOL)ecmContentExistedWithOwnerApp:(NSString*)app
{
    NSString* apppath = [[SKAttachManger ecmDocPath] stringByAppendingPathComponent:app];
    if (![[NSFileManager defaultManager] fileExistsAtPath:apppath isDirectory:0])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:apppath withIntermediateDirectories:YES attributes:nil error:0];
    }
    return [[NSFileManager defaultManager] fileExistsAtPath:[self ecmContentPathWithOwnerApp:app] isDirectory:0];
}

-(NSString*)ecmContentPathWithOwnerApp:(NSString*)app
{
    NSString* apppath = [[SKAttachManger ecmDocPath] stringByAppendingPathComponent:app];
    if (![[NSFileManager defaultManager] fileExistsAtPath:apppath isDirectory:0])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:apppath withIntermediateDirectories:YES attributes:nil error:0];
    }
    return [[SKAttachManger ecmDocPathWithOwnerApp:app paperId:self.paperID] stringByAppendingPathComponent:@"CONTENT.xml"];
}

-(NSString*)ecmAttachmentPathWithOwnerApp:(NSString*)app AttachName:(NSString*)filename
{
    NSString* apppath = [[SKAttachManger ecmDocPath] stringByAppendingPathComponent:app];
    if (![[NSFileManager defaultManager] fileExistsAtPath:apppath isDirectory:0])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:apppath withIntermediateDirectories:YES attributes:nil error:0];
    }
    return [[SKAttachManger ecmDocPathWithOwnerApp:app paperId:self.paperID] stringByAppendingPathComponent:filename];
}

+(NSString*)ecmDocPathWithOwnerApp:(NSString*)app paperId:(NSString*)paperID
{
    NSString* appPath = [[self ecmDocPath] stringByAppendingPathComponent:app];
    if (![[NSFileManager defaultManager] fileExistsAtPath:appPath isDirectory:0])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:appPath withIntermediateDirectories:YES attributes:nil error:0];
    }
    
    NSString* paperIDPath = [appPath stringByAppendingPathComponent:paperID];
    if (![[NSFileManager defaultManager] fileExistsAtPath:paperIDPath isDirectory:0])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:paperIDPath withIntermediateDirectories:YES attributes:nil error:0];
    }
    
    return paperIDPath;
}

+(NSString *)aIDPathWithoutCreate:(NSString*)aID
{
    NSString* path=[[self remindPath] stringByAppendingPathComponent:aID];
    return path;
}

+(NSString *)aIDPath:(NSString*)aID
{
    NSString* path=[[self remindPath] stringByAppendingPathComponent:aID];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:0])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:0];
    }
    return path;
}


#pragma mark- 工具方法
+(NSString*)fid:(SKDocType)doctype
{
    switch (doctype)
    {
        case SKNews:
        {
            NSArray* fid = [[DBQueue sharedbQueue] recordFromTableBySQL:@"select TID from T_NEWSTP;"];
            if (fid.count == 0) {
                [SKDataDaemonHelper synWithMetaData:[LocalDataMeta sharedNewsType] delegate:0];
                return @"";
            }
            NSString* fidstring = @"";
            for (NSDictionary* dict in fid) {
                fidstring = [fidstring stringByAppendingFormat:@"%@,",[dict objectForKey:@"TID"]];
            }
            return[fidstring substringToIndex:fidstring.length - 1];
        }
        case SKNotify:
        {
            return @"9";
        }
        case SKAnnounce:
        {
            return @"4";
        }
        case SKMeet:
        {
            return @"31";
        }
        case SKWorkNews:
        {
            NSArray* fid = [[DBQueue sharedbQueue] recordFromTableBySQL:@"select TID from T_WORKNEWSTP;"];
            NSString* fidstring = @"";
            for (NSDictionary* dict in fid) {
                fidstring = [fidstring stringByAppendingFormat:@"%@:",[dict objectForKey:@"TID"]];
            }
            return[fidstring substringToIndex:fidstring.length - 1];
        }
        case SKCodocs:
        {
            return @"128";
        }
        default:
            return nil;
    }
}

+(NSString*)sql:(SKDocType)doctype keyWord:(NSString*)key
{
    switch (doctype)
    {
        case SKNews:
        {
            return [NSString stringWithFormat:
                    @"select TID,ATTS,TITL,CRTM,AUNAME,READED from T_NEWS where TITL LIKE '%%%@%%' AND ENABLED = 1 ORDER BY CRTM DESC ;",key];
        }
        case SKNotify:
        {
            return [NSString stringWithFormat:
                    @"SELECT TID,ATTS,TITL,CRTM,AUNAME,READED FROM T_NOTIFY WHERE TPID = '9' AND TITL LIKE '%%%@%%'  AND ENABLED = 1 ORDER BY CRTM DESC ;",key];
        }
        case SKAnnounce:
        {
            return [NSString stringWithFormat:
                    @"SELECT TID,ATTS,TITL,CRTM,AUNAME,READED FROM T_NOTIFY WHERE TPID = '4' AND TITL LIKE '%%%@%%'  AND ENABLED = 1 ORDER BY CRTM DESC ;",key];
        }
        case SKMeet:
        {
            return [NSString stringWithFormat:
                    @"SELECT TID,ATTS,TITL,CRTM,AUNAME,BGTM,EDTM FROM T_NOTIFY WHERE TPID = '31' AND TITL like '%%%@%%' AND ENABLED = 1  ORDER BY CRTM DESC  ;",key];
        }
        case SKCodocs:
        {
            return [NSString stringWithFormat:
                    @"select TID,CRTM,ATTS,READED,AUNAME,TITL FROM T_CODOCS WHERE TITL LIKE '%%%@%%' AND ENABLED = 1 ORDER BY CRTM DESC ;",key];
        }
        case SKWorkNews:
        {
            return [NSString stringWithFormat:
                    @"select TID,CRTM,FID,ATTS,READ,AUNAME,TITL FROM T_WORKNEWS WHERE TITL LIKE  '%%%@%%' AND ENABLED = 1 ORDER BY CRTM DESC ;",key];
        }
        default:
            return nil;
    }
}

+(NSString*)sql:(SKDocType)doctype keyArray:(NSArray*)keyarray
{
    NSString* key = [NSString string];
    for (NSString* k in keyarray) key = [key stringByAppendingFormat:@" AND TITL LIKE '%%%@%%'",k];
    key = [key substringFromIndex:4];
    switch (doctype)
    {
        case SKNews:
        {
            return [NSString stringWithFormat:
                    @"select ( case when(strftime('%%s','now','start of day','-8 hour','-1 day') >= strftime('%%s',crtm)) then 1 else 0 end ) as bz,TID,ATTS,TITL,strftime('%%Y-%%m-%%d %%H:%%M',CRTM) CRTM,AUNAME,READED from T_NEWS where (%@) AND ENABLED = 1 ORDER BY CRTM DESC ;",key];
        }
        case SKNotify:
        {
            return [NSString stringWithFormat:
                    @"SELECT (case when(strftime('%%s','now','start of day','-8 hour','-1 day') >= strftime('%%s',crtm)) then 1 else 0 end ) as bz,TID,ATTS,TITL,strftime('%%Y-%%m-%%d %%H:%%M',CRTM) CRTM,AUNAME,READED FROM T_NOTIFY WHERE (%@) AND TPID = '9'  AND ENABLED = 1 ORDER BY CRTM DESC ;",key];
        }
        case SKAnnounce:
        {
            return [NSString stringWithFormat:
                    @"SELECT (case when(strftime('%%s','now','start of day','-8 hour','-1 day') >= strftime('%%s',crtm)) then 1 else 0 end ) as bz,TID,ATTS,TITL,strftime('%%Y-%%m-%%d %%H:%%M',CRTM) CRTM,AUNAME,READED FROM T_NOTIFY WHERE (%@) AND TPID = '4' AND ENABLED = 1 ORDER BY CRTM DESC ;",key];
        }
        case SKMeet:
        {
            return [NSString stringWithFormat:
                    @"SELECT (case when(DATETIME(EDTM) > DATETIME('now','localtime')) then 1 else 0 end ) as bz,TID,ATTS,TITL,strftime('%%Y-%%m-%%d %%H:%%M',CRTM) CRTM,AUNAME,BGTM,EDTM FROM T_NOTIFY WHERE (%@) AND TPID = '31' AND ENABLED = 1  ORDER BY CRTM DESC  ;",key];
        }
        case SKCodocs:
        {
            return [NSString stringWithFormat:
                    @"select (case when(strftime('%%s','now','start of day','-8 hour','-1 day') >= strftime('%%s',crtm)) then 1 else 0 end ) as bz,TID,strftime('%%Y-%%m-%%d %%H:%%M',CRTM) CRTM,ATTS,READED,AUNAME,TITL FROM T_CODOCS WHERE (%@) AND ENABLED = 1 ORDER BY CRTM DESC ;",key];
        }
        case SKWorkNews:
        {
            return [NSString stringWithFormat:
                    @"select (case when(strftime('%%s','now','start of day','-8 hour','-1 day') >= strftime('%%s',crtm)) then 1 else 0 end ) as bz,TID,strftime('%%Y-%%m-%%d %%H:%%M',CRTM) CRTM,FID,ATTS,READ,AUNAME,TITL FROM T_WORKNEWS WHERE (%@) AND ENABLED = 1 ORDER BY CRTM DESC ;",key];
        }
        default:
            return nil;
    }
}

+(NSString*)tbname:(SKDocType)doctype
{
    switch (doctype)
    {
        case SKNews:
        {
            return @"T_NEWS WHERE ";
        }
        case SKNotify:
        {
            return @"T_NOTIFY WHERE TPID = '9' AND ";
        }
        case SKAnnounce:
        {
            return @"T_NOTIFY WHERE TPID = '4' AND ";
        }
        case SKMeet:
        {
            return @"T_NOTIFY WHERE TPID = '31' AND ";
        }
        case SKCodocs:
        {
            return @"T_CODOCS WHERE ";
        }
        case SKWorkNews:
        {
            return @"T_WORKNEWS WHERE ";
        }
        default:
            return nil;
    }
}

+(NSString*)clsname:(SKDocType)doctype
{
    switch (doctype)
    {
        case SKNews:
        {
            return @"SKNewsAttachController";
        }
        case SKNotify:
        {
            return @"SKAttachmentController";
        }
        case SKAnnounce:
        {
            return @"SKAttachmentController";
        }
        case SKMeet:
        {
            return @"SKAttachmentController";
        }
        case SKCodocs:
        {
            return @"SKCompIssueDetailController";
        }
        case SKWorkNews:
        {
            return @"SKWorkNewsDetailController";
        }
        default:
            return nil;
    }
}

#pragma mark - 文件路径共有函数
+(NSString*)mailAttachPath:(NSString*)messageID attchName:(NSString*)attchname
{
    return [[[self mailPath] stringByAppendingPathComponent:messageID]stringByAppendingPathComponent:attchname];
}

+(BOOL)mailAttachExisted:(NSString *)messageID  attchName:(NSString*)attsName
{
    NSString* TIDPath = [[self mailPath] stringByAppendingPathComponent:messageID];//这里保证notify 文件一定存在
    if ([[NSFileManager defaultManager] fileExistsAtPath:TIDPath isDirectory:0])
    {
        return [[NSFileManager defaultManager] fileExistsAtPath:[TIDPath stringByAppendingPathComponent:attsName] isDirectory:0];
    }else{
        [[NSFileManager defaultManager] createDirectoryAtPath:TIDPath withIntermediateDirectories:YES attributes:nil error:0];
        return NO;
    }
}

+(NSString*)ecmDocPath
{
    NSError* error = nil;
    NSString* ecmPath = [[FileUtils documentPath] stringByAppendingPathComponent:@"ecm"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:ecmPath isDirectory:0]){
        [[NSFileManager defaultManager] createDirectoryAtPath:ecmPath  withIntermediateDirectories:YES attributes:nil error:&error];
    }
    return ecmPath;
}

+(NSString*)codocsPath
{
    NSError* error = nil;
    NSString* codocsPath = [[FileUtils documentPath] stringByAppendingPathComponent:@"codocs"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:codocsPath isDirectory:0]){
        [[NSFileManager defaultManager] createDirectoryAtPath:codocsPath  withIntermediateDirectories:YES attributes:nil error:&error];
    }
    return codocsPath;
}

+(NSString*)workNewsPath
{
    NSError* error = nil;
    NSString* workNewsPath = [[FileUtils documentPath] stringByAppendingPathComponent:@"worknews"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:workNewsPath isDirectory:0]){
        [[NSFileManager defaultManager] createDirectoryAtPath:workNewsPath withIntermediateDirectories:YES attributes:nil error:&error];
    }
    return workNewsPath;
}

+(NSString*)newsPath
{
    NSString* newsPath = [[FileUtils documentPath] stringByAppendingPathComponent:@"news"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:newsPath isDirectory:0]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:newsPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return newsPath;
}

+(NSString*)notifyPath
{
    NSString* newsPath = [[FileUtils documentPath] stringByAppendingPathComponent:@"notify"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:newsPath isDirectory:0]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:newsPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return newsPath;
}

+(NSString*)meetPath
{
    NSString* newsPath = [[FileUtils documentPath] stringByAppendingPathComponent:@"meet"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:newsPath isDirectory:0]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:newsPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return newsPath;
}

+(NSString*)announcePath
{
    NSString* newsPath = [[FileUtils documentPath] stringByAppendingPathComponent:@"announcement"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:newsPath isDirectory:0]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:newsPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return newsPath;
}

+(NSString *)remindPath
{
    NSString* remindPath = [[FileUtils documentPath] stringByAppendingPathComponent:@"remind"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:remindPath isDirectory:0]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:remindPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return remindPath;
}

+(NSString *)mailPath
{
    NSString* mailPath = [[FileUtils documentPath] stringByAppendingPathComponent:@"mail"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:mailPath isDirectory:0])  {
        [[NSFileManager defaultManager] createDirectoryAtPath:mailPath withIntermediateDirectories:YES attributes:nil error:0];
        
    }
    return mailPath;
}
@end
