
// Local Libraries
// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
#import "CameraViewController.h"
#import "TextViewController.h"

// Class
// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----

@interface ScannerViewController : CameraViewController< TextViewControllerDelegate > {

    IBOutlet UIView* panelResult;               // root
    IBOutlet UIActivityIndicatorView* progress; // child
    IBOutlet UIButton* scanButton;              // child
    IBOutlet UIButton* validateButton;          // child
    IBOutlet UIButton* cancelButton;            // child
    
    bool isCropVisible;
    bool isPanOnOverlayTopLeft;
    bool isPanOnOverlayTopRight;
    bool isPanOnOverlayBottonLeft;
    bool isPanOnOverlayBottonRight;
    
    CGRect previousOWH;

    CGRect position1;
    CGRect position2;
    CGRect position3;
    CGRect position4;
}

@property (nonatomic,retain) UIView* panelResult;
@property (nonatomic,retain) UIActivityIndicatorView* progress;
@property (nonatomic,retain) UIButton* scanButton;
@property (nonatomic,retain) UIButton* validateButton;
@property (nonatomic,retain) UIButton* cancelButton;

-(IBAction) scan:(id)sender;
-(IBAction) translate:(id)sender;
-(IBAction) cancel:(id)sender;

@end
