//
//  SKClientApp.h
//  NewZhongYan
//
//  Created by lilin on 13-12-19.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  把clientapp 的根版本号存在plist文件中
 */

typedef void (^clientCompleteBlock)(void);
typedef void (^clientfaliureBlock)(NSError* error);

@interface SKClientApp : NSObject
@property(nonatomic,strong)NSString* CODE;      //应用编码
@property(nonatomic,strong)NSString* NAME;      //应用名称
@property(nonatomic,strong)NSString* DEPARTMENT;//主部门ID
@property(nonatomic,strong)NSString* DEFAULTED; //是不是默认频道
@property(nonatomic,strong)NSString* APPTYPE;   //应用类型 是cms 还是 ecm
@property(nonatomic,strong)NSMutableArray* channels;
@property int version;

-(id)initWithDictionary:(NSDictionary*)appinfo;

+(void)getClientAppWithCompleteBlock:(clientCompleteBlock)completeblock  faliureBlock:(clientfaliureBlock)faliureblock;
@end
