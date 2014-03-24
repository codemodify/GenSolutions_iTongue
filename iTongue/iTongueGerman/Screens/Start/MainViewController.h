
#import <UIKit/UIKit.h>

#import "CameraViewController.h"
#import "TextViewController.h"
#import "InfoViewController.h"


@interface MainViewController : UIViewController
    <
        CameraViewControllerDelegate, 
        TextViewControllerDelegate, 
        UINavigationControllerDelegate, 
        UIActionSheetDelegate,
        InfoViewControllerDelegate
    > {
}

-(IBAction) showHelp:(id)sender;

-(IBAction) showBookMode:(id)sender;
-(IBAction) showTravelMode:(id)sender;
-(IBAction) showScannerMode:(id)sender;
-(IBAction) showTextMode:(id)sender;

@end
