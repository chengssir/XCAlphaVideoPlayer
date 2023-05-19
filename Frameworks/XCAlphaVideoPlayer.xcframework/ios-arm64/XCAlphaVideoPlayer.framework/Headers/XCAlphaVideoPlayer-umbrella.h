#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "BDAlphaPlayer.h"
#import "BDAlphaPlayerMetalView.h"
#import "BDAlphaPlayerDefine.h"
#import "BDAlphaPlayerMetalConfiguration.h"
#import "BDAlphaPlayerResourceInfo.h"
#import "BDAlphaPlayerResourceModel.h"
#import "BDAlphaPlayerAssetReaderOutput.h"
#import "BDAlphaPlayerMetalRenderer.h"
#import "BDAlphaPlayerMetalShaderType.h"
#import "BDAlphaPlayerUtility.h"

FOUNDATION_EXPORT double XCAlphaVideoPlayerVersionNumber;
FOUNDATION_EXPORT const unsigned char XCAlphaVideoPlayerVersionString[];

