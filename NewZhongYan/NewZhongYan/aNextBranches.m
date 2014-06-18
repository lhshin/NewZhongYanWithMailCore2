//
//  aNextBranches.m
//  ZhongYan
//
//  Created by linlin on 10/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "aNextBranches.h"
#import "branch.h"
@implementation aNextBranches
@synthesize returncode,branchesArray,xmlNodes,selection;

-(void)show
{
    for (branch *b in branchesArray) {
        [b show];
    }
}

-(id)init
{
    self = [super init];
    if (self) {
        self.branchesArray = [NSMutableArray array];
    }
    return self;
}


@end
