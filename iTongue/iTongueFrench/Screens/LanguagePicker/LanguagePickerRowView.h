
#import <UIKit/UIKit.h>

@interface LanguagePickerRowView : UIView {

	NSString* title;
	UIImage* image;
}

@property (nonatomic, retain) NSString* title;
@property (nonatomic, retain) UIImage* image;

+(CGFloat) viewWidth;
+(CGFloat) viewHeight;

@end
