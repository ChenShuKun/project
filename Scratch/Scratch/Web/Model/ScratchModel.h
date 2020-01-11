//
//  ScratchModel.h
//  ALSScratch3
//
//  Created by alsrobot on 2019/10/10.
//  Copyright © 2019 Chenshukun. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ScratchModel : BaseModel


@property (nonatomic,assign) NSInteger scratchType;
//scratchType=0 本地模块，scratchType== 1 云端，scratchType== 2 作业  scratchType = 3 设置界面
@property (nonatomic,assign) NSInteger scratchCreate;
// scratchCreate = 1 是 创作作品  scratchCreate == 0 正常模块
@property (nonatomic,assign) NSInteger isShowMoreBtn;
// 1 ->显示更多，0 ->  不显示
@property (nonatomic,assign) NSInteger isShowUpLoadBtn;
// 1 ->显示上传按钮，0 ->  不显示
@property (nonatomic,assign) NSInteger showMoreView;
// 1 ->显示 重命名，删除，取消 按钮 ，0 ->  不显示

@property (nonatomic,copy) NSString *scratchName;
@property (nonatomic,copy) NSString *scratchLogoImage;
@property (nonatomic,copy) NSString *scratchBgImage;


+ (NSMutableArray *)getModelWithDict:(NSDictionary *)dict;
- (NSDictionary *)toDictionary;
@end

NS_ASSUME_NONNULL_END
