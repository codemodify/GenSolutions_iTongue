
#import <UIKit/UIKit.h>

@protocol LanguagePickerActionSheetDelegate;

@class LanguagePickerViewDataSource;

@interface LanguagePickerActionSheet : UIActionSheet {

    UIView* _parentView;
    LanguagePickerViewDataSource* _languagePickerViewDataSource;
	UIPickerView* _pickerView;
    UISegmentedControl* _okCancel;
    
    id <LanguagePickerActionSheetDelegate> _thisDelegate;
}

-(id) initWithForParentView:(UIView*)parentView
                  languages:(NSDictionary*)languages
                   delegate:(id < LanguagePickerActionSheetDelegate >)delegate;

-(void) adjustSize:(BOOL)landscape;
-(void) selectLanguage:(int)languageIndex;

@end

// Delegates
// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
@protocol LanguagePickerActionSheetDelegate

-(void) languagePickerActionSheetDidFinishWithLanguageIndex:(int)languageIndex
                                               languageCode:(NSString*)languageCode 
                                             languageLabel:(NSString*)languageLabel;

@end
