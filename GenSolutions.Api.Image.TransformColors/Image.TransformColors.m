
#import "Image.TransformColors.h"
#import "Image.TransformColors.Helpers.m"

@implementation UIImage( TransformColors )

UInt8* imageRawData = NULL;
int    imageWidth   = 0;
int    imageHeight  = 0;

-(void) alter {
    
    CGImageRef               imageRef = [self CGImage];
    CGDataProviderRef dataProviderRef = CGImageGetDataProvider( imageRef );
    CFDataRef                 dataRef = CGDataProviderCopyData( dataProviderRef );
    
    imageRawData = (UInt8*) CFDataGetBytePtr( dataRef ); // intentionally cast it to read/write
    imageWidth   = self.size.width;
    imageHeight  = self.size.height;
    
    CGDataProviderRelease( dataProviderRef );
    CGImageRelease( imageRef );
}

- (void) sharpen:(UIImage*)image byPercentage:(int)percentage {
}

- (void) saturate:(UIImage*)image byPercentage:(int)percentage {
}

- (void) gray:(UIImage*)image {

	for( int indexY=0; indexY < imageHeight; indexY++ )
	{
		for( int indexX=0; indexX < imageWidth; indexX++ )
		{
            QRgb pixelValue = getLineAsArray( imageRawData, imageWidth, imageHeight, indexY )[ indexX ];

            getLineAsArray( imageRawData, imageWidth, imageHeight, indexY )[ indexX ] = qGray( pixelValue );
        }
    }
}

- (void) save {

    UIImage* resultUIImage = nil;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef       context = CGBitmapContextCreate( imageRawData, imageWidth, imageHeight, 8, imageWidth*sizeof(uint32_t), colorSpace, kCGBitmapByteOrder32Little|kCGImageAlphaNoneSkipLast );
    CGImageRef           image = CGBitmapContextCreateImage( context );
    {
        resultUIImage = [ UIImage imageWithCGImage:image ];

    }
    CGImageRelease( image );
    CGContextRelease( context );
    CGColorSpaceRelease( colorSpace );

    NSData* nsData = [ NSData dataWithBytesNoCopy:imageRawData length:imageWidth * imageHeight ];
    
    [self initWithData:nsData ];
}

- (void) discard {
}

@end
