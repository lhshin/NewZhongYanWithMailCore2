//
//  SKLabel.m
//  SKLabelTest
//
//  Created by 李 林 on 12/30/12.
//  Copyright (c) 2012 surekam. All rights reserved.
//

#import "SKLabel.h"
#define linespace 7
@interface SKLabel (private)
{
    
}

@end


@implementation SKLabel
@synthesize keyWord = _keyWord;
@synthesize keyWordArray = _keyWordArray;
@synthesize keyWordColor = _keyWordColor;

#pragma mark -
#pragma mark 功能函数

#pragma mark -
#pragma mark 生命周期函数
-(id)init{
    self = [super init];
    if (self) {
        self.keyWordColor = [UIColor redColor];
        self.keyWord = @"";
        self.text = @"";
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.text = @"";
        self.keyWordColor = [UIColor redColor];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.text = @"";
        self.keyWordColor = [UIColor redColor];
    }
    return self;
}

- (void)SetTextColor:(UIColor *) strColor KeyWordColor: (UIColor *) keyColor
{
    if (keyColor) {
        self.keyWordColor = keyColor;
    }
    if (strColor) {
        self.textColor = strColor;
    }
}

- (void) SetLabelText:(NSString *)string KeyWord:(NSString *)keyword
{
    if (keyword){
       self.keyWord = keyword;
    }
    if (string){
        self.text = string;
    }
}

-(void)setText:(NSString *)text{
    [super setText:[text stringByAppendingString:@""]];
    
    attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    
    CGFloat height = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(self.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping].height;
    NSInteger linecount = height / self.font.lineHeight;
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width,(self.font.lineHeight + 4) * linecount)];
}

-(void)setFont:(UIFont *)font
{
    [super setFont:font];
    CGFloat height = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(self.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping].height;
    NSInteger linecount = height / font.lineHeight;
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width,(font.lineHeight + 4) * linecount)];
}

-(void)setKeyWord:(NSString *)keyWord
{
    if (keyWord && keyWord.length > 0) {
        if (!self.keyWordArray) {
            self.keyWordArray = [NSMutableArray arrayWithObject:keyWord];
        }else{
            [self.keyWordArray removeAllObjects];
            [self.keyWordArray addObject:keyWord];
        }
    }
}

-(void)addKeyWord:(NSString *)keyWord
{
    if (keyWord) {
        if (!self.keyWordArray) {
            self.keyWordArray = [NSMutableArray array];
        }
        if (![self.keyWordArray containsObject:keyWord]) {
            [self.keyWordArray addObject:keyWord];
        }
    }
}

- (NSAttributedString *)getAttributedString
{
    NSUInteger len = [self.text length];
    NSMutableAttributedString *mutaString = [[NSMutableAttributedString alloc] initWithString:self.text] ;
    [mutaString beginEditing];
    [mutaString addAttribute:(NSString *)(kCTForegroundColorAttributeName)
                       value:(id)self.textColor.CGColor
                       range:NSMakeRange(0, len)];
    
    
    for (NSString* keyword in self.keyWordArray) {
        [mutaString addAttribute:(NSString *)(kCTForegroundColorAttributeName)
                           value:(id)self.keyWordColor.CGColor
                           range:[self.text rangeOfString:keyword]];
    }
    
    int nNumType = 0;
    CFNumberRef cfNum = CFNumberCreate(NULL, kCFNumberIntType, &nNumType);
    [mutaString addAttribute:(NSString *)kCTLigatureAttributeName
                       value:(__bridge id)cfNum
                       range:NSMakeRange(0, len)];
    CFRelease(cfNum);
    
    //设置字体
    CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)self.font.fontName,self.font.pointSize,NULL);
    [mutaString addAttribute:(NSString *)(kCTFontAttributeName)
                       value:(__bridge id)font
                       range:NSMakeRange(0, len)];
    CFRelease(font);
    
    CTLineBreakMode lineBreadMode = kCTLineBreakByCharWrapping;   // 换行模式
    //创建文本对齐方式
    CTTextAlignment alignment;
    if(self.textAlignment == NSTextAlignmentCenter){
        alignment = kCTCenterTextAlignment;
    }else if(self.textAlignment == NSTextAlignmentRight){
        alignment = kCTRightTextAlignment;
    }else{
        alignment= kCTLeftTextAlignment;
    }
    
    // float linespacing = -2;// 行间距
    float maxspacing = 2;
    //kCTParagraphStyleSpecifierMaximumLineSpacing
    CTParagraphStyleSetting paraStyles[4] = {
        {.spec = kCTParagraphStyleSpecifierLineBreakMode,.valueSize = sizeof(CTLineBreakMode),.value = (const void*)&lineBreadMode},
        {.spec = kCTParagraphStyleSpecifierAlignment,.valueSize = sizeof(CTTextAlignment),.value = (const void*)&alignment},
        //{.spec = kCTParagraphStyleSpecifierLineSpacingAdjustment ,.valueSize = sizeof(CGFloat),.value = (const void*)&linespacing},
        {.spec = kCTParagraphStyleSpecifierMaximumLineSpacing ,.valueSize = sizeof(CGFloat),.value = (const void*)&maxspacing}
    };
    CTParagraphStyleRef style = CTParagraphStyleCreate(paraStyles, 3);
    [mutaString addAttribute:(NSString*)kCTParagraphStyleAttributeName value:(__bridge id)style range:NSMakeRange(0, self.text.length)];
    CFRelease(style);
    //////////
    [mutaString endEditing];
    return [mutaString copy] ;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    //该函数的作用 :前提是 quartz2D 的坐标系 和 iphone 界面的坐标系是不相同的
    CGContextTranslateCTM(context, 0, 0);
    CGContextScaleCTM(context, 1, -1);
    
    //作用与上面的一样
    //CGContextConcatCTM(context, CGAffineTransformScale(CGAffineTransformMakeTranslation(0, rect.size.height), 1.f, -1.f));
    
    CFAttributedStringRef attributedText = (__bridge CFAttributedStringRef)[self getAttributedString];
    CGContextTranslateCTM(context, 0.0, -self.bounds.size.height);
    CTFramesetterRef framessetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributedText);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, self.bounds);
    CTFrameRef frame = CTFramesetterCreateFrame(framessetter, CFRangeMake(0, 0), path, NULL);
    CGContextSetTextPosition(context, 0, 0);
    CTFrameDraw(frame, context);
    CFRelease(framessetter);
    CFRelease(frame);
    CGPathRelease(path);//add by lilin
    
    //    CATextLayer *textLayer = [CATextLayer layer];
    //    textLayer.string = [self getAttributedString];
    //    textLayer.frame =rect;
    //    [self.layer addSublayer:textLayer];
}
@end
