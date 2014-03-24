
#import <UIKit/UIImage.h>
#import <QuartzCore/CALayer.h>


@interface UIImage( Skew )

+ (CATransform3D) computeTransformMatrix:(float)X 
                                       Y:(float)Y 
                                       W:(float)W 
                                       H:(float)H 
                                     x1a:(float)x1a
                                     y1a:(float)y1a 
                                     x2a:(float)x2a 
                                     y2a:(float)y2a 
                                     x3a:(float)x3a 
                                     y3a:(float)y3a 
                                     x4a:(float)x4a 
                                     y4a:(float)y4a;

// + (UIImage*) skew:(UIImage*) image width:(int)width height:(int)height;

@end
