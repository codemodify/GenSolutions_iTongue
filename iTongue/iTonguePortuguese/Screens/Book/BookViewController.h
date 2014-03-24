
// Local Libraries
// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
#import "CameraViewController.h"
#import "TextViewController.h"

// Class
// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
typedef enum {
    
    eBookModeStart,
    
    eWord = eBookModeStart,
    eLine,
    eParagraph,
    
    eBookModeEnd = eParagraph

} BookMode;

@interface BookViewController : CameraViewController< TextViewControllerDelegate > {

    BookMode _bookMode;
    
    bool canUpdateImageCopy;
    
    IBOutlet UIActivityIndicatorView* progress;
    IBOutlet UIView* panelResult;
    IBOutlet UIButton* cameraButton;
    
    BOOL isFlashOn;
}

@property (nonatomic,retain) UIActivityIndicatorView* progress;
@property (nonatomic,retain) UIView* panelResult;
@property (nonatomic,retain) UIButton* cameraButton;

-(IBAction) changeBookMode:(id)sender;
-(IBAction) ocr:(id)sender;
-(IBAction) turnFlashOnOff:(id)sender;

@end
