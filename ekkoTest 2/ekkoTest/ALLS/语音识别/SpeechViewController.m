//
//  SpeechViewController.m
//  ekkoTest
//
//  Created by ekko on 2018/5/8.
//  Copyright © 2018年 ekkoProduct. All rights reserved.
//

#define LoadingText @"正在录音...."


#import "SpeechViewController.h"
#import <Speech/Speech.h>
API_AVAILABLE(ios(10.0))
@interface SpeechViewController ()<SFSpeechRecognizerDelegate>
//创建语音识别操作类对象
@property (nonatomic, strong) SFSpeechRecognizer *speechRecognizer;
//是音频引擎，用于音频输入
@property (nonatomic, strong) AVAudioEngine *audioEngine;
//
@property (nonatomic,strong) SFSpeechRecognitionTask *recognitionTask;
//
@property (nonatomic,strong) SFSpeechAudioBufferRecognitionRequest *recognitionRequest;
//录音按钮
@property (nonatomic, strong) UIButton *recordBtn;
//结果
@property (nonatomic, strong) UITextView *resultLab;
@end

@implementation SpeechViewController
- (UITextView *)resultLab {
    if (!_resultLab) {
        self.resultLab = [[UITextView alloc] initWithFrame:CGRectMake(100, 250, 200, 80)];
        self.resultLab.layer.borderWidth = 1;
        self.resultLab.layer.borderColor = [UIColor redColor].CGColor;
    }
    return _resultLab;
}
- (SFSpeechRecognizer *)speechRecognizer  API_AVAILABLE(ios(10.0)){
    if (!_speechRecognizer) {
        NSLocale *local = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        self.speechRecognizer = [[SFSpeechRecognizer alloc] initWithLocale:local];
        self.speechRecognizer.delegate = self;
    }
    return _speechRecognizer;
}

- (AVAudioEngine *)audioEngine {
    if (!_audioEngine) {
        self.audioEngine = [[AVAudioEngine alloc] init];
    }
    return _audioEngine;
}
- (UIButton *)recordBtn {
    if (!_recordBtn) {
        self.recordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.recordBtn.frame = CGRectMake(100, 120, 100, 35);
        //btn setImage:[UIImage imageNamed:@""] forState:<#(UIControlState)#>
        [self.recordBtn setTitle:@"开始录音" forState:UIControlStateNormal];
        [self.recordBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self.recordBtn addTarget:self action:@selector(recordingHandle:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _recordBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    __weak typeof(self) weakSelf = self;
    if (@available(iOS 10.0, *)) {
        [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
            switch (status) {
                case SFSpeechRecognizerAuthorizationStatusNotDetermined:
                    [weakSelf creatAlertWithTitle:@"语音识别未授权"];
                    break;
                case SFSpeechRecognizerAuthorizationStatusDenied:
                    [weakSelf creatAlertWithTitle:@"语音未授权"];
                    break;
                case SFSpeechRecognizerAuthorizationStatusRestricted:
                    [weakSelf creatAlertWithTitle:@"设备不支持语音识别功能"];
                    break;
                case SFSpeechRecognizerAuthorizationStatusAuthorized:
                    self.recordBtn.enabled = YES;
                    [weakSelf creatAlertWithTitle:@"可以语音识别"];
                    break;
                default:
                    break;
            }
        }];
    } else {
        // Fallback on earlier versions
        NSLog(@"ss");
    }
    
    self.recordBtn.enabled = NO;
    [self.view addSubview:self.recordBtn];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(100, 170, 100, 35);
    //btn setImage:[UIImage imageNamed:@""] forState:<#(UIControlState)#>
    [btn1 setTitle:@"识别本地音频文件" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(localRecordingHandle:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    [self.view addSubview:self.resultLab];
    
    
}
//
- (void)creatAlertWithTitle:(NSString *)title {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:title preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"OK");
    }];
    [alertVC addAction:okAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}


- (void)endRecording {
    [self.audioEngine stop];
    if (_recognitionRequest) {
        [self.recognitionRequest endAudio];
    }
    if (_recognitionTask) {
        [self.recognitionTask cancel];
        self.recognitionTask = nil;
    }
    self.recordBtn.enabled = NO;
    self.resultLab.text = @"";
}


- (void)recordingHandle:(UIButton *)sender {
    if (self.audioEngine.isRunning) {
        [self endRecording];
        [self.recordBtn setTitle:@"正在停止" forState:UIControlStateNormal];
    } else {
        [self startRecording];
        [self.recordBtn setTitle:@"停止录音" forState:UIControlStateNormal];
    }
}
- (void)startRecording {
    if (_recognitionTask) {
        [self.recognitionTask cancel];
        self.recognitionTask = nil;
    }
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *error;
    [audioSession setCategory:AVAudioSessionCategoryRecord error:&error];
    NSParameterAssert(!error);
    [audioSession setMode:AVAudioSessionModeMeasurement error:&error];
    NSParameterAssert(!error);
    [audioSession setActive:YES withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&error];
    NSParameterAssert(!error);
    
    if (@available(iOS 10.0, *)) {
        self.recognitionRequest = [[SFSpeechAudioBufferRecognitionRequest alloc] init];
        AVAudioInputNode *inputNode = self.audioEngine.inputNode;
        NSAssert(inputNode, @"录入设备没有转备好");
        NSAssert(self.recognitionRequest, @"请求初始化失败");
        self.recognitionRequest.shouldReportPartialResults = YES;
        __weak typeof(self) weakSelf = self;
        self.recognitionTask = [self.speechRecognizer recognitionTaskWithRequest:self.recognitionRequest resultHandler:^(SFSpeechRecognitionResult * _Nullable result, NSError * _Nullable error) {
            BOOL isFinal = NO;
            if (result) {
                weakSelf.resultLab.text = result.bestTranscription.formattedString;
                isFinal = result.isFinal;
            }
            if (error || isFinal) {
                [self.audioEngine stop];
                [inputNode removeTapOnBus:0];
                weakSelf.recognitionTask = nil;
                weakSelf.recognitionRequest = nil;
                weakSelf.recordBtn.enabled = YES;
                [weakSelf.recordBtn setTitle:@"开始新的录音" forState:UIControlStateNormal];
            }
        }];
        
        AVAudioFormat *recordingFormat = [inputNode outputFormatForBus:0];
        //在添加tap之前先移除上一个,不然会报错 com.apple.coreaudio.avfaudio
        [inputNode removeTapOnBus:0];
        [inputNode installTapOnBus:0 bufferSize:1024 format:recordingFormat block:^(AVAudioPCMBuffer * _Nonnull buffer, AVAudioTime * _Nonnull when) {
            if (weakSelf.recognitionRequest) {
                [weakSelf.recognitionRequest appendAudioPCMBuffer:buffer];
            }
        }];
        [self.audioEngine prepare];
        [self.audioEngine startAndReturnError:&error];
        self.resultLab.text = LoadingText;
    } else {
        // Fallback on earlier versions
    }
    
    
    
    
    
    
    
}

//识别本地
- (void)localRecordingHandle:(UIButton *)sender {
    //此处设置支持的语言
    NSLocale *local = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    if (@available(iOS 10.0, *)) {
        SFSpeechRecognizer *localRecognizer = [[SFSpeechRecognizer alloc] initWithLocale:local];
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"1-01 越清醒越孤独.m4a" withExtension:nil];
        if (!url) {
            return;
        }
        SFSpeechURLRecognitionRequest *res = [[SFSpeechURLRecognitionRequest alloc] initWithURL:url];
        __weak typeof(self) weakSelf = self;
        [localRecognizer recognitionTaskWithRequest:res resultHandler:^(SFSpeechRecognitionResult * _Nullable result, NSError * _Nullable error) {
            if (error) {
                NSLog(@"语音识别解析失败:%@", error);
            } else {
                weakSelf.resultLab.text = result.bestTranscription.formattedString;
            }
        }];
    } else {
        // Fallback on earlier versions
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
