

// System Libraries
// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
#import <AVFoundation/AVFoundation.h>


// Forwards
// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
@class AVCaptureSession;
@class AVCaptureDeviceInput;
@class AVCaptureVideoDataOutput;
@class AVCaptureVideoPreviewLayer;


// Delegates
// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
@protocol CameraApiDelegate

-(void) imageAvailable:(CGImageRef)image;

@end


// Class
// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
@interface CameraApi : NSObject < AVCaptureVideoDataOutputSampleBufferDelegate > {

    AVCaptureSession* avCaptureSession;
    AVCaptureDeviceInput* avCaptureDeviceInput;
    AVCaptureVideoDataOutput *avCaptureVideoDataOutput;
    AVCaptureVideoPreviewLayer* avCaptureVideoPreviewLayer;
    
    id<CameraApiDelegate> delegate;
}

@property (nonatomic, assign) id<CameraApiDelegate> delegate;

-(id) init;
-(void) startCaptureFrames;
-(void) stopCaptureFrames;
-(void) turnFlashOn;
-(void) turnFlashOff;

//-(void) setPreviewOrientation:(AVCaptureVideoOrientation)orientation;

@end
