//
//  column.h
//  ZhongYan
//
//  Created by linlin on 9/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDXMLNode.h"
@interface column : NSObject
{
    //属性包括 type name  id rw
    NSString        * value;//有可能为空
    NSDictionary    * columnDict;
    NSMutableArray  * elementArray;//可能为空
    DDXMLNode  * cnode;//可能为空
}

//-(void)showCloumn;
@property(nonatomic,strong)NSString          * value;//有可能为空
@property(nonatomic,strong)NSDictionary      * columnDict;
@property(nonatomic,strong)NSMutableArray    * elementArray;
@property(nonatomic,strong)DDXMLNode  * cnode;//可能为空
@end


/*
 column的属性解释
 1 type     目前暂时分为3种类型，文本、图片和二进制文件。
    1> text/plain   应用系统可以使用一个column对应一项数据；也可以一次将多个数据组合成纯文本放在一个column中。
    2> mixed        指在此column下还有多个子元素element
 
 2 name     当type=text时，name用来存放该项数据的字段名 当type指示二进制文件时，name用来存放文件的名称。
 
 3 visible  该属性是否可见，取值true可见，false不可见。可选，默认可见。
 
 4 encode   对该column的值使用encode指定的方式进行编码，该属性可选，默认不使用编码。
 
 5 rw       指定数据的操作权限。ra1 ra0 rs0 'ra0'
 
 6 extend   表示此column上需要挂接其他显示或者输入用插件。
 
    插件是一种可以对当前column的值进行处理、执行特定功能并返回处理结果到column上的一种专用对象。
    目前支持插件类型为：phrase，常用语输入插件；phonecall，拨打电话插件；emailto，发送邮件插件 ；
    signature，签名插件；dateinput，输入日期型插件。插件库可能会随着今后业务功能变化而增加。
*/