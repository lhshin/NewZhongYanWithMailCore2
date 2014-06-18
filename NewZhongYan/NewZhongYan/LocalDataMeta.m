//
//  LocalDataMeta.m
//  NewZhongYan
//
//  Created by lilin on 13-10-15.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import "LocalDataMeta.h"
static LocalDataMeta * sharedEmployee = nil;
static LocalDataMeta * sharedSelfEmployee = nil;
static LocalDataMeta * sharedUnit = nil;
static LocalDataMeta * sharedOranizational = nil;
static LocalDataMeta * sharedNews = nil;
static LocalDataMeta * sharedNewsType = nil;
static LocalDataMeta * sharedNotify = nil;
static LocalDataMeta * sharedMeeting = nil;
static LocalDataMeta * sharedAnnouncement = nil;
static LocalDataMeta * sharedRemind = nil;
static LocalDataMeta * sharedCMS = nil;
static LocalDataMeta * sharedVersionInfo = nil;
static LocalDataMeta * sharedCompanyDocuments = nil;
static LocalDataMeta * sharedCompanyDocumentsType = nil;
static LocalDataMeta * sharedWorkNews = nil;
static LocalDataMeta * sharedWorkNewsType = nil;
static LocalDataMeta * sharedMail = nil;
/**
 *  ECM
 */
static LocalDataMeta * sharedClientApp = nil;
static LocalDataMeta * sharedChannel = nil;
static LocalDataMeta * sharedChannelType = nil;

@implementation LocalDataMeta
@synthesize dataCode;
@synthesize messageCode;
@synthesize localName;
@synthesize identityName;
@synthesize updateTime;
@synthesize version;
@synthesize reInitDelay;
@synthesize userOwner;
@synthesize pageSize;
#pragma mark - 单例模式的一些实现实现一些全局唯一的变量及访问方式

//第一种构造方式
-(id)initWithDataCode:(NSString*)_datacode
          messageCode:(NSString*)_messagecode
            tablename:(NSString*)_tableName
         identityName:(NSString*)_identityname
              version:(NSInteger)_version
{
    self = [super init];
    if (self) {
        self.dataCode     = _datacode;          //数据代码
        self.messageCode  = _messagecode;       //消息代码
        self.localName    = _tableName;         //本地缓存的名称（一般是数据库的表名）
        self.identityName = _identityname;      //主键名称
        self.version      = _version;
        self.updateTime   =0;
        self.pageSize = 1000;
        
        self.isExistedSnap = NO;
        self.lastcount = 0;
        self.lastfrom = 0;
        self.lastupdatetime = 0;
    }
    return self;
}

-(id)initWithSelfEmployee
{
    return  [self initWithDataCode:@"semployee"
                       messageCode:@"USER"
                         tablename:@"S_EMPLOYEE"
                      identityName:@"UID"
                           version:0];
}

-(id)initWithVersionInfo
{
    return  [self initWithDataCode:@"versioninfo"
                       messageCode:@"VERSIONINFO"
                         tablename:@"T_VERSIONINFO"
                      identityName:@"NAME"
                           version:0
             ];
}

-(id)initWithEmployee
{
    return  [self initWithDataCode:@"employee"
                       messageCode:@"USER"
                         tablename:@"T_EMPLOYEE"
                      identityName:@"UID"
                           version:0];
}

-(id)initWithUnit
{
    return  [self initWithDataCode:@"unit"
                       messageCode:@"UNIT"
                         tablename:@"T_UNIT"
                      identityName:@"DPID"
                           version:0];
}

-(id)initWithOranizational
{
    return  [self initWithDataCode:@"organizational"
                       messageCode:@"ORG"
                         tablename:@"T_ORGANIZATIONAL"
                      identityName:@"CID"
                           version:0];
}

-(id)initWithNewsType
{
    return  [self initWithDataCode:@"newstype"
                       messageCode:@"NEWS_TYPE"
                         tablename:@"T_NEWSTP"
                      identityName:@"TID"
                           version:0
             ];
}

-(id)initWithNews
{
    return  [self initWithDataCode:@"news"
                       messageCode:@"NEWS"
                         tablename:@"T_NEWS"
                      identityName:@"TID"
                           version:0];
}

-(id)initWithCMS
{
    return  [self initWithDataCode:@"notify"
                       messageCode:@"NOTIFY"
                         tablename:@"T_NOTIFY"
                      identityName:@"TID"
                           version:0];
}

-(id)initWithNotify
{
    return  [self initWithDataCode:@"notify/9"
                       messageCode:@"NOTIFY"
                         tablename:@"T_NOTIFY"
                      identityName:@"TID"
                           version:0];
}

-(id)initWithMeeting
{
    return  [self initWithDataCode:@"notify/31"
                       messageCode:@"NOTIFY"
                         tablename:@"T_NOTIFY"
                      identityName:@"TID"
                           version:0];
}

-(id)initWithAnnouncement
{
    return  [self initWithDataCode:@"notify/4"
                       messageCode:@"NOTIFY"
                         tablename:@"T_NOTIFY"
                      identityName:@"TID"
                           version:0];
}

-(id)initWithRemind
{
    return  [self initWithDataCode:@"remind"
                       messageCode:@"REMIND"
                         tablename:@"T_REMINDS"
                      identityName:@"AID"
                           version:0];
}

-(id)initWithCompanyDocuments
{
    return  [self initWithDataCode:@"codocs"
                       messageCode:@"CODOCS"
                         tablename:@"T_CODOCS"
                      identityName:@"TID"
                           version:0];
}

-(id)initWithCompanyDocumentsType
{
    return  [self initWithDataCode:@"codocstype"
                       messageCode:@"CODOCS_TYPE"
                         tablename:@"T_CODOCSTP"
                      identityName:@"TID"
                           version:0
             ];
}

//
-(id)initWithWorkNews
{
    return  [self initWithDataCode:@"worknews"
                       messageCode:@"WORKNEWS"
                         tablename:@"T_WORKNEWS"
                      identityName:@"TID"
                           version:0];
}

-(id)initWithWorkNewsType
{
    return  [self initWithDataCode:@"worknewstype"
                       messageCode:@"WORKNEWS_TYPE"
                         tablename:@"T_WORKNEWSTP"
                      identityName:@"TID"
                           version:0
             ];
}

-(id)initWithMail
{
    return  [self initWithDataCode:@"mail"
                       messageCode:@"LOCALMESSAGE"
                         tablename:@"T_LOCALMESSAGE"
                      identityName:@"MESSAGEID"
                           version:0];
}

-(id)initWithClientApp
{
    return  [self initWithDataCode:@"clientapp"
                       messageCode:@"CLIENTAPP"
                         tablename:@"T_CLIENTAPP"
                      identityName:@"CODE"
                           version:0];
}

-(id)initWithChannel
{
    return  [self initWithDataCode:@"channel"
                       messageCode:@"CHANNEL"
                         tablename:@"T_CHANNEL"
                      identityName:@"CODE"
                           version:0];
}

/**
 *  像工作动态 公司公文 可能会用到这个接口
 *
 *  @return
 */
-(id)initWithChannelType
{
    return  [self initWithDataCode:@"channeltp"
                       messageCode:@"CHANNELTP"
                         tablename:@"T_CHANNELTP"
                      identityName:@"CODE"
                           version:0];
}

+ (LocalDataMeta *)sharedEmployee{
    @synchronized(self){
        if (!sharedEmployee) {
            sharedEmployee = [[LocalDataMeta alloc] initWithEmployee];
        }
        return sharedEmployee;
    }
}

+ (LocalDataMeta *)sharedSelfEmployee{
    @synchronized(self){
        if (!sharedSelfEmployee) {
            sharedSelfEmployee = [[LocalDataMeta alloc] initWithSelfEmployee];
            [sharedSelfEmployee setUserOwner:YES];
        }
        return sharedSelfEmployee;
    }
}

+ (LocalDataMeta *)sharedVersionInfo{
    @synchronized(self){
        if (!sharedVersionInfo) {
            sharedVersionInfo = [[LocalDataMeta alloc] initWithVersionInfo];
            [sharedVersionInfo setUserOwner:YES];
        }
        return sharedVersionInfo;
    }
}

+ (LocalDataMeta *)sharedUnit{
    @synchronized(self){
        if (!sharedUnit) {
            sharedUnit = [[LocalDataMeta alloc] initWithUnit];
        }
        return sharedUnit;
    }
}

+ (LocalDataMeta *)sharedOranizational{
    @synchronized(self){
        if (!sharedOranizational) {
            sharedOranizational = [[LocalDataMeta alloc] initWithOranizational];
        }
        return sharedOranizational;
    }
}

+ (LocalDataMeta *)sharedNews{
    @synchronized(self){
        if (!sharedNews) {
            sharedNews = [[LocalDataMeta alloc] initWithNews];
            [sharedNews setUserOwner:YES];
        }
        return sharedNews;
    }
}

+ (LocalDataMeta *)sharedNewsType{
    @synchronized(self){
        if (!sharedNewsType) {
            sharedNewsType = [[LocalDataMeta alloc] initWithNewsType];
        }
        return sharedNewsType;
    }
}

+ (LocalDataMeta *)sharedCMS{
    @synchronized(self){
        if (!sharedCMS) {
            sharedCMS = [[LocalDataMeta alloc] initWithCMS];
        }
        return sharedCMS;
    }
}

+ (LocalDataMeta *)sharedNotify{
    @synchronized(self){
        if (!sharedNotify) {
            sharedNotify = [[LocalDataMeta alloc] initWithNotify];
            [sharedNotify setUserOwner:YES];
        }
        return sharedNotify;
    }
}

+ (LocalDataMeta *)sharedMeeting{
    @synchronized(self){
        if (!sharedMeeting) {
            sharedMeeting = [[LocalDataMeta alloc] initWithMeeting];
            [sharedMeeting setUserOwner:YES];
        }
        return sharedMeeting;
    }
}

+ (LocalDataMeta *)sharedAnnouncement{
    @synchronized(self){
        if (!sharedAnnouncement) {
            sharedAnnouncement = [[LocalDataMeta alloc] initWithAnnouncement];
            [sharedAnnouncement setUserOwner:YES];
        }
        return sharedAnnouncement;
    }
}
+ (LocalDataMeta *)sharedRemind{
    @synchronized(self){
        if (!sharedRemind) {
            sharedRemind = [[LocalDataMeta alloc] initWithRemind];
            [sharedRemind setUserOwner:YES];
        }
        return sharedRemind;
    }
}

+ (LocalDataMeta *)sharedCompanyDocuments{
    @synchronized(self){
        if (!sharedCompanyDocuments) {
            sharedCompanyDocuments = [[LocalDataMeta alloc] initWithCompanyDocuments];
            [sharedCompanyDocuments setUserOwner:YES];
        }
        return sharedCompanyDocuments;
    }
}


+ (LocalDataMeta *)sharedCompanyDocumentsType{
    @synchronized(self){
        if (!sharedCompanyDocumentsType) {
            sharedCompanyDocumentsType = [[LocalDataMeta alloc] initWithCompanyDocumentsType];
        }
        return sharedCompanyDocumentsType;
    }
}


+ (LocalDataMeta *)sharedWorkNews{
    @synchronized(self){
        if (!sharedWorkNews) {
            sharedWorkNews = [[LocalDataMeta alloc] initWithWorkNews];
            [sharedWorkNews setUserOwner:YES];
        }
        return sharedWorkNews;
    }
}

+ (LocalDataMeta *)sharedWorkNewsType{
    @synchronized(self){
        if (!sharedWorkNewsType) {
            sharedWorkNewsType = [[LocalDataMeta alloc] initWithWorkNewsType];
        }
        return sharedWorkNewsType;
    }
}

+ (LocalDataMeta *)sharedMail{
    @synchronized(self){
        if (!sharedMail) {
            sharedMail = [[LocalDataMeta alloc] initWithMail];
            [sharedMail setUserOwner:YES];
        }
        return sharedMail;
    }
}

+ (LocalDataMeta *)sharedClientApp
{
    @synchronized(self){
        if (!sharedClientApp) {
            sharedClientApp = [[LocalDataMeta alloc] initWithClientApp];
            [sharedClientApp setIsECM:YES];
            [sharedClientApp setUserOwner:YES];
            [sharedClientApp setPECMName:@""];
        }
        return sharedClientApp;
    }
}

+ (LocalDataMeta *)sharedChannel
{
    @synchronized(self){
        if (!sharedChannel) {
            sharedChannel = [[LocalDataMeta alloc] initWithChannel];
            [sharedChannel setIsECM:YES];
        }
        return sharedChannel;
    }
}

+ (LocalDataMeta *)sharedChannelType
{
    @synchronized(self){
        if (!sharedChannelType) {
            sharedChannelType = [[LocalDataMeta alloc] initWithChannelType];
            [sharedChannelType setIsECM:YES];
        }
        return sharedChannelType;
    }
}

//是不是存在没有下载完成的数据
-(BOOL)isInitDataSnapped
{
    @synchronized(self)
    {
        return  self.isExistedSnap     //注意这里不能用nil
        && self.lastcount > 0
        && self.lastversion  > 0
        && self.lastfrom > 0
        && (self.lastfrom < self.lastcount);//??
    }
}

//判断数据是不是本地化过了，（不管是处于初始化阶段 还是在增量更新阶段）
-(BOOL)isDataLocalRooted
{
    @synchronized(self)
    {
        return version > 0 || [self isInitDataSnapped];
    }
}

//完成初始化后调用  会把舒适化的元信息版本设置到数据的当前版本中 然后初始化元信息
-(void) afterFinishedInitData
{
    @synchronized(self)
    {
        self.isExistedSnap = NO;
        self.version = self.lastversion;
    }
}

-(void)snapInitDataWithVersion:(int)theVersion lastCount:(int)lastcount lastFrom:(int)lastfrom Date:(NSString*)uptime
{
    @synchronized(self)
    {
        self.isExistedSnap = YES;
        NSParameterAssert(uptime.length > 0);
        self.lastversion = theVersion;
        self.lastcount = lastcount;
        self.lastupdatetime = uptime;
        self.lastfrom = lastfrom;
    }
}

//这里还待理解
-(BOOL)isUserOwner
{
    return userOwner;
}

@end
