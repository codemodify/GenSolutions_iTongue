
// Locals
// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
#import "GoogleTranslate.h"
#import "JSON/JSON.h"
#import "MREntitiesConverter.h"

// Class Implementation
// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
@implementation GoogleTranslate

@synthesize delegate;

-(id) init {
    
    mutableData = [[NSMutableData data] retain];
    decoder = [[MREntitiesConverter alloc] init];
    
    return [super init];
}

-(void) dealloc {
    
    [mutableData release];
    [decoder release];
    
    [super dealloc];
}

-(NSString*) urlEncode:(NSString *)str {
    
    CFStringRef originalString = (CFStringRef) str;
    
    CFStringRef leaveUnescaped = CFSTR("ABCDEFGHIJKLMNOPQRSTUVWXYZ"
                                       "abcdefghijklmnopqrstuvwxyz"
                                       "-._~");
    CFStringRef forceEscaped =  CFSTR("%!$&'()*+,/:;=?@");
    
    CFStringRef escapedStr = NULL;
    if (str) {
        escapedStr = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                             originalString,
                                                             leaveUnescaped,
                                                             forceEscaped,
                                                             kCFStringEncodingUTF8);
        [(id)CFMakeCollectable(escapedStr) autorelease];
    }
    
    return (NSString *)escapedStr;
}

-(NSString*) urlDecode:(NSString*)str {
    NSString *plainStr = [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return plainStr;
}

-(void) translate:(NSString*)text source:(NSString*)source destination:(NSString*)destination {
    
//    NSString* sourceLanguage = @"en";
//    NSString* destinationLanguage = @"fr";
//    NSString* textToTranslate = @"I want money !";
    NSString* googleApiTemplatePart1 = @"https://ajax.googleapis.com/ajax/services/language/translate?v=1.0&q=";
    NSString* googleApiTemplatePart2 = @"&langpair=";
    NSString* googleApiTemplatePart3 = @"%7C";
    NSString* translateApiRequest = 
        [NSString stringWithFormat: @"%@%@%@%@%@%@", 
         googleApiTemplatePart1, 
         [self urlEncode:text], 
         googleApiTemplatePart2, 
         source, 
         googleApiTemplatePart3, 
         destination ];

	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:translateApiRequest]];
	[[NSURLConnection alloc] initWithRequest:request delegate:self];    
}

-(void) connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse *)response {

	[mutableData setLength:0];
}

-(void) connection:(NSURLConnection*)connection didReceiveData:(NSData *)data {

	[mutableData appendData:data];
}

-(void) connection:(NSURLConnection*)connection didFailWithError:(NSError *)error {

    if( delegate != nil ) {

        [delegate textFailedToTranslate:[error description] translator:self];
    }
}

-(void) connectionDidFinishLoading:(NSURLConnection*)connection {

	[connection release];

	NSString *responseString = [[NSString alloc] initWithData:mutableData encoding:NSUTF8StringEncoding];

//    NSLog( responseString );
//	[mutableData release];

	NSError *error;

	SBJSON* json = [[SBJSON new] autorelease];
	NSArray* jsonResponse = [json objectWithString:responseString error:&error];
	[responseString release];

    if( jsonResponse&& [jsonResponse isKindOfClass:[NSDictionary class]] ){

        NSDictionary* responseData = [jsonResponse objectForKey:@"responseData"];

        if( responseData && [responseData isKindOfClass:[NSDictionary class]] ){

            NSString* translatedText = [responseData objectForKey:@"translatedText"];
                
            if( translatedText ){
                    
                NSString* decodedString = [[decoder convertEntiesInString:translatedText] retain];
            
                if( delegate != nil ) {
                    [delegate textTranslated:decodedString translator:self];
                }
            }
        }
    }
}

@end

