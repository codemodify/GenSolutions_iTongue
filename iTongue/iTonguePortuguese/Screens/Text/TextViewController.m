
// System Libraries
// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
#import <sqlite3.h> // Import the SQLite database framework

// Local Libraries
// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
#import "TextViewController.h"
#import "LanguagePickerViewDataSource.h"
#import "MREntitiesConverter.h"


// Class Implementation
// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
@implementation TextViewController
@synthesize delegate, buttonSource, buttonResult, textSource, textResult, progress, onlineOffline, backButton, image;


#pragma mark ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
#pragma mark Helpers
#pragma mark ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----

+(NSDictionary*) getOutputLanguages {
    
    NSMutableDictionary* outputLanguages = [[NSMutableDictionary alloc]init];
//    [outputLanguages setValue:@"af"    forKey:@"Afrikaans"      ];
//    [outputLanguages setValue:@"sq"    forKey:@"Albanian"       ];
//    [outputLanguages setValue:@"ar"    forKey:@"Arabic"         ];
//    [outputLanguages setValue:@"hy"    forKey:@"Armenian"       ];
//    [outputLanguages setValue:@"az"    forKey:@"Azerbaijani"    ];
//    [outputLanguages setValue:@"eu"    forKey:@"Basque"         ];
//    [outputLanguages setValue:@"be"    forKey:@"Belarusian"     ];
//    [outputLanguages setValue:@"bg"    forKey:@"Bulgarian"      ];
//    [outputLanguages setValue:@"ca"    forKey:@"Catalan"        ];
//    [outputLanguages setValue:@"zh-CN" forKey:@"Chinese"        ];
//    [outputLanguages setValue:@"hr"    forKey:@"Croatian"       ];
//    [outputLanguages setValue:@"cs"    forKey:@"Czech"          ];
//    [outputLanguages setValue:@"da"    forKey:@"Danish"         ];
//    [outputLanguages setValue:@"nl"    forKey:@"Dutch"          ];
//    [outputLanguages setValue:@"en"    forKey:@"English"        ];
//    [outputLanguages setValue:@"et"    forKey:@"Estonian"       ];
//    [outputLanguages setValue:@"tl"    forKey:@"Filipino"       ];
//    [outputLanguages setValue:@"fi"     forKey:@"Finnish"        ];
//    [outputLanguages setValue:@"fr"    forKey:@"French"         ];
//    [outputLanguages setValue:@"gl"    forKey:@"Galician"       ];
//    [outputLanguages setValue:@"ka"    forKey:@"Georgian"       ];
//    [outputLanguages setValue:@"de"    forKey:@"German"         ];
//    [outputLanguages setValue:@"el"    forKey:@"Greek"          ];
//    [outputLanguages setValue:@"ht"    forKey:@"Haitian Creole" ];
//    [outputLanguages setValue:@"iw"    forKey:@"Hebrew"         ];
//    [outputLanguages setValue:@"hi"    forKey:@"Hindi"          ];
//    [outputLanguages setValue:@"hu"    forKey:@"Hungarian"      ];
//    [outputLanguages setValue:@"is"    forKey:@"Icelandic"      ];
//    [outputLanguages setValue:@"id"    forKey:@"Indonesian"     ];
//    [outputLanguages setValue:@"ga"    forKey:@"Irish"          ];
//    [outputLanguages setValue:@"it"    forKey:@"Italian"        ];
//    [outputLanguages setValue:@"ja"    forKey:@"Japanese"       ];
//    [outputLanguages setValue:@"ko"    forKey:@"Korean"         ];
//    [outputLanguages setValue:@"la"    forKey:@"Latin"          ];
//    [outputLanguages setValue:@"lv"    forKey:@"Latvian"        ];
//    [outputLanguages setValue:@"lt"    forKey:@"Lithuanian"     ];
//    [outputLanguages setValue:@"mk"    forKey:@"Macedonian"     ];
//    [outputLanguages setValue:@"ms"    forKey:@"Malay"          ];
//    [outputLanguages setValue:@"mt"    forKey:@"Maltese"        ];
//    [outputLanguages setValue:@"no"    forKey:@"Norwegian"      ];
//    [outputLanguages setValue:@"fa"    forKey:@"Persian"        ];
//    [outputLanguages setValue:@"pl"    forKey:@"Polish"         ];
//    [outputLanguages setValue:@"pt"    forKey:@"Portuguese"     ];
//    [outputLanguages setValue:@"ro"    forKey:@"Romanian"       ];
//    [outputLanguages setValue:@"ru"    forKey:@"Russian"        ];
//    [outputLanguages setValue:@"sr"    forKey:@"Serbian"        ];
//    [outputLanguages setValue:@"sk"    forKey:@"Slovak"         ];
//    [outputLanguages setValue:@"sl"    forKey:@"Slovenian"      ];
//    [outputLanguages setValue:@"es"    forKey:@"Spanish"        ];
//    [outputLanguages setValue:@"sw"    forKey:@"Swahili"        ];
//    [outputLanguages setValue:@"sv"    forKey:@"Swedish"        ];
//    [outputLanguages setValue:@"th"    forKey:@"Thai"           ];
//    [outputLanguages setValue:@"tr"    forKey:@"Turkish"        ];
//    [outputLanguages setValue:@"uk"    forKey:@"Ukrainian"      ];
//    [outputLanguages setValue:@"ur"    forKey:@"Urdu"           ];
//    [outputLanguages setValue:@"vi"    forKey:@"Vietnamese"     ];
//    [outputLanguages setValue:@"cy"    forKey:@"Welsh"          ];
//    [outputLanguages setValue:@"yi"    forKey:@"Yiddish"        ];
    
    [outputLanguages setValue:@"Afrikaans"      forKey:@"af"    ];
    [outputLanguages setValue:@"Albanian"       forKey:@"sq"    ];
    [outputLanguages setValue:@"Arabic"         forKey:@"ar"    ];
    [outputLanguages setValue:@"Armenian"       forKey:@"hy"    ];
    [outputLanguages setValue:@"Azerbaijani"    forKey:@"az"    ];
    [outputLanguages setValue:@"Basque"         forKey:@"eu"    ];
    [outputLanguages setValue:@"Belarusian"     forKey:@"be"    ];
    [outputLanguages setValue:@"Bulgarian"      forKey:@"bg"    ];
    [outputLanguages setValue:@"Catalan"        forKey:@"ca"    ];
    [outputLanguages setValue:@"Chinese"        forKey:@"zh-CN" ];
    [outputLanguages setValue:@"Croatian"       forKey:@"hr"    ];
    [outputLanguages setValue:@"Czech"          forKey:@"cs"    ];
    [outputLanguages setValue:@"Danish"         forKey:@"da"    ];
    [outputLanguages setValue:@"Dutch"          forKey:@"nl"    ];
    [outputLanguages setValue:@"English"        forKey:@"en"    ];
    [outputLanguages setValue:@"Estonian"       forKey:@"et"    ];
    [outputLanguages setValue:@"Filipino"       forKey:@"tl"    ];
    [outputLanguages setValue:@"Finnish"        forKey:@"fi"     ];
    [outputLanguages setValue:@"French"         forKey:@"fr"    ];
    [outputLanguages setValue:@"Galician"       forKey:@"gl"    ];
    [outputLanguages setValue:@"Georgian"       forKey:@"ka"    ];
    [outputLanguages setValue:@"German"         forKey:@"de"    ];
    [outputLanguages setValue:@"Greek"          forKey:@"el"    ];
    [outputLanguages setValue:@"Haitian Creole" forKey:@"ht"    ];
    [outputLanguages setValue:@"Hebrew"         forKey:@"iw"    ];
    [outputLanguages setValue:@"Hindi"          forKey:@"hi"    ];
    [outputLanguages setValue:@"Hungarian"      forKey:@"hu"    ];
    [outputLanguages setValue:@"Icelandic"      forKey:@"is"    ];
    [outputLanguages setValue:@"Indonesian"     forKey:@"id"    ];
    [outputLanguages setValue:@"Irish"          forKey:@"ga"    ];
    [outputLanguages setValue:@"Italian"        forKey:@"it"    ];
    [outputLanguages setValue:@"Japanese"       forKey:@"ja"    ];
    [outputLanguages setValue:@"Korean"         forKey:@"ko"    ];
    [outputLanguages setValue:@"Latin"          forKey:@"la"    ];
    [outputLanguages setValue:@"Latvian"        forKey:@"lv"    ];
    [outputLanguages setValue:@"Lithuanian"     forKey:@"lt"    ];
    [outputLanguages setValue:@"Macedonian"     forKey:@"mk"    ];
    [outputLanguages setValue:@"Malay"          forKey:@"ms"    ];
    [outputLanguages setValue:@"Maltese"        forKey:@"mt"    ];
    [outputLanguages setValue:@"Norwegian"      forKey:@"no"    ];
    [outputLanguages setValue:@"Persian"        forKey:@"fa"    ];
    [outputLanguages setValue:@"Polish"         forKey:@"pl"    ];
    [outputLanguages setValue:@"Portuguese"     forKey:@"pt"    ];
    [outputLanguages setValue:@"Romanian"       forKey:@"ro"    ];
    [outputLanguages setValue:@"Russian"        forKey:@"ru"    ];
    [outputLanguages setValue:@"Serbian"        forKey:@"sr"    ];
    [outputLanguages setValue:@"Slovak"         forKey:@"sk"    ];
    [outputLanguages setValue:@"Slovenian"      forKey:@"sl"    ];
    [outputLanguages setValue:@"Spanish"        forKey:@"es"    ];
    [outputLanguages setValue:@"Swahili"        forKey:@"sw"    ];
    [outputLanguages setValue:@"Swedish"        forKey:@"sv"    ];
    [outputLanguages setValue:@"Thai"           forKey:@"th"    ];
    [outputLanguages setValue:@"Turkish"        forKey:@"tr"    ];
    [outputLanguages setValue:@"Ukrainian"      forKey:@"uk"    ];
    [outputLanguages setValue:@"Urdu"           forKey:@"ur"    ];
    [outputLanguages setValue:@"Vietnamese"     forKey:@"vi"    ];
    [outputLanguages setValue:@"Welsh"          forKey:@"cy"    ];
    [outputLanguages setValue:@"Yiddish"        forKey:@"yi"    ];
    
//    NSDictionary* dictionary = [NSDictionary dictionaryWithDictionary:outputLanguages];
//    
//    [outputLanguages release];
//    
//    return dictionary;
    
    return outputLanguages;
}

+(NSDictionary*) getInputLanguages {
    
    NSMutableDictionary* inputLanguages = [[NSMutableDictionary alloc]init];
//        [inputLanguages setValue:@"zh-CN" forKey:@"Chinese"    ];
//        [inputLanguages setValue:@"de"    forKey:@"German"     ];
//        [inputLanguages setValue:@"en"    forKey:@"English"    ];
//        [inputLanguages setValue:@"fr"    forKey:@"French"     ];
//        [inputLanguages setValue:@"it"    forKey:@"Italian"    ];
//        [inputLanguages setValue:@"ja"    forKey:@"Japanese"   ];
//        [inputLanguages setValue:@"pt"    forKey:@"Portuguese" ];
//        [inputLanguages setValue:@"ru"    forKey:@"Russian"    ];
//        [inputLanguages setValue:@"es"    forKey:@"Spanish"    ];
    
        [inputLanguages setValue:@"Chinese"        forKey:@"zh-CN" ];
        [inputLanguages setValue:@"English"        forKey:@"en"    ];
        [inputLanguages setValue:@"French"         forKey:@"fr"    ];
        [inputLanguages setValue:@"German"         forKey:@"de"    ];
        [inputLanguages setValue:@"Italian"        forKey:@"it"    ];
        [inputLanguages setValue:@"Japanese"       forKey:@"ja"    ];
        [inputLanguages setValue:@"Portuguese"     forKey:@"pt"    ];
        [inputLanguages setValue:@"Russian"        forKey:@"ru"    ];
        [inputLanguages setValue:@"Spanish"        forKey:@"es"    ];

//    NSDictionary* dictionary = [NSDictionary dictionaryWithDictionary:inputLanguages];
//    
//    [inputLanguages release];
//    
//    return dictionary;
    return inputLanguages;
}

+(NSArray*) sortedKeysFromDictionary:(NSDictionary*)dictionary {
    
    NSArray* sortedKeys = [dictionary keysSortedByValueUsingSelector:@selector(caseInsensitiveCompare:)];
    
    return sortedKeys;
}

-(void) setSourceLanguages {

    NSDictionary* sourceLanguages = [TextViewController getInputLanguages];
    NSString* languageCode = [LanguagePickerViewDataSource getSelectedLanguageCode:sourceLanguages
                                                                             index:sourceLanguageIndex];

    buttonSource.imageView.image = [LanguagePickerViewDataSource getImageByCode:languageCode];
    [sourceLanguages release];

    NSDictionary* destinationLanguages = [TextViewController getOutputLanguages];
    languageCode = [LanguagePickerViewDataSource getSelectedLanguageCode:destinationLanguages
                                                                   index:destinationLanguageIndex];

    buttonResult.imageView.image = [LanguagePickerViewDataSource getImageByCode:languageCode];
    [destinationLanguages release];
}

-(void) saveSettings {
    
    NSNumber* sourceLanguageIndexAsNumber = [NSNumber numberWithInt:sourceLanguageIndex];
    NSNumber* destinationLanguageIndexAsNumber = [NSNumber numberWithInt:destinationLanguageIndex];
    NSNumber* isOfflineTranslationModeModeAsNumber = [NSNumber numberWithInt:isOfflineTranslationMode];
    
    [[NSUserDefaults standardUserDefaults] setObject:sourceLanguageIndexAsNumber forKey:@"sourceLanguageIndex"];
    [[NSUserDefaults standardUserDefaults] setObject:destinationLanguageIndexAsNumber forKey:@"destinationLanguageIndex"];
    [[NSUserDefaults standardUserDefaults] setObject:isOfflineTranslationModeModeAsNumber forKey:@"isOfflineTranslationMode"];
    [[NSUserDefaults standardUserDefaults] synchronize];    
}

-(void) loadSettings {
    
    sourceLanguageIndex      = [(NSNumber*) [[NSUserDefaults standardUserDefaults] objectForKey:@"sourceLanguageIndex"] intValue];
    destinationLanguageIndex = [(NSNumber*) [[NSUserDefaults standardUserDefaults] objectForKey:@"destinationLanguageIndex"] intValue];
    isOfflineTranslationMode  = [(NSNumber*) [[NSUserDefaults standardUserDefaults] objectForKey:@"isOfflineTranslationMode"] intValue];
    
    if( sourceLanguageIndex <= 0 )
        sourceLanguageIndex = 1;

    if( destinationLanguageIndex <= 0 )
        destinationLanguageIndex = 1;
}

-(void) translateOffline:(id)sender {

    progress.hidden = FALSE;

    // get language codes
    NSDictionary* sourceLanguages = [TextViewController getInputLanguages];
    NSDictionary* destinationLanguages = [TextViewController getOutputLanguages];

    NSString* sourceLanguageCode = [LanguagePickerViewDataSource getSelectedLanguageCode:sourceLanguages index:sourceLanguageIndex];
    NSString* destinationLanguageCode = [LanguagePickerViewDataSource getSelectedLanguageCode:destinationLanguages index:destinationLanguageIndex];

    [sourceLanguages release];
    [destinationLanguages release];
    
    sourceLanguageCode = [sourceLanguageCode stringByReplacingOccurrencesOfString:@"-" withString:@""];
    destinationLanguageCode = [destinationLanguageCode stringByReplacingOccurrencesOfString:@"-" withString:@""];

	// Setup the database object
    NSString* appPath = [[NSBundle mainBundle] bundlePath];
    NSString* sqlLiteDbFilePath = [appPath stringByAppendingPathComponent:@"dictionar.sqlite"];
    
	sqlite3* database;

    NSMutableString* translatedText = [[NSMutableString alloc] init];
    
	if( sqlite3_open([sqlLiteDbFilePath UTF8String], &database) == SQLITE_OK ) { // Open the database from the users filessytem

		// Setup the SQL Statement and compile it for faster access
        // select ru from dictionar where en = ( select en from dictionar where fr = 'argent' )

        NSString* adaptedSentence = [textSource.text stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
                  adaptedSentence = [adaptedSentence stringByReplacingOccurrencesOfString:@"\r\n" withString:@" "];
                  adaptedSentence = [adaptedSentence stringByReplacingOccurrencesOfString:@"\r" withString:@" "];

        NSArray* words = [adaptedSentence componentsSeparatedByString:@" "];

        for( int i=0; i < [words count]; i++ ) {
            
            NSString* word = [words objectAtIndex:i];

            NSMutableString*
                sqlStatement = [[NSMutableString alloc] init];
                [sqlStatement appendFormat:@"select %@ from dictionar where en = ( select en from dictionar where %@ = '%@' )", 
                 destinationLanguageCode, 
                 sourceLanguageCode, 
                 word, 
                 nil];
            
            BOOL wordWasFound = FALSE;
            
            sqlite3_stmt* compiledStatement;
            {
                if( sqlite3_prepare_v2(database, [sqlStatement UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK ) {
                    
                    while( sqlite3_step(compiledStatement) == SQLITE_ROW ) { // Loop through the results and add them to the feeds array
                     
                        wordWasFound = TRUE;
                        
                        char* result = (char*)sqlite3_column_text( compiledStatement, 0 ); // Read the data from the result row
                        
                        if( nil != result ) {
                            
                            [translatedText appendFormat:@" %@", [NSString stringWithUTF8String:(char*)result], nil];
                        }
                    }
                }
            }
            sqlite3_finalize(compiledStatement); // Release the compiled statement from memory
            
            [sqlStatement release];
            
            if( !wordWasFound ) {
                
                [translatedText appendFormat:@" %@", word, nil];
            }
        }
	}
	sqlite3_close(database);
    
    if( [translatedText length] == 0 ) {
        
        [translatedText appendString:NSLocalizedString( @"TextMode.Tranlsation.NoDataInDictionary", nil )];
        textResult.textColor = [UIColor redColor];
    }            

    // decode
    MREntitiesConverter* decoder = [[MREntitiesConverter alloc] init];
    
    textResult.text = [decoder convertEntiesInString:translatedText];
    
    [translatedText release];
    [decoder release];
    
    progress.hidden = TRUE;
}

-(void) translateOnline {
    
    progress.hidden = FALSE;
    
    backButton.enabled = FALSE;

    // get language codes
    NSDictionary* sourceLanguages = [TextViewController getInputLanguages];
    NSString* sourceLanguageCode = [LanguagePickerViewDataSource getSelectedLanguageCode:sourceLanguages
                                                                                   index:sourceLanguageIndex];
//    [sourceLanguages release];
    
    NSDictionary* destinationLanguages = [TextViewController getOutputLanguages];
    NSString* destinationLanguageCode = [LanguagePickerViewDataSource getSelectedLanguageCode:destinationLanguages
                                                                                        index:destinationLanguageIndex];
//    [destinationLanguages release];

    GoogleTranslate*
        googleTranslate = [[GoogleTranslate alloc] init];
        googleTranslate.delegate = self;

    [googleTranslate translate:textSource.text
                        source:sourceLanguageCode
                   destination:destinationLanguageCode];    
}

-(void) autoTranslate {
    
    shouldAutoTranslate = TRUE;
}


#pragma mark ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
#pragma mark UIViewController Overrides
#pragma mark ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----

- (void) viewDidLoad {

	[super viewDidLoad];

    [self loadSettings];
    [self setSourceLanguages];

    onlineOffline.selectedSegmentIndex = (int) isOfflineTranslationMode;
    [onlineOffline addTarget:self action:@selector(setOnlineOflineTranslation:) forControlEvents:UIControlEventValueChanged];
}

-(void) viewDidAppear:(BOOL)animated {
    
    if( shouldAutoTranslate ) {
        
        [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(translate:) userInfo:nil repeats:NO];

        shouldAutoTranslate = FALSE;
    }
}

- (void) didReceiveMemoryWarning {

    [super didReceiveMemoryWarning];
}

- (void) dealloc {

    if( image != nil )
        [image release];
    
    [super dealloc];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    BOOL supportedOrientation1 = ( interfaceOrientation == UIInterfaceOrientationPortrait );
    
    return supportedOrientation1;
}


#pragma mark ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
#pragma mark UI Controls Handlers
#pragma mark ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----

-(void) textTranslated:(NSString*)text translator:(GoogleTranslate*)translator {

    textResult.text = text;

    [text release];
    [translator release];

    progress.hidden = TRUE;
    
    backButton.enabled = TRUE;
}

-(void) textFailedToTranslate:(NSString*)error translator:(GoogleTranslate*)translator {
    
    [translator release];
    progress.hidden = TRUE;
    
    UIAlertView* messageBox = [[UIAlertView alloc] initWithTitle:NSLocalizedString( @"TextMode.Connection.ErrorMessage", nil )
                                                         message:nil
                                                        delegate:self
                                               cancelButtonTitle:@"Yes"
                                               otherButtonTitles:@"No", nil];
    [messageBox autorelease];
    [messageBox show];
    
    backButton.enabled = TRUE;    
}

-(void) alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    if( buttonIndex != 0 )
        return;

    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(translateOffline:) userInfo:nil repeats:NO];
}

-(BOOL) textView:(UITextView*)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if( [text isEqualToString:@"\n"] ) {
        
        [textView resignFirstResponder];
        
        return NO;
    }
    
    return YES;
}


#pragma mark ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
#pragma mark UI Controls Handlers
#pragma mark ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----

-(IBAction) done:(id)sender {
    
    if( nil != delegate )
        [self.delegate textViewControllerDelegateDidFinish:self];
}

-(IBAction) changeSource:(id)sender {
    
    isSourceLanguageMode = TRUE;
    
	LanguagePickerActionSheet*
        sheet = [[LanguagePickerActionSheet alloc] initWithForParentView:self.view
                                                               languages:[TextViewController getInputLanguages]
                                                                delegate:self];
        [sheet showInView:self.view];
        [sheet adjustSize:FALSE];
        [sheet selectLanguage:sourceLanguageIndex];
        [sheet release];
}

-(IBAction) changeResult:(id)sender {
    isSourceLanguageMode = FALSE;
    
	LanguagePickerActionSheet*
        sheet = [[LanguagePickerActionSheet alloc] initWithForParentView:self.view
                                                               languages:[TextViewController getOutputLanguages]
                                                                delegate:self];
        [sheet showInView:self.view];
        [sheet adjustSize:FALSE];
        [sheet selectLanguage:destinationLanguageIndex];
        [sheet release];
    
}

-(void) languagePickerActionSheetDidFinishWithLanguageIndex:(int)languageIndex
                                               languageCode:(NSString*)languageCode 
                                              languageLabel:(NSString*)languageLabel {
    
    if( isSourceLanguageMode ) { // reinit tessaract
        
        sourceLanguageIndex = languageIndex;
        buttonSource.imageView.image = [LanguagePickerViewDataSource getImageByCode:languageCode];
    }
    
    else {
        
        destinationLanguageIndex = languageIndex;        
        buttonResult.imageView.image = [LanguagePickerViewDataSource getImageByCode:languageCode];
    }
    
    [self saveSettings];
}

-(void) setOnlineOflineTranslation:(id)sender {
    
    isOfflineTranslationMode = onlineOffline.selectedSegmentIndex;
    
    [self saveSettings];
}

-(IBAction) translate:(id)sender {

    [textSource resignFirstResponder];
    textResult.text = @"";
    textResult.textColor = [UIColor blackColor];
    
    if( isOfflineTranslationMode )
        [self translateOffline:nil];
    
    else
        [self translateOnline];
}

-(IBAction) sendMail:(id)sender {

    if( [MFMailComposeViewController canSendMail] == FALSE ) {
        
        UIAlertView* messageBox = [[UIAlertView alloc] initWithTitle:NSLocalizedString( @"TextMode.Email.NotConfigured", nil )
                                                             message:nil
                                                            delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
        [messageBox autorelease];
        [messageBox show];

        return;
    }

    NSString* messageBody = [NSString stringWithFormat:@"%@<br/><br/>---<br/><a href=\"http://itongue.net\">iTongue.net<a>", textResult.text, nil];
    
    MFMailComposeViewController* 
        controller = [[MFMailComposeViewController alloc] init];
        controller.mailComposeDelegate = self;
        [controller setSubject:NSLocalizedString(@"TextMode.Email.Subject",nil)];
        [controller setMessageBody:messageBody isHTML:YES];
    
        if( image != nil ) {
            
            NSData* imageData = UIImageJPEGRepresentation( image, 90 );

            [controller addAttachmentData:imageData mimeType:@"image/jpeg" fileName:@"image.jpg"];
        }

        [self presentModalViewController:controller animated:YES];
        [controller release];
}

-(void) mailComposeController:(MFMailComposeViewController*)controller  
          didFinishWithResult:(MFMailComposeResult)result 
                        error:(NSError*)error {

//    if (result == MFMailComposeResultSent) {
//        NSLog(@"It's away!");
//    }

    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction) sendSms:(id)sender {
    
    if( [MFMessageComposeViewController canSendText] == FALSE ) {
        
        UIAlertView* messageBox = [[UIAlertView alloc] initWithTitle:NSLocalizedString( @"TextMode.Sms.NotConfigured", nil )
                                                             message:nil
                                                            delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
        [messageBox autorelease];
        [messageBox show];
        
        return;
    }

	MFMessageComposeViewController* 
        controller = [[[MFMessageComposeViewController alloc] init] autorelease];
		controller.body = textResult.text;
//		controller.recipients = [NSArray arrayWithObjects:@"12345678", @"87654321", nil];
		controller.messageComposeDelegate = self;
		[self presentModalViewController:controller animated:YES];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller 
                 didFinishWithResult:(MessageComposeResult)result {

//	switch (result) {
//		case MessageComposeResultCancelled:
//			NSLog(@"Cancelled");
//			break;
//		case MessageComposeResultFailed:
//			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"MyApp" message:@"Unknown Error"
//														   delegate:self cancelButtonTitle:@”OK” otherButtonTitles: nil];
//			[alert show];
//			[alert release];
//			break;
//		case MessageComposeResultSent:
//            
//			break;
//		default:
//			break;
//	}
    
	[self dismissModalViewControllerAnimated:YES];
}

@end
