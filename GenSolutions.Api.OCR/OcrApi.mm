
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

@synthesize Version;

TessBaseAPI* tessBaseAPI = 0;

-(const char*) stringToCharArray:(NSString*) string {
    return [ string cStringUsingEncoding:NSUTF8StringEncoding ];
}

-(NSString*) charArrayToString:(const char*) charArray {
    return [ NSString stringWithCString:charArray encoding:NSUTF8StringEncoding ];
}

-(NSString*) getInputLanguageAsString:(OcrInputLanguage)inputLanguage {
    
    switch (inputLanguage) {

        case OcrInputLanguageEnglish:
            return @"eng";
            
        case OcrInputLanguageFrench:
            return @"fra";
            
        case OcrInputLanguageJapanese:
            return @"jap";
            
        default:
            return @"eng";
    }
}

- (id)initWithDataPath:(NSString*)dataPath andInputLanguage:(OcrInputLanguage)inputLanguage {
    
    Version = [[NSString alloc] initWithString:@"GenSolutions OCR Library for iOS, Build - digger release 1"];

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

- (void)release {

    delete tessBaseAPI;
    
    [Version release];
    [super release];
}

- (NSString*)analyzeImageAndGetText: (UIImage*)image {
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

@end
