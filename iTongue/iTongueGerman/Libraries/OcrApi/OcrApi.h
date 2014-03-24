
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

enum OcrInputLanguage {

    OcrInputLanguageStart       = 0,
    
    OcrInputLanguageChinese     = 1,
    OcrInputLanguageGerman      = 2,
    OcrInputLanguageEnglish     = 3,
    OcrInputLanguageFrench      = 4,
    OcrInputLanguageItalian     = 5,
    OcrInputLanguageJapanese    = 6,
    OcrInputLanguagePortuguese  = 7,
    OcrInputLanguageRussian     = 8,
    OcrInputLanguageSpanish     = 9,

    OcrInputLanguageEnd
};

typedef OcrInputLanguage OcrInputLanguage;


@interface OcrApi : NSObject {
    
    NSMutableString* _currentLanguage;
}

-(id) initWithDataPath:(NSString*)dataPath andInputLanguage:(OcrInputLanguage)inputLanguage;
-(void) setCurrentLanguage:(NSString*)currentLanguage;
-(NSString*) getCurrentLanguage;



//-(NSString*) analyzeImageAndGetText:(UIImage*)image;
-(NSString*) analyzeImageAndGetText:(CGImageRef)image;

@end
