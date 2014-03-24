
// System Libraries
// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
#import <CoreGraphics/CoreGraphics.h>
#import <CoreVideo/CoreVideo.h>
#import <CoreMedia/CoreMedia.h>

// Local Libraries
// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
#import "CameraApi.h"


// Class Implementation
// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
@implementation CameraApi

@synthesize delegate;


-(id) init {

    // input
	avCaptureDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo] 
                                                                 error:nil];

    // output
	NSString* key = (NSString*)kCVPixelBufferPixelFormatTypeKey; 
	NSNumber* value = [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA]; 
	NSDictionary* videoSettings = [NSDictionary dictionaryWithObject:value forKey:key]; 

	avCaptureVideoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
	avCaptureVideoDataOutput.alwaysDiscardsLateVideoFrames = YES; 
	avCaptureVideoDataOutput.minFrameDuration = CMTimeMake( 1, 30 );  // CMTimeMake( 1, 10 ) == 10 fps
	avCaptureVideoDataOutput.videoSettings = videoSettings; 

	dispatch_queue_t queue; 	// create a serial queue to handle the processing of our frames
    {
        queue = dispatch_queue_create( "cameraQueue", NULL );
        [avCaptureVideoDataOutput setSampleBufferDelegate:self queue:queue];
    }
	dispatch_release(queue);

    // create a capture session
	avCaptureSession = [[AVCaptureSession alloc] init];
    avCaptureSession.sessionPreset = AVCaptureSessionPresetMedium;
	[avCaptureSession addInput:avCaptureDeviceInput];
    [avCaptureSession addOutput:avCaptureVideoDataOutput];
    
	// Add the preview layer
//	CGRect rect = [[UIScreen mainScreen] bounds];

//    avCaptureVideoPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession: avCaptureSession];
//    avCaptureVideoPreviewLayer.orientation = AVCaptureVideoOrientationLandscapeRight;
//	avCaptureVideoPreviewLayer.frame = CGRectMake( 0, 0, rect.size.height, rect.size.width );
//	avCaptureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
//	[viewController.view.layer addSublayer: avCaptureVideoPreviewLayer];
    
 
    

    // add observers isAdjustingFocus
//    [avCaptureDeviceInput addObserver:viewController 
//                           forKeyPath:@"isAdjustingFocus" 
//                              options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) 
//                              context:NULL];

//    NSNotificationCenter* notify = [NSNotificationCenter defaultCenter];
//    [notify addObserver: self
//               selector: @selector(is:)
//                   name: AVCaptureSessionRuntimeErrorNotification
//                 object: session];

    return [super init];
}

//-(void) setPreviewOrientation:(AVCaptureVideoOrientation)orientation{
//    
//    avCaptureVideoPreviewLayer.orientation = orientation;
////    avCaptureVideoPreviewLayer.frame = _viewController.view.bounds;
//}

-(void) dealloc {
    
//    [avCaptureDeviceInput removeObserver:delegate forKeyPath:@"adjustingFocus"];

    [avCaptureSession release];
    [avCaptureDeviceInput release];
    [avCaptureVideoDataOutput release];

//    [avCaptureVideoPreviewLayer release];
    
    [super dealloc];
}


-(void) startCaptureFrames{

    [avCaptureSession startRunning];
}

-(void) stopCaptureFrames {

    [avCaptureSession stopRunning];
}

-(void) turnFlashOn {
    
    AVCaptureDevice* device = [avCaptureDeviceInput device];

    if
    (
        [device hasTorch]
        &&
        [device isTorchModeSupported:AVCaptureTorchModeOn]
        &&
        [device torchMode] != AVCaptureTorchModeOn
    ){

        NSError* error;
        if( [device lockForConfiguration:&error]) {

            [device setTorchMode:AVCaptureTorchModeOn];
            [device unlockForConfiguration];
        }
    }
}

-(void) turnFlashOff {
    
    AVCaptureDevice* device = [avCaptureDeviceInput device];
    
    if
    (
         [device hasTorch]
         &&
         [device isTorchModeSupported:AVCaptureTorchModeOff]
         &&
         [device torchMode] != AVCaptureTorchModeOff
    ){
            
        NSError* error;
        if( [device lockForConfiguration:&error]) {
                
                [device setTorchMode:AVCaptureTorchModeOff];
                [device unlockForConfiguration];
        }
    }
}


#pragma mark ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
#pragma mark AVCapture Helpers
#pragma mark ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----

- (void) captureOutput:(AVCaptureOutput *)captureOutput 
 didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer 
        fromConnection:(AVCaptureConnection *)connection {

    if( delegate == nil )
        return;
    
	// Create an autorelease pool because as we are not in the main_queue our code is not executed in the main thread.
    // So we have to create an autorelease pool for the thread we are in
	
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer( sampleBuffer );
    
    // Lock the image buffer
    CVPixelBufferLockBaseAddress( imageBuffer,0 );
    
    // Get information about the image
    uint8_t *baseAddress = (uint8_t *)CVPixelBufferGetBaseAddress(imageBuffer); 
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer); 
    size_t width = CVPixelBufferGetWidth(imageBuffer); 
    size_t height = CVPixelBufferGetHeight(imageBuffer);  
    
    // Create a CGImageRef from the CVImageBufferRef
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB(); 
    CGContextRef newContext = CGBitmapContextCreate( baseAddress, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst );
    CGImageRef newImage = CGBitmapContextCreateImage( newContext );
    
    // Release some components
    CGContextRelease(newContext);
    CGColorSpaceRelease(colorSpace);
    
	// We display the result on the image view (We need to change the orientation of the image so that the video is displayed correctly).
	// Same thing as for the CALayer we are not in the main thread so ...
    [self performSelectorOnMainThread:@selector(invokeImageAvailable:) withObject:(id)newImage waitUntilDone:YES];    

	// Relase the CGImageRef
	CGImageRelease(newImage);
	
	// Unlock the  image buffer
	CVPixelBufferUnlockBaseAddress( imageBuffer, 0 );
    
	[pool drain];
}

- (void) invokeImageAvailable:(CGImageRef)image {

    if( delegate != nil ) {
        [delegate imageAvailable:image];
    }
}



@end
