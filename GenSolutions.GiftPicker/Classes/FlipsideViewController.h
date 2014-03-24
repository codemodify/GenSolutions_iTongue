
#import <UIKit/UIKit.h>
#import <GenSolutions.Api.Facebook/iOS/FacebookApi.h>


@protocol FlipsideViewControllerDelegate;

@interface FlipsideViewController : UIViewController<FBSessionDelegate> {
	id <FlipsideViewControllerDelegate> delegate;
    IBOutlet UISwitch* facebookSwitch;
}

@property (nonatomic, assign) id <FlipsideViewControllerDelegate> delegate;
@property (nonatomic, assign) UISwitch* facebookSwitch;
@property (nonatomic, assign) UISwitch* tweeterSwitch;

- (IBAction)done:(id)sender;
- (IBAction)facebookOnOff:(id)sender;
- (IBAction)twitterOnOff:(id)sender;

@end

@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
@end

