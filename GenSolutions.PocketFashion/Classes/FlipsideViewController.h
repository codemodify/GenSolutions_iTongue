
#import <UIKit/UIKit.h>
#import <GenSolutions.Api.Facebook/iOS/FacebookApi.h>


@protocol FlipsideViewControllerDelegate;

@interface FlipsideViewController : UIViewController<FBSessionDelegate> {
	id <FlipsideViewControllerDelegate> delegate;

    IBOutlet UIButton* facebookOnButton;
    IBOutlet UIButton* facebookOffButton;
}

@property (nonatomic, assign) id <FlipsideViewControllerDelegate> delegate;
@property (nonatomic, assign) UIButton* facebookOnButton;
@property (nonatomic, assign) UIButton* facebookOffButton;

- (IBAction)done:(id)sender;
- (IBAction)facebookOn:(id)sender;
- (IBAction)facebookOff:(id)sender;

@end

@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
@end

