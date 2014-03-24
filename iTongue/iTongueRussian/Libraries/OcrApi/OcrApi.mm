
// Locals
// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
#import "OcrApi.h"

// Tesseract
// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
#import "baseapi.h"
using namespace tesseract;

// Class Implementation
// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
@implementation OcrApi

TessBaseAPI* tessBaseAPI = 0;

-(const char*) stringToCharArray:(NSString*) string {

    return [ string cStringUsingEncoding:NSUTF8StringEncoding ];
}

-(NSString*) charArrayToString:(const char*) charArray {

    return [ NSString stringWithCString:charArray 
                               encoding:NSUTF8StringEncoding ];
}

-(NSString*) getInputLanguageAsString:(OcrInputLanguage)inputLanguage {

    switch( inputLanguage ) {

        case OcrInputLanguageChinese    : return @"chi";
        case OcrInputLanguageGerman     : return @"deu";
        case OcrInputLanguageEnglish    : return @"eng";
        case OcrInputLanguageFrench     : return @"fra";
        case OcrInputLanguageItalian    : return @"ita";
        case OcrInputLanguageJapanese   : return @"jpn";
        case OcrInputLanguagePortuguese : return @"por";
        case OcrInputLanguageRussian    : return @"rus";
        case OcrInputLanguageSpanish    : return @"spa";

        default:
            return @"eng";
    }
}

-(id) initWithDataPath:(NSString*)dataPath andInputLanguage:(OcrInputLanguage)inputLanguage {

    _currentLanguage = [[NSMutableString alloc] init];
    
    // init the tesseract engine
    dataPath = [ NSString stringWithFormat:@"%@/", [dataPath stringByDeletingLastPathComponent] ];
    setenv( "TESSDATA_PREFIX", [self stringToCharArray:dataPath], 1 );

    tessBaseAPI = new TessBaseAPI();
    tessBaseAPI->Init
    (
        [self stringToCharArray:dataPath],
        [self stringToCharArray:[self getInputLanguageAsString:inputLanguage]]
    );

    return [super init];
}

-(void) setCurrentLanguage:(NSString*)currentLanguage {

    [_currentLanguage setString:currentLanguage];
}

-(NSString*) getCurrentLanguage {
    
    return _currentLanguage;
}

-(void) dealloc {

    [_currentLanguage release];

    delete tessBaseAPI;
    
    [super dealloc];
}

/*
-(NSString*) analyzeImageAndGetText: (UIImage*)image {

    CGSize imageSize = [image size];
    int bytes_per_line  = (int)CGImageGetBytesPerRow([image CGImage]);
    int bytes_per_pixel = (int)CGImageGetBitsPerPixel([image CGImage]) / 8.0;
        
    CFDataRef data = CGDataProviderCopyData(CGImageGetDataProvider([image CGImage]));
    const UInt8 *imageData = CFDataGetBytePtr(data);
        
    // this could take a while.
    char* text = tessBaseAPI->TesseractRect( imageData, bytes_per_pixel, bytes_per_line, 0, 0, imageSize.width, imageSize.height);

    NSString* textFromImage = [self charArrayToString:text];
        
    delete[] text;

    return textFromImage;
}
*/
-(NSString*) analyzeImageAndGetText:(CGImageRef)image {
    
    int bytes_per_line = (int)CGImageGetBytesPerRow ( image );
    int bytes_per_pixel = (int)CGImageGetBitsPerPixel( image ) / 8.0;
    
    CFDataRef data = CGDataProviderCopyData( CGImageGetDataProvider( image ) );
    const UInt8 *imageData = CFDataGetBytePtr( data );
    
    // this could take a while.
    char* text = tessBaseAPI->TesseractRect( imageData, bytes_per_pixel, bytes_per_line, 0, 0, CGImageGetWidth(image), CGImageGetHeight(image) );
    
    NSString* textFromImage = [self charArrayToString:text];
    
    delete[] text;

    CFRelease( data );
    
    return textFromImage;
}

@end
