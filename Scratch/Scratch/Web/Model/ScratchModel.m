//
//  ScratchModel.m
//  ALSScratch3
//
//  Created by alsrobot on 2019/10/10.
//  Copyright © 2019 Chenshukun. All rights reserved.
//

#import "ScratchModel.h"

@implementation ScratchModel


+ (NSMutableArray *)getModelWithDict:(NSDictionary *)dict {
    
    NSDictionary *data = dict[@"data"];
    return [ScratchModel mj_objectArrayWithKeyValuesArray:data];
}

- (NSDictionary *)toDictionary {
    
    NSString *name = (self.scratchName.length <= 0) ? @"作品": self.scratchName;
    
    NSDictionary *dict =  @{@"scratchType":@0,
                           @"scratchCreate":@0,
                           @"isShowMoreBtn":@1,
                           @"showMoreView":@0,
                           @"isShowUpLoadBtn":@1,
                           @"scratchName":name,
                           @"scratchLogoImage":@"mainViewItemHomework",
                           @"scratchBgImage":@"mainViewItemBackground"
                        };
    
    return dict;
}

@end
