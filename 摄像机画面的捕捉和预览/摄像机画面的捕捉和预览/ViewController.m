//
//  ViewController.m
//  摄像机画面的捕捉和预览
//
//  Created by 柯木超 on 2019/9/3.
//  Copyright © 2019 柯木超. All rights reserved.
//

#import "ViewController.h"
#import "PreviewView.h"
#import <AVFoundation/AVFoundation.h>
#import "NSFileManager+THAdditions.h"
#import <AssetsLibrary/AssetsLibrary.h>
@interface ViewController ()<AVCaptureFileOutputRecordingDelegate>
@property (strong, nonatomic) PreviewView *previewView;
@property (strong, nonatomic) dispatch_queue_t videoQueue; //视频队列
@property (strong, nonatomic) AVCaptureMovieFileOutput *movieOutput;
@property (strong, nonatomic) AVCaptureSession *captureSession;// 捕捉会话
@property (strong, nonatomic) NSURL *outputURL;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 创建secssion
    self.captureSession = [[AVCaptureSession alloc]init];
    
    /*
     AVCaptureSessionPresetHigh
     AVCaptureSessionPresetMedium
     AVCaptureSessionPresetLow
     AVCaptureSessionPreset640x480
     AVCaptureSessionPreset1280x720
     AVCaptureSessionPresetPhoto
     */
    //设置图像的分辨率
    self.captureSession.sessionPreset = AVCaptureSessionPresetHigh;
    
    // 1、添加device 拿到默认视频捕捉设备 iOS系统返回后置摄像头
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // 2、给device封装 AVCaptureDeviceInput
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    
    // 3、捕捉设备输出
    //判断videoInput是否有效
    if (deviceInput){
        if([self.captureSession canAddInput:deviceInput]) {
            [self.captureSession addInput:deviceInput];
        }
    }
    // 4、捕捉预览
    self.previewView = [[PreviewView alloc]initWithFrame:self.view.bounds];
    [self.previewView setSession:self.captureSession];
    [self.view addSubview:self.previewView];
    
    // 5、输出
    self.movieOutput = [[AVCaptureMovieFileOutput alloc]init];
    
    if([self.captureSession canAddOutput:self.movieOutput]) {
        [self.captureSession addOutput:self.movieOutput];
    }
    
    self.videoQueue = dispatch_queue_create("cc.VideoQueue", NULL);
    //使用同步调用会损耗一定的时间，则用异步的方式处理
    dispatch_async(self.videoQueue, ^{
        [self.captureSession startRunning];
    });
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(100, 40, 80, 40)];
    [button setTitle:@"开始录制" forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(stopAction:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)stopAction:(UIButton *)button {
    if([button.titleLabel.text isEqualToString:@"开始录制"]) {
        self.outputURL = [self uniqueURL];
        NSLog(@"outputURL=%@",self.outputURL);
        //在捕捉输出上调用方法 参数1:录制保存路径  参数2:代理
        [self.movieOutput startRecordingToOutputFileURL: self.outputURL  recordingDelegate:self];
        [button setTitle:@"停止录制" forState:UIControlStateNormal];
    }else {
        [self.movieOutput stopRecording];
        [button setTitle:@"开始录制" forState:UIControlStateNormal];
    }
}

//写入视频唯一文件系统URL
- (NSURL *)uniqueURL {

    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //temporaryDirectoryWithTemplateString  可以将文件写入的目的创建一个唯一命名的目录；
    NSString *dirPath = [fileManager temporaryDirectoryWithTemplateString:@"kamera.XXXXXX"];
    
    if (dirPath) {
        
        NSString *filePath = [dirPath stringByAppendingPathComponent:@"kamera_movie.mov"];
        return  [NSURL fileURLWithPath:filePath];
        
    }
    
    return nil;
    
}


#pragma AVCaptureFileOutputRecordingDelegate
- (void)captureOutput:(AVCaptureFileOutput *)captureOutput
didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL
      fromConnections:(NSArray *)connections
                error:(NSError *)error {
    UISaveVideoAtPathToSavedPhotosAlbum([outputFileURL path], nil, nil, nil);
}


@end
