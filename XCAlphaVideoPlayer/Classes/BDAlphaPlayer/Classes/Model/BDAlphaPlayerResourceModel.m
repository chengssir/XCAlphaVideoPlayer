//
//  BDAlphaPlayerResourceModel.m
//  BDAlphaPlayer
//
//  Created by ByteDance on 2018/8/13.
//

#import "BDAlphaPlayerResourceModel.h"
#import "BDAlphaPlayerMetalConfiguration.h"
#import "BDAlphaPlayerUtility.h"

@interface BDAlphaPlayerResourceModel ()

@end

@implementation BDAlphaPlayerResourceModel

+ (instancetype)resourceModelFromDirectory:(BDAlphaPlayerMetalConfiguration *)configuration  error:(NSError **)error {
    if (![[NSFileManager defaultManager] fileExistsAtPath:configuration.directory]) {
        return nil;
    }
    
    NSString *fileName = [configuration.directory lastPathComponent];
    NSString *currentDirectoryPath = [configuration.directory stringByDeletingLastPathComponent];
    BDAlphaPlayerResourceModel *resourceModel = [[BDAlphaPlayerResourceModel alloc] init];
    BDAlphaPlayerResourceInfo *info = [[BDAlphaPlayerResourceInfo alloc] init];
    info.contentMode = configuration.orientation;
    info.resourceName = fileName;
    resourceModel.currentOrientationResourceInfo = info;
    resourceModel.directory = currentDirectoryPath;
    [resourceModel pr_replenish];
    
    BOOL isAvailable = [resourceModel.currentOrientationResourceInfo resourceAvailable];
    if (!isAvailable) {
        *error = [NSError errorWithDomain:BDAlphaPlayerErrorDomain code:BDAlphaPlayerErrorConfigAvailable userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"config.json data not available %@", configuration.directory]}];
        resourceModel = nil;
    }
    return resourceModel;
}

- (void)pr_replenish
{
    if (self.currentOrientationResourceInfo.resourceName.length) {
        self.currentOrientationResourceInfo.resourceFilePath = [self.directory stringByAppendingPathComponent:self.currentOrientationResourceInfo.resourceName];
        self.currentOrientationResourceInfo.resourceFileURL = self.currentOrientationResourceInfo.resourceFilePath ? [NSURL fileURLWithPath:self.currentOrientationResourceInfo.resourceFilePath] : nil;
    }
}

@end
