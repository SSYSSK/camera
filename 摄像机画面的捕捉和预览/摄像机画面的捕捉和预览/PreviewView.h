//
//  PreviewView.h
//  摄像机画面的捕捉和预览
//
//  Created by 柯木超 on 2019/9/3.
//  Copyright © 2019 柯木超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
NS_ASSUME_NONNULL_BEGIN

@interface PreviewView : UIView
@property (strong, nonatomic) AVCaptureSession *session;
@end

NS_ASSUME_NONNULL_END
