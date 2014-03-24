
#import "LanguagePickerActionSheet.h"
#import "LanguagePickerViewDataSource.h"

@implementation LanguagePickerActionSheet

int c_pickerViewHeight = 44 * 3;
int c_okCancelHeight   = 50;
int c_spacer           = 10;

-(id) initWithForParentView:(UIView*)parentView
                  languages:(NSDictionary*)languages
                   delegate:(id < LanguagePickerActionSheetDelegate >)delegate {

	self = [super initWithTitle:nil
                       delegate:nil
              cancelButtonTitle:nil
         destructiveButtonTitle:nil
              otherButtonTitles:nil];

    _parentView = parentView;
    _thisDelegate = delegate;
    
    
    // add picker
    _languagePickerViewDataSource = [[LanguagePickerViewDataSource alloc] init];
    _languagePickerViewDataSource.languages = languages;
    
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectZero];
    _pickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    _pickerView.dataSource = _languagePickerViewDataSource;
    _pickerView.delegate = _languagePickerViewDataSource;
    _pickerView.showsSelectionIndicator = YES;
    
    [self addSubview:_pickerView];

    // add ok / cancel
    _okCancel = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"OK",@"Cancel",nil]];
    _okCancel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _okCancel.segmentedControlStyle = UISegmentedControlStyleBordered;
    [_okCancel addTarget:self action:@selector(dismissActionSheet:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_okCancel];
    
	return self;
}

- (void)dealloc {

    [_okCancel release];
    [_pickerView release];
    [_languagePickerViewDataSource release];

    [super dealloc];
}

-(void) adjustSize:(BOOL)landscape {

    [UIView beginAnimations:nil context:nil];

    CGRect thisViewFrame;

    if( landscape ) {
        
        thisViewFrame = CGRectMake( 0, 0, _parentView.frame.size.height, _parentView.frame.size.width );
        thisViewFrame.origin.x    = _parentView.frame.size.height / 2 - _parentView.frame.size.width / 2;
        thisViewFrame.size.width  = _parentView.frame.size.width;
        thisViewFrame.origin.y    = _parentView.frame.size.width - ( c_pickerViewHeight + c_spacer + c_spacer + c_spacer + c_okCancelHeight );
        thisViewFrame.size.height =                                ( c_pickerViewHeight + c_spacer + c_spacer + c_spacer + c_okCancelHeight );
    }
    else {
        thisViewFrame = CGRectMake( 0, 0, _parentView.frame.size.width, _parentView.frame.size.height );
//        thisViewFrame.origin.x    = _parentView.frame.size.height / 2 - _parentView.frame.size.width / 2;
        thisViewFrame.size.width  = _parentView.frame.size.width;
        thisViewFrame.origin.y    = _parentView.frame.size.height - ( c_pickerViewHeight + c_spacer + c_spacer + c_spacer + c_okCancelHeight );
        thisViewFrame.size.height =                                 ( c_pickerViewHeight + c_spacer + c_spacer + c_spacer + c_okCancelHeight );
    }

    self.frame = thisViewFrame;

    CGRect
        pickerViewFrame             = CGRectMake( 0, 0, self.frame.size.width, self.frame.size.height );
        pickerViewFrame.origin.y    = 0;
        pickerViewFrame.size.height = c_pickerViewHeight;

    _pickerView.frame = pickerViewFrame;

    CGRect
        okCancelFrame             = CGRectMake( 0, 0, self.frame.size.width, self.frame.size.height );
        okCancelFrame.origin.y    = c_pickerViewHeight + c_spacer + c_spacer + c_spacer;
        okCancelFrame.size.height = c_okCancelHeight;

    _okCancel.frame = okCancelFrame;

    [UIView commitAnimations]; 
}

-(void) selectLanguage:(int)languageIndex {
    
    [_pickerView selectRow:languageIndex inComponent:0 animated:YES];
}

-(IBAction) dismissActionSheet:(id)sender {

    UISegmentedControl* segmentedControl = (UISegmentedControl*)sender;

    [self dismissWithClickedButtonIndex:segmentedControl.selectedSegmentIndex animated:YES];

    if( _thisDelegate != nil ) {

        int selectedIndex = [_languagePickerViewDataSource getSelectedLanguageIndex];
        [_thisDelegate languagePickerActionSheetDidFinishWithLanguageIndex: selectedIndex
                                                              languageCode:[LanguagePickerViewDataSource getSelectedLanguageCode:_languagePickerViewDataSource.languages index:selectedIndex] 
                                                             languageLabel:[LanguagePickerViewDataSource getSelectedLanguageLabel:_languagePickerViewDataSource.languages index:selectedIndex]];
    }
}

@end
