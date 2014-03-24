
#import "LanguagePickerViewDataSource.h"
#import "LanguagePickerRowView.h"
#import "TextViewController.h"

@implementation LanguagePickerViewDataSource

@synthesize languages;


- (void)dealloc {

    [_sortedKeys release];
    [languages release];

	[super dealloc];
}

+(UIImage*) getImageByCode:(NSString*)code {
    
    NSString* appPath = [[NSBundle mainBundle] bundlePath];
//    NSString* flasgsPath = [appPath stringByAppendingPathComponent:@"flags"];
    NSString* filePath = [appPath stringByAppendingFormat:@"/%@.png",code,nil];
    
    return [UIImage imageWithContentsOfFile:filePath];
}

+(NSString*) getSelectedLanguageCode:(NSDictionary*)dictionary index:(int)selectedIndex {

    NSArray* sortedKeys = [TextViewController sortedKeysFromDictionary:dictionary];
    
    NSString* key = [sortedKeys objectAtIndex:selectedIndex];
    
    return key;
}

+(NSString*) getSelectedLanguageLabel:(NSDictionary*)dictionary index:(int)selectedIndex {

    NSArray* sortedKeys = [TextViewController sortedKeysFromDictionary:dictionary];

    NSString* key = [sortedKeys objectAtIndex:selectedIndex];
    
    return [dictionary valueForKey:key];
}

-(int) getSelectedLanguageIndex {
    
    return selectedIndex;
}


#pragma mark -
#pragma mark UIPickerViewDataSource

-(CGFloat) pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {

	return [LanguagePickerRowView viewWidth];
}

-(CGFloat) pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {

	return [LanguagePickerRowView viewHeight];
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {

	return [languages count];
}

-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView {

	return 1;
}


#pragma mark -
#pragma mark UIPickerViewDelegate

// tell the picker which view to use for a given component and row, we have an array of views to show
-(UIView*) pickerView:(UIPickerView*)pickerView
           viewForRow:(NSInteger)row
         forComponent:(NSInteger)component
          reusingView:(UIView*)view {

    if( _sortedKeys == nil ) {
        
        _sortedKeys = [TextViewController sortedKeysFromDictionary:languages];
        [_sortedKeys retain];
    }
    
    NSString* key = [_sortedKeys objectAtIndex:row];
    
    LanguagePickerRowView* 
        languagePickerRowView = [[[LanguagePickerRowView alloc] initWithFrame:CGRectZero] autorelease];
        languagePickerRowView.title = [languages valueForKey:key];
        languagePickerRowView.image = [LanguagePickerViewDataSource getImageByCode:key];
    
    return languagePickerRowView;
}

-(void) pickerView:(UIPickerView*)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    selectedIndex = row;
}

@end
