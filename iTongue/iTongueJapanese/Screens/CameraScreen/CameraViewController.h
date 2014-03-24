

// System Libraries
// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
#import <UIKit/UIKit.h>
#import <GenSolutions/GenSolutions.Api.Image.Saturate/Image.Saturate.h>


// Local Libraries
// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
#import "GoogleTranslate.h"
#import "CameraApi.h"
#import "LanguagePickerActionSheet.h"
#import "InfoViewController.h"


// Forwards
// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
@protocol CameraViewControllerDelegate;
@class OcrApi;

// Class
// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
@interface CameraViewController : UIViewController
< 
    CameraApiDelegate,
    LanguagePickerActionSheetDelegate, 
    GoogleTranslateDelegate,
    InfoViewControllerDelegate
>
{
    OcrApi* ocrApi;
    CameraApi* cameraApi;
    ImageSaturate* imageSaturate;

	id <CameraViewControllerDelegate> delegate;

    // languages
    BOOL isSourceLanguageMode;
    int sourceLanguageIndex;
    int destinationLanguageIndex;

    // image processing
    bool translateTapped;

    CGRect rectToCopy;
    NSMutableString* textFromImage;

    CGImageRef _image;
    CALayer* _previewLayer;

    bool ocrThreadFinished;
    bool canUpdateImage;
    bool isImageInUse;

    // UI
    IBOutlet UIImageView* imageResult;          // child 2
    IBOutlet UIImageView* overlayTopLeft;       // child 4
    IBOutlet UIImageView* overlayTopRight;      // child 5
    IBOutlet UIImageView* overlayBottomLeft;    // child 6
    IBOutlet UIImageView* overlayBottomRight;   // child 7

    IBOutlet UIButton* sourceLanguageButton;      // child 8
    IBOutlet UIButton* sourceLanguageLabel;       // child 9 
    IBOutlet UIButton* destinationLanguageButton; // child 10
    IBOutlet UIButton* destinationLanguageLabel;  // child 11
}

// Code
@property (nonatomic, assign) OcrApi* ocrApi;
@property (nonatomic, assign) CameraApi* cameraApi;
@property (nonatomic, assign) id <CameraViewControllerDelegate> delegate;
@property (retain) UIAcceleration* lastAcceleration;

-(void) initTessaract:(id)sender;
-(UIImage*) croppedImage:(UIImage*)image fromRect:(CGRect)fromRect;
-(CGImageRef) rotatedCGImageByAngle:(CGImageRef)imgRef angle:(CGFloat)angle;
-(NSString*) processImage:(UIImage*)image;
-(void) setImageProcessingWidth:(CGFloat)width AndHeight:(CGFloat)height;
-(void) moveOverlaysWidth:(CGFloat)width AndHeight:(CGFloat)height;
-(void) theMethod:(id)image;
    
// UI
@property (nonatomic,retain) UIImageView* imageResult;
@property (nonatomic,retain) UIImageView* overlayTopLeft;
@property (nonatomic,retain) UIImageView* overlayTopRight;
@property (nonatomic,retain) UIImageView* overlayBottomLeft;
@property (nonatomic,retain) UIImageView* overlayBottomRight;

@property (nonatomic,retain) UIButton* sourceLanguageImage;
@property (nonatomic,retain) UIButton* sourceLanguageLabel;
@property (nonatomic,retain) UIButton* destinationLanguageImage;
@property (nonatomic,retain) UIButton* destinationLanguageLabel;

-(IBAction) viewControllerDone:(id)sender;
-(IBAction) chooseSourceLanguage:(id)sender;
-(IBAction) chooseDestinationLanguage:(id)sender;
-(IBAction) showHelp:(id)sender;

@end


// Delegates
// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
@protocol CameraViewControllerDelegate

-(void) cameraViewControllerDelegateDidFinish:(CameraViewController*)controller;

@end
