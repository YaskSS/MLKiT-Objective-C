//
//  ViewController.m
//  MLKiT
//
//  Created by ass_boss on 30.05.2018.
//  Copyright © 2018 ass_boss. All rights reserved.
//

#import "ViewController.h"
#import <Firebase.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController () <UIImagePickerControllerDelegate>

@property(strong, nonatomic) FIRVision* vision;
@property(strong, nonatomic) FIRVisionTextDetector* textDetector;
@property(strong, nonatomic) AVSpeechSynthesizer* synthesizer;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.vision = [FIRVision vision];
    self.textDetector = [self.vision textDetector];
    self.synthesizer = [[AVSpeechSynthesizer alloc] init];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)openCamera:(UIButton *)sender{
    UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.allowsEditing = YES;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo NS_DEPRECATED_IOS(2_0, 3_0){
    
    [picker dismissViewControllerAnimated:YES completion:^{
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.image = image;
    }];
}

- (IBAction)readImage:(UIButton *)sender {
    UIImage* img = self.imageView.image;
    if (img) {
        FIRVisionImage* visionImage = [[FIRVisionImage alloc] initWithImage:img];
        
        [self.textDetector detectInImage:visionImage completion:^(NSArray<id<FIRVisionText>> * _Nullable texts, NSError * _Nullable error) {
            if (error) {
                NSLog(error.localizedDescription);
            }
            
            if  (texts && texts.count > 0){
                for(id <FIRVisionText> t in texts){
                    
                    AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc] initWithString:t.text];
                    utterance.rate = 0.4;
                    utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"en-US"];
                    
                    [self.synthesizer speakUtterance:utterance];
                }
            }
        }];
        
    } else {
        return;
    }
}

@end
