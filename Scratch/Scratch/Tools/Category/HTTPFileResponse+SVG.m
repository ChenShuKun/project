//
//  HTTPFileResponse+SVG.m
//  ALSScratch3
//
//  Created by alsrobot on 2019/11/29.
//  Copyright © 2019 Chenshukun. All rights reserved.
//

#import "HTTPFileResponse+SVG.h"

@implementation HTTPFileResponse (SVG)

- (NSDictionary *)httpHeaders {
    //HTTPLogTrace();
    if ([[filePath pathExtension] isEqualToString:@"svg"]) {
        return [NSDictionary dictionaryWithObject:@"image/svg+xml" forKey:@"Content-Type"];
    }
    return [NSDictionary new];
}

@end
