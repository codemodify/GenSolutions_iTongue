
// System Libraries
// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

// Local Libraries
// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
#import "GoogleTranslate.h"
#import "LanguagePickerActionSheet.h"


@protocol TextViewControllerDelegate;

@interface TextViewController : UIViewController
<
    GoogleTranslateDelegate, 
    UITextViewDelegate,
    LanguagePickerActionSheetDelegate,
    UIAlertViewDelegate,
    MFMailComposeViewControllerDelegate,
    MFMessageComposeViewControllerDelegate
>{

    id <TextViewControllerDelegate> delegate;

    IBOutlet UIButton* buttonSource;
    IBOutlet UIButton* buttonResult;

    IBOutlet UITextView* textSource;
    IBOutlet UITextView* textResult;

    IBOutlet UIActivityIndicatorView* progress;

    IBOutlet UISegmentedControl* onlineOffline;

    IBOutlet UIBarButtonItem* backButton;
    
    UIImage* image;

    // languages
    BOOL shouldAutoTranslate;
    BOOL isOfflineTranslationMode;
    BOOL isSourceLanguageMode;
    int sourceLanguageIndex;
    int destinationLanguageIndex;
}

@property (nonatomic, assign) id <TextViewControllerDelegate> delegate;

@property (nonatomic, assign) UIButton* buttonSource;
@property (nonatomic, assign) UIButton* buttonResult;

@property (nonatomic, assign) UITextView* textSource;
@property (nonatomic, assign) UITextView* textResult;

@property (nonatomic, assign) UIActivityIndicatorView* progress;

@property (nonatomic, assign) UISegmentedControl* onlineOffline;

@property (nonatomic, assign) UIBarButtonItem* backButton;

@property (nonatomic, assign) UIImage* image;


-(IBAction) done:(id)sender;

-(IBAction) changeSource:(id)sender;
-(IBAction) changeResult:(id)sender;

-(IBAction) translate:(id)sender;

-(IBAction) sendMail:(id)sender;
-(IBAction) sendSms:(id)sender;

-(void) autoTranslate;

+(NSDictionary*) getOutputLanguages;
+(NSDictionary*) getInputLanguages;
+(NSArray*) sortedKeysFromDictionary:(NSDictionary*)dictionary;

@end

// Delegates
// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
@protocol TextViewControllerDelegate

-(void) textViewControllerDelegateDidFinish:(TextViewController*)controller;

@end
