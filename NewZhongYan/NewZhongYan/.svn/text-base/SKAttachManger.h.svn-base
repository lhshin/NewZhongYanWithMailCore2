//
//  SKAttachManger.h
//  NewZhongYan
//
//  Created by lilin on 13-10-24.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum
{
    SKNews,
    SKNotify,
    SKCodocs,
    SKWorkNews,
    SKMeet,
    SKAnnounce,
    SKECMInfo,
    SKMail
} SKDocType;    //列的类型 决定 列如何显示
@interface SKAttachManger : NSObject
{
    NSString        *tid;
    NSString        *paperID;
    NSString        *contentPath;
    NSMutableArray  *_attachItems;
    NSMutableDictionary    *_CMSInfo;
    NSString* tidPath;
    SKDocType   doctype;
}

@property SKDocType  doctype;
@property(nonatomic,strong)NSString *tid;
@property(nonatomic,strong)NSString *aid;
@property(nonatomic,strong)NSString *paperID;
@property(nonatomic,strong)NSMutableArray *attachItems;
@property(nonatomic,strong)NSMutableDictionary *CMSInfo;
@property(nonatomic,strong)NSDictionary *ECMInfo;

/**
 *  构造函数
 *
 *  @param cmsInfo 一条cms 信息 例如 一条新闻
 *
 *  @return 返回一个cms附件管理器
 */
-(id)initWithCMSInfo:(NSMutableDictionary*)cmsInfo;

/**
 *  判断内容附件本地是不是已经存在了
 *
 *  @return 是否存在
 */
-(BOOL)contentExisted;

/**
 *
 *
 *  @param path
 *
 *  @return
 */
-(BOOL)fileExisted:(NSString *) path;
/**
 *  判断图片本地是不是已经存在了
 
 *
 *  @return 是否存在
 */
-(BOOL)imageExisted;

/**
 *  主要用于新闻attach
 *
 *  @return 获取图片的路径
 */
-(NSString*)imagePath;

/**
 *  主要用于新闻attach
 *
 *  @return 获取图片的名字
 */
-(NSString*)imageName;

/**
 *  获取新闻图片的url
 *
 *  @return url
 */
-(NSURL*)imageURL;

/**
 *  获取新闻内容的url
 *
 *  @return url
 */
-(NSURL*)ContentURL;
/**
 *  判断是不图片新闻
 *
 *  @return 是不是图片新闻
 */
-(BOOL)pictureNews;//判断是不是图片新闻

/**
 *  判断是不是存在附件
 *
 *  @return 是否存在存在附件
 */
-(BOOL)containAttachement;

/**
 *  获取附件在本地的路径
 *
 *  @param attachName 附件名字
 *
 *  @return 附件路径
 */
-(NSString*)attachmentPathWithName:(NSString*)attachName;

/**
 *  判断某个附件是不是已经存在
 *
 *  @param attsName 附件名字
 *
 *  @return 是否存在
 */
-(BOOL)attachmentExisted:(NSString*)attsName;

/**
 *  tid唯一标示一条cms 信息
 *
 *  @return 返回tid文件夹是不是创建
 */
-(NSString*)TIDPath;

/**
 *  content cms 的详细内容
 *
 *  @return 详细内容存放的路径
 */
-(NSString*)contentPath;


#pragma mark -
#pragma mark ===========  ECM处理  =========
#pragma mark -
-(id)initWithECMInfo:(NSDictionary*)ecmInfo;

-(BOOL)ecmContentExistedWithOwnerApp:(NSString*)app;

-(NSString*)ecmContentPathWithOwnerApp:(NSString*)app;

-(NSString*)ecmAttachmentPathWithOwnerApp:(NSString*)app AttachName:(NSString*)filename;

//附件工具函数
/**
 *  该函数在搜索界面会用到 他会作为一个参数传给服务器
 *  每一项cms 内容都有对应的fid
 *  @param doctype 标识cms的种类 如是新闻还是
 *
 *  @return 对应app 的fid
 */
+(NSString*)fid:(SKDocType)doctype;

/**
 *  该函数在搜索界面会用到 根据查询的关键字返回对应的sql
 *
 *  @param doctype cms类型
 *  @param key     查询的关键字
 *
 *  @return sql语句
 */
+(NSString*)sql:(SKDocType)doctype keyWord:(NSString*)key;

/**
 *  该函数在搜索界面会用到 根据查询的关键字返回对应的sql
 *
 *  @param doctype cms类型
 *  @param key     查询的关键字数组
 *
 *  @return sql语句
 */
+(NSString*)sql:(SKDocType)doctype keyArray:(NSArray*)keyarray;

/**
 *  获取到cms 对应的表名字
 *
 *  @param doctype cms类型
 *
 *  @return表名字
 */
+(NSString*)tbname:(SKDocType)doctype;

/**
 *  根据cms类型决定查询结构跳到哪个界面
 *
 *  @param doctype cms类型
 *
 *  @return 附件详情对应的类名称
 */
+(NSString*)clsname:(SKDocType)doctype;

/**
 *  app 文件夹的路径
 *
 *  @return 路径
 */
+(NSString*)mailPath;
+(NSString*)meetPath;
+(NSString*)announcePath;
+(NSString*)codocsPath;
+(NSString*)workNewsPath;
+(NSString*)newsPath;
+(NSString*)notifyPath;
+(NSString *)remindPath;

/**
 *  保证获取路径的同事对应的文件一定被存在 因为如果不存在代码会自动创建
 *
 *  @param doctype cms类型
 *  @param tid     cms 标识
 *
 *  @return tid文件夹路径
 */
+(NSString*)TIDPath:(SKDocType)doctype Tid:(NSString*)tid;


/**
 *  保证获取路径的同事对应的文件一定被存在 因为如果不存在代码会自动创建
 *
 *  @param doctype 文件类型
 *  @param paperID paperID
 *
 *  @return 0
 */

/**
 *  <#Description#>
 *
 *  @param app     <#app description#>
 *  @param paperID <#paperID description#>
 *
 *  @return <#return value description#>
 */
+(NSString*)ecmDocPathWithOwnerApp:(NSString*)app paperId:(NSString*)paperID;

/**
 *  不能保证获取路径的同事对应的文件一定被存在 因为如果不存在代码也不会自动创建
 *
 *  @param doctype cms类型
 *  @param tid     cms 标识
 *
 *  @return tid文件夹路径
 */
+(NSString*)TIDPathWithOutCreate:(SKDocType)doctype Tid:(NSString *)tid;

/**
 *  获取待办aid 的路径  aid 什么意思还待标注
 *  保存文件夹一定存在 意思同上个函数一样
 *  @param aID 待办的aid
 *
 *  @return aid 的路径
 */
+(NSString *)aIDPath:(NSString*)aID;

/**
 *  获取待办aid 的路径
 *
 *  @param aID 待办的aid
 *
 *  @return aid 的路径
 */
+(NSString *)aIDPathWithoutCreate:(NSString*)aID;

/**
 * 获取邮件附件的路径
 * @param messageID   邮件的唯一ID
 * @param attchname   附件的名字
 **/
+(NSString*)mailAttachPath:(NSString*)messageID attchName:(NSString*)attchname;

/**
 * 判断邮件的附件是不是存在  如果不存在该函数会创建该文件(有没有必要创建待测试)
 * @param messageID   邮件的唯一ID
 * @param attchname   附件的名字
 **/
+(BOOL)mailAttachExisted:(NSString *)messageID  attchName:(NSString*)attsName;

/**
 * 获取cms附件的路径
 * @param messageID   邮件的唯一ID
 * @param attchname   附件的名字
 **/
@end
