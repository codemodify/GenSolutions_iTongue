
// Local Libraries
// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
#import "InfoViewController.h"

// Class Implementation
// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
@implementation InfoViewController
@synthesize delegate, webView;



#pragma mark ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
#pragma mark UIViewController Overrides
#pragma mark ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----

-(id) initForContext:(int)helpInfo {

    self = [super init];
    
    _helpInfo = (HelpInfo)helpInfo;
    
    return self;
}

-(void) viewWillAppear:(BOOL)animated {
    
    NSString* languageCode = [[NSLocale preferredLanguages] objectAtIndex:0];
    
    languageCode = [languageCode substringToIndex:2];

    NSString* filePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"help-%@-%d", languageCode, _helpInfo, nil]
                                                         ofType:@"htm"];

    NSData* htmlData = [NSData dataWithContentsOfFile:filePath];
    if( htmlData ) {

        [webView loadData:htmlData 
                 MIMEType:@"text/html" 
         textEncodingName:@"UTF-8" 
                  baseURL:[NSURL URLWithString:@"http://itongue.net"]];
    }
    else {
        filePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"help-en-%d", _helpInfo, nil]
                                                  ofType:@"htm"];
        
        NSData* htmlData = [NSData dataWithContentsOfFile:filePath];

        [webView loadData:htmlData 
                 MIMEType:@"text/html" 
         textEncodingName:@"UTF-8"
                  baseURL:[NSURL URLWithString:@"http://itongue.net"]];
    }
    
    [super viewWillAppear:animated];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    BOOL supportedOrientation1 = ( interfaceOrientation == UIInterfaceOrientationPortrait );
    
    return supportedOrientation1;
}


#pragma mark ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
#pragma mark UI Controls Handlers
#pragma mark ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----

-(IBAction) done:(id)sender {
    
    if( nil != delegate )
        [self.delegate infoViewControllerDelegateDidFinish:self];
}

@end
