
#import <UIKit/UIImage.h>


@interface ImageSaturate : NSObject {
}

- (void) saturate:(UIImage*)image to:(int)value;
- (UIImage*) toGrayScale:(UIImage*) image;
    
@end
