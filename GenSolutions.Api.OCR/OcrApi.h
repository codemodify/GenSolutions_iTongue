
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

enum OcrInputLanguage
{
    OcrInputLanguageStart       = 0,
    
    OcrInputLanguageEnglish     = 1,
    OcrInputLanguageFrench      = 2,
    OcrInputLanguageJapanese    = 3,
    
    OcrInputLanguageEnd

};
typedef OcrInputLanguage OcrInputLanguage;


@interface OcrApi : NSObject {

    // about
    NSString* Version;
}

@property (nonatomic,retain,readonly) NSString* Version;

- (id)initWithDataPath:(NSString*)dataPath andInputLanguage:(OcrInputLanguage)inputLanguage;
- (void)release;

- (NSString*)analyzeImageAndGetText: (UIImage*)image;

@end
