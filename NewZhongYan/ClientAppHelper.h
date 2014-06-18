//
//  ClientAppHelper.h
//  NewZhongYan
//
//  Created by lilin on 14-3-3.
//  Copyright (c) 2014年 surekam. All rights reserved.
//

#import "MainHelper.h"
#import "SKClientApp.h"
@interface ClientAppHelper : MainHelper
-(id)initWithClientApp:(SKClientApp*)clientapp;

-(NSString*)clientAppSizeDocumentPath;

-(void)getChanelIdInClientAPP;

-(void)getDocumentsFromClientApp;

-(BOOL)needClean;

-(void)cleanLocalData;
@end
