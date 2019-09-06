//
//  PreviewView.m
//  摄像机画面的捕捉和预览
//
//  Created by 柯木超 on 2019/9/3.
//  Copyright © 2019 柯木超. All rights reserved.
//

#import "PreviewView.h"

@implementation PreviewView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

+(Class)layerClass {
    return [AVCaptureVideoPreviewLayer class];
}
- (AVCaptureSession*)session {
    //重写session方法，返回捕捉会话
    return [(AVCaptureVideoPreviewLayer*)self.layer session];
}
-(void)setSession:(AVCaptureSession *)session {
    //重写session属性的访问方法，在setSession:方法中访问视图layer属性。
    //AVCaptureVideoPreviewLayer 实例，并且设置AVCaptureSession 将捕捉数据直接输出到图层中，并确保与会话状态同步。
    
    
    [(AVCaptureVideoPreviewLayer*)self.layer setSession:session];
}

//关于UI的实现，例如手势，单击、双击 单击聚焦、双击曝光
- (void)setupView {
    
    [(AVCaptureVideoPreviewLayer *)self.layer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
}

// 将屏幕上点击的位置转化成摄像头的位置
-(CGPoint)captureDevicePointForPoint:(CGPoint)point{
    AVCaptureVideoPreviewLayer *layer = (AVCaptureVideoPreviewLayer *)self.layer;
    //将屏幕上点击的位置转化成摄像头的位置
    return [layer captureDevicePointOfInterestForPoint:point];
    
    //将摄像头的位置转化成屏幕上点击的位置
    // [layer pointForCaptureDevicePointOfInterest:point];
}

@end
