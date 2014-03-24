
// Local Libraries
// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
#import "CameraViewController.h"
#import "TextViewController.h"

// Class
// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
typedef enum {
    
    eTravelZoomStart,
    
    eOneX = eTravelZoomStart,
    eTwoX,
    eThreeX,
    eFourX,
    
    eTravelZoomEnd = eFourX

} TravelZoom;

@interface TravelViewController : CameraViewController< TextViewControllerDelegate > {

    TravelZoom _zoom;

    bool canUpdateImageCopy;

    IBOutlet UIView* panelResult;               // root
    IBOutlet UIActivityIndicatorView* progress; // child
    IBOutlet UIButton* cameraButton;            // child
    
    bool isPanOnOverlayTopLeft;
    bool isPanOnOverlayTopRight;
    bool isPanOnOverlayBottonLeft;
    bool isPanOnOverlayBottonRight;
    
    BOOL isFlashOn;
    
    CGRect previousOWH;
    
    CGRect oneXzoomSize;
}

@property (nonatomic,retain) UIView* panelResult;
@property (nonatomic,retain) UIActivityIndicatorView* progress;
@property (nonatomic,retain) UIButton* cameraButton;

-(IBAction) changeZoom:(id)sender;
-(IBAction) ocr:(id)sender;
-(IBAction) turnFlashOnOff:(id)sender;

@end
