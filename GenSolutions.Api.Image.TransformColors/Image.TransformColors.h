
#import <UIKit/UIKit.h>


@interface UIImage( TransformColors )

- (void) alter;

- (void) sharpen :(UIImage*)image byPercentage:(int)percentage;
- (void) saturate:(UIImage*)image byPercentage:(int)percentage;
- (void) gray    :(UIImage*)image;

- (void) save;
- (void) discard;

@end
