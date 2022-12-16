//
//  XCViewController.m
//  XCAlphaVideoPlayer
//
//  Created by guoshuai.cheng@holla.world on 12/15/2022.
//  Copyright (c) 2022 guoshuai.cheng@holla.world. All rights reserved.
//

#import "XCViewController.h"
#import <XCAlphaVideoPlayer/BDAlphaPlayer.h>

@interface XCViewController ()<BDAlphaPlayerMetalViewDelegate>

@property (nonatomic, strong) BDAlphaPlayerMetalView *metalView;

@end

@implementation XCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self startBtnClicked];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startBtnClicked
{
    if (!self.metalView) {
        self.metalView = [[BDAlphaPlayerMetalView alloc] initWithDelegate:self];
        [self.view insertSubview:self.metalView atIndex:0];
    }
    //Missile
    //Love car
    NSString *testResourcePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Missile.mp4"];
    BDAlphaPlayerMetalConfiguration *configuration = [BDAlphaPlayerMetalConfiguration defaultConfiguration];
    configuration.directory = testResourcePath;
    configuration.renderSuperViewFrame = self.view.frame;
    configuration.orientation1 = BDAlphaPlayerOrientationPortrait;
    
    [self.metalView playWithMetalConfiguration:configuration];
}


- (void)metalView:(BDAlphaPlayerMetalView *)metalView didFinishPlayingWithError:(NSError *)error
{
    if (error) {
        NSLog(@"%@", error.localizedDescription);
    }
}
@end
