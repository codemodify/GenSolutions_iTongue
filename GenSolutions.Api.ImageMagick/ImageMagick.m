
#import "ImageMagick.h"

#include "wand/MagickWand.h"


@implementation ImageMagick


#pragma mark ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
#pragma mark initImageMagick()
#pragma mark ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----

+(void) initImageMagick{
    
    char* argv[] = { "GenSolutions.Api.ImageMagick" };

    MagickCoreGenesis( *argv, MagickTrue );
}

#pragma mark ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
#pragma mark Helpers
#pragma mark ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----

+(NSString*) applicationDocumentsDirectory {
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    
    NSString* basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    
    return basePath;
}

+(char**) buildArgv:(NSArray*)stringList {

    int argc = [stringList count];

    char** argv = (char**) malloc( sizeof(char*)*argc );
    
    for( int i=0; i < argc; i++ ) {
        
        NSString* command = [stringList objectAtIndex:i];
        const char* commandAsAscii = [command cStringUsingEncoding:NSASCIIStringEncoding];
        
        argv[i] = (char*) malloc( sizeof(char)*([command length]+1) );
        strcpy( argv[i], commandAsAscii );
        argv[i][ [command length] ] = 0x0;
    }
    
    return argv;
}

+(void) freeArgv:(char**)argv argc:(int)argc {

    for( int i=0; i < argc; i++ ) {
        
        free( argv[i] );
    }

    free(argv);
}

#pragma mark ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
#pragma mark convertImage()
#pragma mark ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
+(void) convert:(NSString*)command {
    
    if( command == nil )
        return;

    NSAutoreleasePool* myPool = [[NSAutoreleasePool alloc] init];
    
    ExceptionInfo* exceptionInfo;
    ImageInfo* imageInfo;
    MagickBooleanType operationStatus;
    
    NSString* argvAsString = command;
    NSArray* stringList = [argvAsString componentsSeparatedByString:@" "];

    int argc = [stringList count];
    char** argv = [ImageMagick buildArgv:stringList];
    
    // run magick operations
    exceptionInfo   = AcquireExceptionInfo();
    imageInfo       = AcquireImageInfo();
    operationStatus = MagickCommandGenesis( imageInfo, ConvertImageCommand, argc, argv, (char **) NULL, exceptionInfo );
    imageInfo       = DestroyImageInfo( imageInfo );
    exceptionInfo   = DestroyExceptionInfo( exceptionInfo );

    [ImageMagick freeArgv:argv argc:argc];

    [myPool release]; // will release the "stringList" and its content of strings
}

#pragma mark ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
#pragma mark deInitImageMagick()
#pragma mark ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
+(void) deInitImageMagick {
    
    MagickCoreTerminus();    
}


@end
