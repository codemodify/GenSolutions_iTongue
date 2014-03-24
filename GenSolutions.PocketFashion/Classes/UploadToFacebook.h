
#import <UIKit/UIKit.h>
#import <GenSolutions.Api.Facebook/iOS/FacebookApi.h>


@protocol UploadToFacebookControllerDelegate;

@interface UploadToFacebook : UIViewController
    <
        UITextFieldDelegate,

        FacebookApiDelegate,
        FBDialogDelegate,

        UIAlertViewDelegate
    >
{
    id <UploadToFacebookControllerDelegate> delegate;
    UIImage* image;
    NSString* uploadedPhotoId;

    IBOutlet UIButton* doneButton;
    IBOutlet UIImageView* facebookUploadPictureView;
    IBOutlet UIButton* facebookUploadPostAndAskButton;
    IBOutlet UIActivityIndicatorView* activityIndicatorView;
    IBOutlet UITextField* comment;
}

@property (nonatomic, assign) id <UploadToFacebookControllerDelegate> delegate;

@property (nonatomic, assign) UIImage* image;
@property (nonatomic, assign) NSString* uploadedPhotoId;

@property (nonatomic, assign) UIButton* doneButton;
@property (nonatomic, assign) UIImageView* facebookUploadPictureView;
@property (nonatomic, assign) UIButton* facebookUploadPostAndAskButton;
@property (nonatomic, assign) UIActivityIndicatorView* activityIndicatorView;
@property (nonatomic, assign) UITextField* comment;

- (IBAction)done:(id)sender;
- (IBAction)facebookUploadPostAndAsk:(id)sender;

@end

@protocol UploadToFacebookControllerDelegate
- (void)uploadToFacebookViewControllerDidFinish:(UploadToFacebook *)controller;
@end
