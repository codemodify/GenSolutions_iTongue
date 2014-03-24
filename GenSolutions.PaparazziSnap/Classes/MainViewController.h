
#import "FlipsideViewController.h"
#import "UploadToFacebook.h"
#import "AFOpenFlowView.h"
#import "MessageListController.h"

@interface MainViewController : UIViewController
    <
        FlipsideViewControllerDelegate,
        UploadToFacebookControllerDelegate,

        UIImagePickerControllerDelegate, 
        UINavigationControllerDelegate,

        AFOpenFlowViewDelegate,
        AFOpenFlowViewDataSource,

        FBRequestDelegate,
        UIAlertViewDelegate,

        FacebookApiDelegate
    >
{
    NSOperationQueue *loadImagesOperationQueue;
    UIImagePickerController* imagePickerController;

    NSString* imagesPath;
    NSString* imagesPathsIdsFile;
    NSMutableDictionary* imagesPathsIds;
    
    UILongPressGestureRecognizer* longPressGestureRecognizer;
    UITapGestureRecognizer* doubleTapGestureRecognizer;
    UITapGestureRecognizer* singleTapGestureRecognizer;
    
    IBOutlet UIButton* likesButton;
    IBOutlet UILabel* likesCount;
    IBOutlet UIActivityIndicatorView* facebookRequestIndicator;
    IBOutlet UIToolbar* toolbar;
    
    MessageListController* messageListController;

    NSTimer* timer;
    int currentImageIndex;
}

@property (nonatomic, assign) UIButton* likesButton;
@property (nonatomic, assign) UILabel* likesCount;
@property (nonatomic, assign) UIActivityIndicatorView* facebookRequestIndicator;

- (void)rescanImages;

- (IBAction)removeImage:(id)sender;
- (IBAction)showSettings:(id)sender;
- (IBAction)takePicture:(id)sender;
- (IBAction)showWhoLikedThePhoto:(id)sender;

@end
