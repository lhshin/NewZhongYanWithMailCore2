//
//  participants.m
//  ZhongYan
//
//  Created by linlin on 10/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "participants.h"
#import "participant.h"
@implementation participants
@synthesize returncode,participantsArray,xmlNodes,selection;
-(void)show
{
    NSLog(@"选择方式:%@",self.selection);
    for (participant *b in self.participantsArray) {
        [b show];
    }
}

-(id)init
{
    self = [super init];
    if (self) {
        self.participantsArray = [NSMutableArray array];
    }
    return self;
}



@end
