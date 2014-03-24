
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

    if( _currentLanguage != nil ) {
        
        [_currentLanguage release];
    }
        
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
    
    // set the valid symbols
    
    NSString* languageSpecifficValidSymbols = nil;

    if( inputLanguage == OcrInputLanguageGerman ) {
        
        // http://en.wikipedia.org/wiki/German_alphabet
        languageSpecifficValidSymbols = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789ÄäÖöÜü";
    }
    
    else if( inputLanguage == OcrInputLanguageEnglish ) {

        // http://en.wikipedia.org/wiki/English_alphabet
        languageSpecifficValidSymbols = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
    }
    
    else if( inputLanguage == OcrInputLanguageFrench ) {
        
        // http://en.wikipedia.org/wiki/French_alphabet
        languageSpecifficValidSymbols = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789éàèùâêîôûëïüÿçŒÆ";
    }

    else if( inputLanguage == OcrInputLanguageItalian ) {
        
        // http://en.wikipedia.org/wiki/English_alphabet
        languageSpecifficValidSymbols = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789àèéêìíîòóôùú"; 
    }    

    else if( inputLanguage == OcrInputLanguagePortuguese ) {
        
        // http://en.wikipedia.org/wiki/English_alphabet
        languageSpecifficValidSymbols = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789çáâãàéêíóôõú";
    }    

    else if( inputLanguage == OcrInputLanguageRussian ) {
        
        // http://en.wikipedia.org/wiki/Russian_alphabet
        languageSpecifficValidSymbols = @"АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯабвгдеёжзийклмнопрстуфхцчшщъыьэюя0123456789";
    }

    else if( inputLanguage == OcrInputLanguageSpanish ) {
        
        // http://en.wikipedia.org/wiki/Spanish_alphabet
        languageSpecifficValidSymbols = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789Ññ";
    }
    
    else {
        languageSpecifficValidSymbols = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
    }

    if
    (
       (inputLanguage != OcrInputLanguageJapanese)
        && 
       (inputLanguage != OcrInputLanguageChinese)
        &&
       (inputLanguage != OcrInputLanguageRussian)
    )
    {
        
        NSString* punctuationValidSymbols = @"`!@#$%^&*()_+=-[]\\;',./{}|:\"<>?";
        NSString* currencyValidSymbols = @"$€¥£";  // US EUR JAP GBP - lacking CostaRica IndianRupee
        
        NSString* validSymbols = [NSString stringWithFormat:@"%@%@%@", languageSpecifficValidSymbols, punctuationValidSymbols, currencyValidSymbols ];
        
        tessBaseAPI->SetVariable( "tessedit_char_whitelist", [validSymbols cString] );
        tessBaseAPI->SetVariable( "doc_dict_enable", "0" );
    }

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
    
    NSString* textFromImage = nil;
    if( text != NULL ) {
        
        textFromImage = [self charArrayToString:text];
    
        delete[] text;
    }

    CFRelease( data );
    
    return textFromImage == nil ? @"" : textFromImage;
}

@end
