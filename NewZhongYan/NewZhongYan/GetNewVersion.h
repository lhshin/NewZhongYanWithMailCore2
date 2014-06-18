//
//  GetNewVersion.h
//  ZhongYan
//
//  Created by 袁树峰 on 13-3-8.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GetNewVersionProtocol <NSObject>
-(void)onGetNewVersionDoneWithDic:(NSDictionary *)dic;
@end

@interface GetNewVersion : NSObject
@property(nonatomic,retain) id<GetNewVersionProtocol> delegate;
-(void)getNewsVersion;
+(void)getNewsVersionComplteBlock:(completeBlock)block FaliureBlock:(errorBlock)errorinfo;
@end


