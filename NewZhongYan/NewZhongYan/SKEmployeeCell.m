//
//  SKEmployeeCell.m
//  NewZhongYan
//
//  Created by lilin on 13-10-31.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import "SKEmployeeCell.h"

@implementation SKEmployeeCell
{
    BOOL stored;
    __weak NSMutableDictionary* employeeinfo;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)store:(UIButton*)storeBtn
{
    if (stored) {
        [storeBtn setBackgroundImage:[UIImage imageNamed:@"star_off"] forState:UIControlStateNormal];
        NSString* updatesql =
        [NSString stringWithFormat:@"UPDATE T_EMPLOYEE SET STORED = 0 where id  = %@;",employeeinfo[@"id"]];
        [[DBQueue sharedbQueue] updateDataTotableWithSQL:updatesql];
        [employeeinfo setObject:@"0" forKey:@"STORED"];
    }else{
        [storeBtn setBackgroundImage:[UIImage imageNamed:@"star_on"] forState:UIControlStateNormal];
        NSString* updatesql =
        [NSString stringWithFormat:@"UPDATE T_EMPLOYEE SET STORED = 1 where id  = %@;",employeeinfo[@"id"]];
        [[DBQueue sharedbQueue] updateDataTotableWithSQL:updatesql];
        [employeeinfo setObject:@"1" forKey:@"STORED"];
    }
    stored = !stored;

}

-(void)phone:(UIButton*)phoneBtn
{
    NSString* phoneNo = [employeeinfo objectForKey:@"MOBILE"];
    if (phoneNo && phoneNo.length > 2) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt:%@", phoneNo]]];
    }
}

-(void)setEmployee:(NSMutableDictionary*)dict
{
    employeeinfo = dict;
    self.name.text = dict[@"CNAME"];//[[_dataEItems objectAtIndex:indexPath.row] objectForKey:@"CNAME"];
    
    self.phone.text = dict[@"MOBILE"];//[[_dataEItems objectAtIndex:indexPath.row] objectForKey:@"MOBILE"];
    if (dict[@"SHORTPHONE"] && [dict[@"SHORTPHONE"] length] > 0) {
        self.phone.text = [self.phone.text stringByAppendingFormat:@"(%@)",dict[@"SHORTPHONE"]];
    }
    
    self.position.text = dict[@"TNAME"];//[[_dataEItems objectAtIndex:indexPath.row] objectForKey:@"TNAME"];
    if (dict[@"UCNAME"] == [NSNull null])
    {
        self.department.text = @"";
    }else{
        self.department.text = dict[@"PNAME"];
    }
    
    stored = [dict[@"STORED"] intValue];
    if ( stored == 1) {
        [self.storeBtn  setBackgroundImage:[UIImage imageNamed:@"star_on"] forState:UIControlStateNormal];
    }else{
        [self.storeBtn  setBackgroundImage:[UIImage imageNamed:@"star_off"] forState:UIControlStateNormal];
    }
    
    [self.phoneBtn addTarget:self action:@selector(phone:) forControlEvents:UIControlEventTouchUpInside];
    [self.storeBtn addTarget:self action:@selector(store:) forControlEvents:UIControlEventTouchUpInside];
}
@end
