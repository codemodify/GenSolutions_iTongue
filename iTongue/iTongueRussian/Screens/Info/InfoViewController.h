
// System Libraries
// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
#import <UIKit/UIKit.h>
//#import <MessageUI/MessageUI.h>
//#import <MessageUI/MFMailComposeViewController.h>


typedef enum {

    HelpInfoStart    = 0,

    HelpInfoHome     = 1,
    HelpInfoTravel   = 2,
    HelpInfoBook     = 3,
    HelpInfoScanner  = 4,

    HelpInfoEnd

} HelpInfo;


@protocol InfoViewControllerDelegate;

@interface InfoViewController : UIViewController
//<
//    UIAlertViewDelegate,
//    MFMailComposeViewControllerDelegate,
//    MFMessageComposeViewControllerDelegate
//>
{

    id <InfoViewControllerDelegate> delegate;

    IBOutlet UIWebView* webView;
    
    HelpInfo _helpInfo;
}

@property (nonatomic, assign) id <InfoViewControllerDelegate> delegate;

@property (nonatomic, assign) UIWebView* webView;

-(id) initForContext:(int)helpInfo;
-(IBAction) done:(id)sender;

@end

// Delegates
// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
@protocol InfoViewControllerDelegate

-(void) infoViewControllerDelegateDidFinish:(InfoViewController*)controller;

@end
