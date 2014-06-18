//
//  SKECMURLManager.m
//  NewZhongYan
//
//  Created by lilin on 13-12-19.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import "SKECMURLManager.h"

@implementation SKECMURLManager
+(NSURL*)getAllClientApp
{
//    return
//    [NSURL URLWithString:[NSString stringWithFormat:@"http://tam.hngytobacco.com/ZZZobta/aaa-agents/avs/users/coworknews/docs/all"]];
    return
    [NSURL URLWithString:[NSString stringWithFormat:@"%@/users/clientapp/all",ZZZobt]];    
}

+(NSURL*)getClientAppVMetaInfoWithVersion:(int)version
{
    return
    [NSURL URLWithString:[NSString stringWithFormat:@"%@/users/clientapp/vmeta?version=%d",ZZZobt,version]];
}

+(NSURL*)getUpdateClientAppWithVersion:(int)version
{
    return
    [NSURL URLWithString:[NSString stringWithFormat:@"%@/users/clientapp/vupdate?version=%d",ZZZobt,version]];
}

+(NSURL*)getUpdateClientAppWithClientCode:(NSString*)code QueryDate:(NSString*)date
{
    return
    [NSURL URLWithString:[NSString stringWithFormat:@"%@/users/%@/ecm/datainfo?queryDateTime=%@",ZZZobt,code,@"0"]];
}

+(NSURL*)getAllChannelWithAppCode:(NSString*)code
{
    return
    [NSURL URLWithString:[NSString stringWithFormat:@"%@/commons/%@/channel/all",ZZZobt,code]];
}

+(NSURL*)getChannelVmetaInfoWithAppCode:(NSString*)code ChannelVersion:(int)version{
    return
    [NSURL URLWithString:[NSString stringWithFormat:@"%@/commons/%@/channel/vmeta?version=%d",ZZZobt,code,version]];
}

+(NSURL*)getChannelUpdateInfoWithAppCode:(NSString*)code ChannelVersion:(int)version{
    return
    [NSURL URLWithString:[NSString stringWithFormat:@"%@/commons/%@/channel/vupdate?version=%d",ZZZobt,code,version]];
}

+(NSURL*)getDocunmentWithChannelCode:(NSString*)code QueryDate:(NSString*)date isUP:(BOOL)isUP{
    if (isUP) {
        return
        [NSURL URLWithString:[NSString stringWithFormat:@"%@/users/%@/ecm/tupdate?queryDateTime=%@&queryType=UP",ZZZobt,code,date]];
    } else {
        return
        [NSURL URLWithString:[NSString stringWithFormat:@"%@/users/%@/ecm/tupdate?queryDateTime=%@&queryType=DOWN",ZZZobt,code,date]];
    }
}

/**
 //http://tam.hngytobacco.com/ecmapp/tecmeai/search?type=0&channelid=&pagesize=20&page=1&starttime=&endtime=&content=中烟
 
 属性名称      属性描述	类型	  	必填	    取值说明	                出错处理
 type         搜索类型	Int		是	    0：标题，1：全文	        置空
 pagesize	  分页大小	Int			    无默认为20	            20
 page	      起始页	    Int			    无默认为1	                1
 content	  搜索内容	String	是
 channelid	  栏目ID	    String			 默认为所有	            置空
 starttime	  开始时间	Long
 endtime	  结束时间	Long				                    置空
 */
//这里有中文 需注意
+(NSURL*)queryECMWithType:(BOOL)type
                 PageSize:(int)pagesize
                  pageNum:(int)pagenum
               ECMContent:(NSString*)content
                ChannelID:(NSString*)channelid
                     BGTM:(NSString*)bgtm
                     EDTM:(NSString*)edtm
{

    return
    [NSURL URLWithString:[[NSString stringWithFormat:@"http://tam.hngytobacco.com/ecmapp/tecmeai/search?type=%d&channelid=%@&pagesize=%d&page=%d&starttime=%@&endtime=%@&content=%@",type,channelid,pagesize,pagenum,bgtm,edtm,content] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}

+(NSURL*)queryTitleWith:(int)pagenum ECMContent:(NSString*)content ChannelID:(NSString*)channelid
{
    return [self queryECMWithType:0 PageSize:20 pageNum:pagenum ECMContent:content ChannelID:channelid BGTM:@"" EDTM:@""];
}

+(NSURL*)queryContentWith:(int)pagenum ECMContent:(NSString*)content ChannelID:(NSString*)channelid
{
    return [self queryECMWithType:1 PageSize:20 pageNum:pagenum ECMContent:content ChannelID:channelid BGTM:@"" EDTM:@""];
}
@end
