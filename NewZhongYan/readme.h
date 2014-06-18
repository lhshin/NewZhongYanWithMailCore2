//
//  readme.h
//  NewZhongYan
//
//  Created by lilin on 13-9-29.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

/*
 但总的建议是:聚焦在首先为 iOS 7 而重新设计,然后为 app 考虑 iOS 6 版 本需要做的事情。
 
 iOS 7 的主题:
 • 顺从。界面的作用是帮助用户理解内容、和内容交互,而不是与内容竞争。
 • 明晰。每个字号的字体都清晰可辨,icon 精确易懂,装饰元素恰如其分,对于功能的精确聚焦是设计驱动力。
 • 深度。通过可视化的层、逼真的动画,加深用户的愉悦和理解。

 强制每个 app 做的事情
 √ 更新 app 的 icon,在 iOS 7 中,app 的图标尺寸是 120 x 120 像素(高分辨率下)。
 √ 更新 app 的载入图像,如果原有的载入图像中不包含顶栏部分的话,补充上状态栏部分的图像。
 √ 请支持 Retina 屏和 iPhone 5 的屏幕尺寸。

 建议每个 app 做的事情
 √ 检查 app 中写死的 UI 数值,比如 size 和 position,用系统提供的动态数值替换它们。使用 Auto Layout 帮助你的 app 完成相应布局变化下的响应。
 √ 使用动态的字体。
 √ 确保你的 app 不会与系统的新增手势产生冲突

 View Controller
 • 视图控制器接口 wantsFullScreenLayout 已作废。
 • UIViewController 提供了如下属性来调整视图控制器的外观:
 • edgesForExtendedLayout 这个属性属于 UIExtendedEdge 类型,它可以单独指定矩形的四条边,也可以 单独指定、指定全部、全部不指定。 使用 edgesForExtendedLayout 指定视图的哪条边需要扩展,不用 理会操作栏的透明度。这个属性的默认值是 UIRectEdgeAll。
 • extendedLayoutIncludesOpaqueBars 如果你使用了不透明的操作栏,设置 edgesForExtendedLayout 的 时候也请将 extendedLayoutIncludesOpaqueBars 的值设置为 No(默认值是 YES)。