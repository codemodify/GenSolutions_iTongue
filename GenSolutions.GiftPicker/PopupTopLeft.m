
#import "PopupTopLeft.h"


@implementation PopupTopLeft


- (id)initWithFrame:(CGRect)frame {

    // load an image to use as background
    UIImage* bacgroundImage = [UIImage imageNamed:@"PopupTopLeft.png"];

//    frame.origin.x = 0;
//    frame.origin.y = 0;
    frame.size.width = bacgroundImage.size.width;
    frame.size.height = bacgroundImage.size.height;
    
    if( self = [super initWithFrame:frame] ){
        
        // clear the background color of the overlay
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
        
        UIImageView*
            searcherView = [[UIImageView alloc] initWithImage:bacgroundImage];
            searcherView.frame = CGRectMake( 0, 0, frame.size.width, frame.size.height );

        [self addSubview:searcherView];
        [searcherView release];
    }

    return self;
}

- (void)dealloc {

    [super dealloc];
}


@end
