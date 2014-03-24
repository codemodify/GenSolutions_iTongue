
@interface LanguagePickerViewDataSource : NSObject <UIPickerViewDataSource, UIPickerViewDelegate> {

	NSDictionary* languages;
    NSArray* _sortedKeys;
    
    int selectedIndex;
}

@property (nonatomic, retain) NSDictionary* languages;

+(UIImage*) getImageByCode:(NSString*)code;
+(NSString*) getSelectedLanguageCode:(NSDictionary*)dictionary index:(int)selectedIndex;
+(NSString*) getSelectedLanguageLabel:(NSDictionary*)dictionary index:(int)selectedIndex;

-(int) getSelectedLanguageIndex;


@end
