//
//  BDAlphaPlayerUtility.h
//  BDAlphaPlayer
//
//  Created by ByteDance on 2018/8/13.
//

#import "BDAlphaPlayerDefine.h"

#import <Foundation/Foundation.h>

extern NSString *const BDAlphaPlayerErrorDomain;

@class BDAlphaPlayerResourceModel;

@interface BDAlphaPlayerUtility : NSObject

+ (CGRect)frameFromVideoSize:(CGSize)size renderSuperViewFrame:(CGRect)renderSuperViewFrame  resourceModel:(BDAlphaPlayerResourceModel *)resourceModel;

@end
