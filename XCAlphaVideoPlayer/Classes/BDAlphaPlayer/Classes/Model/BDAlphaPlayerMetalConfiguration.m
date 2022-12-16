//
//  BDAlphaPlayerMetalConfiguration.m
//  BDAlphaPlayer
//
//  Created by ByteDance on 2020/11/8.
//

#import "BDAlphaPlayerMetalConfiguration.h"

@implementation BDAlphaPlayerMetalConfiguration

+ (instancetype)defaultConfiguration
{
    BDAlphaPlayerMetalConfiguration *configuration = [[BDAlphaPlayerMetalConfiguration alloc] init];
    configuration.directory = @"";
    configuration.orientation = 0;
    configuration.renderSuperViewFrame = CGRectZero;
    
    return configuration;
}

@end
