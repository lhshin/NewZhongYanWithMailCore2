//
//  DataServiceURLs.m
//  NewZhongYan
//
//  Created by lilin on 13-10-15.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import "DataServiceURLs.h"
#import "LocalDataMeta.h"
#import "User.h"
@implementation DataServiceURLs
@synthesize metaURL;
@synthesize updateMetaURL;
@synthesize updateRangeURL;
@synthesize versionURL;
@synthesize searchURL;
@synthesize dataByIdURL;
@synthesize isExistedURL;
@synthesize rangeURL;
@synthesize postURL;
@synthesize attmsURL;

+(DataServiceURLs*)DataServicePath:(LocalDataMeta*)metaData
{
    DataServiceURLs* dataservice = [[DataServiceURLs alloc] init];
    NSString* dataProviderURL;
    NSString* datacode = [metaData.dataCode isEqualToString:@"semployee"] ? @"employee" : metaData.dataCode;
    if ([metaData isUserOwner]) {
        dataProviderURL = [NSString stringWithFormat:@"users/%@/%@/",[APPUtils userUid],datacode];
    }else{
        dataProviderURL = [NSString stringWithFormat:@"commons/%@/",datacode];
    }
    dataservice.metaURL = [NSString stringWithFormat:@"%@metadata",dataProviderURL];
    dataservice.versionURL = [NSString stringWithFormat:@"%@version",dataProviderURL];
    dataservice.searchURL = [NSString stringWithFormat:@"%@search",dataProviderURL];
    dataservice.postURL = [NSString stringWithFormat:@"%@post",dataProviderURL];
    dataservice.isExistedURL = [NSString stringWithFormat:@"%@exist",dataProviderURL];
    dataservice.rangeURL = [NSString stringWithFormat:@"%@range",dataProviderURL];
    dataservice.attmsURL = [NSString stringWithFormat:@"%@attms",dataProviderURL];
    dataservice.dataByIdURL = [NSString stringWithFormat:@"%@id",dataProviderURL];
    dataservice.updateMetaURL = [NSString stringWithFormat:@"%@vmeta",dataProviderURL];
    dataservice.updateRangeURL = [NSString stringWithFormat:@"%@vrange",dataProviderURL];
    return dataservice;
}

+(DataServiceURLs*)DataServiceURLs:(LocalDataMeta*)metaData
{
    DataServiceURLs* dataservice = [[DataServiceURLs alloc] init];
    NSString* dataProviderURL;
    NSString* datacode = [metaData.dataCode isEqualToString:@"semployee"] ? @"employee" : metaData.dataCode;

    if (metaData.isECM == YES) {
        if (metaData.pECMName.length>0) {
            metaData.pECMName = [metaData.pECMName stringByAppendingString:@"/"];
        }
        if ([metaData isUserOwner]) {
            dataProviderURL = [NSString stringWithFormat:@"%@/users/%@%@/",ZZZobt,metaData.pECMName,datacode];
        }else{
            dataProviderURL = [NSString stringWithFormat:@"%@/commons/%@%@/",ZZZobt,metaData.pECMName,datacode];
        }
        dataservice.ECMAllURL = [NSString stringWithFormat:@"%@all",dataProviderURL];
        dataservice.ECMVmetaURL = [NSString stringWithFormat:@"%@vmeta",dataProviderURL];
        dataservice.ECMVupdateURL = [NSString stringWithFormat:@"%@vupdate",dataProviderURL];
        dataservice.metaURL = [NSString stringWithFormat:@"%@vmeta",dataProviderURL];
    }else{
        if ([metaData isUserOwner]){
            dataProviderURL = [NSString stringWithFormat:@"%@/users/%@/%@/",ZZZobt,[APPUtils userUid],datacode];
        }else{
            dataProviderURL = [NSString stringWithFormat:@"%@/commons/%@/",ZZZobt,datacode];
        }
        dataservice.metaURL = [NSString stringWithFormat:@"%@metadata",dataProviderURL];
        dataservice.versionURL = [NSString stringWithFormat:@"%@version",dataProviderURL];
        dataservice.searchURL = [NSString stringWithFormat:@"%@search",dataProviderURL];
        dataservice.postURL = [NSString stringWithFormat:@"%@post",dataProviderURL];
        dataservice.isExistedURL = [NSString stringWithFormat:@"%@exist",dataProviderURL];
        dataservice.rangeURL = [NSString stringWithFormat:@"%@range",dataProviderURL];
        dataservice.attmsURL = [NSString stringWithFormat:@"%@attms",dataProviderURL];
        dataservice.dataByIdURL = [NSString stringWithFormat:@"%@id",dataProviderURL];
        dataservice.updateMetaURL = [NSString stringWithFormat:@"%@vmeta",dataProviderURL];
        dataservice.updateRangeURL = [NSString stringWithFormat:@"%@vrange",dataProviderURL];
    }
    return dataservice;
}




-(NSString*)ECMVmetaInfoWithVersion:(int)version
{
    return [self.ECMAllURL stringByAppendingFormat:@"?version=%d",version];
}

-(NSString*)ECMMetaInfoWithVersion:(int)version
{
    return [self.ECMVmetaURL stringByAppendingFormat:@"?version=%d",version];
}

-(NSString*)ECMVupdateDataWithVersion:(int)version
{
    return [self.ECMVupdateURL stringByAppendingFormat:@"?version=%d",version];
}

//下面都是属性方法重写
-(NSString*)dataByIdURL:(NSString*)idValue
{
    return [self.dataByIdURL stringByAppendingFormat:@"/%@",idValue];
}

-(NSString*)searchURL:(NSString*)searchKey
{
    return [self.searchURL stringByAppendingFormat:@"/%@",searchKey];
}

-(NSString*)updateRangeURL:(int)version from:(int)from length:(int)length
{
    return [self.updateRangeURL stringByAppendingFormat:@"/%d/%d/%d",version,from,length];
}

-(NSString*)updateMetaURL:(int)version
{
    return [self.updateMetaURL stringByAppendingFormat:@"/%d",version];
}

-(NSString*)rangeURL:(int)from length:(int)length
{
    return [self.rangeURL stringByAppendingFormat:@"/%d/%d",from,length];
}

-(NSString*)isExistedURL:(NSString*)idValue
{
    return [self.isExistedURL stringByAppendingFormat:@"/%@",idValue];
}

-(NSURL*)attmsURL:(NSString*)idValue attach:(NSString*)attachIdValue
{
    return [NSURL URLWithString:[[attmsURL stringByAppendingFormat:@"/%@/%@",idValue,attachIdValue] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}

+(NSURL*)mailAttcnURL:(NSString*)msgid AttchName:(NSString*)attsname
{
    return [NSURL URLWithString:[[NSString stringWithFormat:@"%@/users/%@/%@/mail/%@/%@/attms",ZZZobt,
                                  [APPUtils userUid],
                                  [APPUtils userPassword],
                                  msgid,
                                  attsname] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}

+(NSURL*)getSignature:(NSString*)uid TFRM:(NSString*)tfrm Style:(NSString*)signstyle
{
    return
    [NSURL URLWithString:[NSString stringWithFormat:
                          @"%@/users/%@/oa/%@/getSignature/%@",ZZZobt,uid,tfrm,signstyle]];
}

//⑵.获取业务实体数据详情（GET）
+(NSURL*)getWorkItemDetails:(NSString*)uid TFRM:(NSString*)tfrm AID:(NSString*)aid
{
    return
    [NSURL URLWithString:[NSString stringWithFormat:
                          @"%@/users/%@/oa/%@/getWorkItemDetails/%@",ZZZobt,uid,tfrm,aid]];
}
//获取程序最新版本
+(NSURL *)getNewVersion:(NSString *)version
{
   return [NSURL URLWithString:[NSString stringWithFormat:@"%@/commons/iphone-app/vrange/%@/1/1",ZZZobt,version]];
}

//注册当前设备
+(NSURL *)rigisterDevice
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/commons/client/regist",ZZZobt]];
}

+(NSURL*)getWorkedItemDetails:(NSString*)uid TFRM:(NSString*)tfrm flowinstanceid:(NSString*)fid
{
    return
    [NSURL URLWithString:[NSString stringWithFormat:
                          @"%@/users/%@/oa/%@/getWorkedItemDetails/%@",ZZZobt,uid,tfrm,fid]];
}

//getColumnDetail(String userid, String flowinstanceid, String uniqueid)
+(NSURL*)getColumnDetails:(NSString*)uid andFlowinstanceid:(NSString*)fid andUniqueid:(NSString *)uniqueid andFrom:(NSString *)from
{
    return
    [NSURL URLWithString:[NSString stringWithFormat:
                          @"%@/users/%@/oa/%@/getColumnDetail/%@/%@",ZZZobt,uid,from,fid,uniqueid]];
}
//⑴.保存业务数据（POST）
+(NSURL*)saveData
{
    return
    [NSURL URLWithString:[NSString stringWithFormat:@"%@/users/oa/saveData",ZZZobt]];
}

//⑶.获取历史办理记录 （GET）
+(NSURL*)getHistoryRecords:(NSString*)uid TFRM:(NSString*)tfrm FLOWINSTANCEID:(NSString*)fid
{
    return
    [NSURL URLWithString:[NSString stringWithFormat:
                          @"%@/users/%@/oa/%@/getHistoryRecords/%@",ZZZobt,uid,tfrm,fid]];
}

//(4).获取流程分支 （GET）
///users/{userid}/oa/{from}/getNextBranches/{workitemid}

+(NSURL*)getNextBranches:(NSString*)uid TFRM:(NSString*)tfrm AID:(NSString*)aid BID:(NSString*)bid
{
    return
    [NSURL URLWithString:[NSString stringWithFormat:
                          @"%@/users/%@/oa/%@/getNextBranches/%@/%@",ZZZobt,uid,tfrm,aid,bid]];
}

//(5).获取下一环节参与人 （GET）
///users/{userid}/oa/{from}/getParticipants/{workitemid}/{branchid}
+(NSURL*)getParticipants:(NSString*)uid TFRM:(NSString*)tfrm Workitemid:(NSString*)wid BranchId:(NSString*)bid
{
    NSString* urlstring = [[NSString stringWithFormat:
                            @"%@/users/%@/oa/%@/getParticipants/%@/%@",ZZZobt,uid,tfrm,wid,bid] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return[NSURL URLWithString:urlstring];
}

+(NSURL*)userClientAppAll
{
    return
    [NSURL URLWithString:[NSString stringWithFormat:@"%@/users/clientapp/all",ZZZobt]];
}

//(6).提交下环节（POST）
///users/oa/commitWorkItem
+(NSURL*)commitWorkItem
{
    return
    [NSURL URLWithString:[NSString stringWithFormat:@"%@/users/oa/commitWorkItem",ZZZobt]];
}

//(7)获取正文、附件等二进制文件（GET）
///users/{userid}/oa/{from}/getFile/{flowinstanceid}/{fileid}
+(NSURL*)getFile:(NSString*)uid TFRM:(NSString*)tfrm FLOWINSTANCEID:(NSString*)fid Filed:(NSString*)field
{
    return  [NSURL URLWithString:[[NSString stringWithFormat: @"%@/users/%@/oa/%@/getFile/%@/%@",ZZZobt,uid,tfrm,fid,field] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}
@end
