
#import "ImageMagickWorkspaceViewController.h"
#import <GenSolutions/GenSolutions.Api.ImageMagick/ImageMagick.h>

@implementation ImageMagickWorkspaceViewController

@synthesize delegate;

@synthesize image;
@synthesize imageView;
@synthesize activityIndicator;

@synthesize propertiesLabels;
@synthesize propertiesValues;
@synthesize applyCameraButtons;

@synthesize propertyValueSlider1;
@synthesize propertyValueSlider2;
@synthesize propertyValueSlider3;
@synthesize propertyValueSlider4;

@synthesize effectName;


// Helpers Effect List
// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
-(NSArray*) getImageMagickEffectNameList {
    
    if( imageMagickEffectNameList != nil )
        return imageMagickEffectNameList;
    
    NSArray* effectNames = [NSArray arrayWithObjects:
                            @"-adaptive-blur",
                            @"-adaptive-resize",
                            @"-adaptive-sharpen",
                            @"-adjoin",
                            @"-affine",
                            @"-alpha",
                            @"-annotate",
                            @"-antialias",
                            @"-append",
                            @"-attenuate",
                            @"-authenticate",
                            @"-auto-gamma",
                            @"-auto-level",
                            @"-auto-orient",
                            @"-backdrop",
                            @"-background",
                            @"-bench",
                            @"-bias",
                            @"-black-point-compensation",
                            @"-black-threshold",
                            @"-blend",
                            @"-blue-primary",
                            @"-blue-shift",
                            @"-blur",
                            @"-border",
                            @"-bordercolor",
                            @"-borderwidth",
                            @"-brightness-contrast",
                            @"-cache",
                            @"-caption",
                            @"-cdl",
                            @"-channel",
                            @"-charcoal",
                            @"-chop",
                            @"-clamp",
                            @"-clip",
                            @"-clip-mask",
                            @"-clip-path",
                            @"-clone",
                            @"-clut",
                            @"-coalesce",
                            @"-colorize",
                            @"-colormap",
                            @"-color-matrix",
                            @"-colors",
                            @"-colorspace",
                            @"-combine",
                            @"-comment",
                            @"-compose",
                            @"-composite",
                            @"-compress",
                            @"-contrast",
                            @"-contrast-stretch",
                            @"-convolve",
                            @"-crop",
                            @"-cycle",
                            @"-debug",
                            @"-decipher",
                            @"-deconstruct",
                            @"-define",
                            @"-delay",
                            @"-delete",
                            @"-density",
                            @"-depth",
                            @"-descend",
                            @"-deskew",
                            @"-despeckle",
                            @"-direction",
                            @"-displace",
                            @"-display",
                            @"-dispose",
                            @"-dissimilarity-threshold",
                            @"-dissolve",
                            @"-distort",
                            @"-dither",
                            @"-draw",
                            @"-duplicate",
                            @"-edge",
                            @"-emboss",
                            @"-encipher",
                            @"-encoding",
                            @"-endian",
                            @"-enhance",
                            @"-equalize",
                            @"-evaluate",
                            @"-evaluate-sequence",
                            @"-extent",
                            @"-extract",
                            @"-family",
                            @"-features",
                            @"-fft",
                            @"-fill",
                            @"-filter",
                            @"-flatten",
                            @"-flip",
                            @"-floodfill",
                            @"-flop",
                            @"-font",
                            @"-foreground",
                            @"-format",
                            @"-format[identify]",
                            @"-frame",
                            @"-frame[import]",
                            @"-function",
                            @"-fuzz",
                            @"-fx",
                            @"-gamma",
                            @"-gaussian-blur",
                            @"-geometry",
                            @"-gravity",
                            @"-green-primary",
                            @"-hald-clut",
                            @"-help",
                            @"-highlight-color",
                            @"-iconGeometry",
                            @"-iconic",
                            @"-identify",
                            @"-ift",
                            @"-immutable",
                            @"-implode",
                            @"-insert",
                            @"-intent",
                            @"-interlace",
                            @"-interpolate",
                            @"-interline-spacing",
                            @"-interword-spacing",
                            @"-kerning",
                            @"-label",
                            @"-lat",
                            @"-layers",
                            @"-level",
                            @"-level-colors",
                            @"-limit",
                            @"-linear-stretch",
                            @"-linewidth",
                            @"-liquid-rescale",
                            @"-list",
                            @"-log",
                            @"-loop",
                            @"-lowlight-color",
                            @"-magnify",
                            @"-map",
                            @"-map[stream]",
                            @"-mask",
                            @"-mattecolor",
                            @"-median",
                            @"-metric",
                            @"-mode",
                            @"-modulate",
                            @"-monitor",
                            @"-monochrome",
                            @"-morph",
                            @"-morphology",
                            @"-mosaic",
                            @"-motion-blur",
                            @"-name",
                            @"-negate",
                            @"-noise",
                            @"-normalize",
                            @"-opaque",
                            @"-ordered-dither",
                            @"-orient",
                            @"-page",
                            @"-paint",
                            @"-path",
                            @"-pause[animate]",
                            @"-pause[import]",
                            @"-pen",
                            @"-ping",
                            @"-pointsize",
                            @"-polaroid",
                            @"-posterize",
                            @"-precision",
                            @"-preview",
                            @"-print",
                            @"-process",
                            @"-profile",
                            @"-quality",
                            @"-quantize",
                            @"-quiet",
                            @"-radial-blur",
                            @"-raise",
                            @"-random-threshold",
                            @"-red-primary",
                            @"-regard-warnings",
                            @"-region",
                            @"-remap",
                            @"-remote",
                            @"-render",
                            @"-repage",
                            @"-resample",
                            @"-resize",
                            @"-respect-parentheses",
                            @"-reverse",
                            @"-roll",
                            @"-rotate",
                            @"-sample",
                            @"-sampling-factor",
                            @"-scale",
                            @"-scene",
                            @"-screen",
                            @"-seed",
                            @"-segment",
                            @"-selective-blur",
                            @"-separate",
                            @"-sepia-tone",
                            @"-set",
                            @"-shade",
                            @"-shadow",
                            @"-shared-memory",
                            @"-sharpen",
                            @"-shave",
                            @"-shear",
                            @"-sigmoidal-contrast",
                            @"-silent",
                            @"-size",
                            @"-sketch",
                            @"-smush",
                            @"-snaps",
                            @"-solarize",
                            @"-sparse-color",
                            @"-splice",
                            @"-spread",
                            @"-statistic",
                            @"-stegano",
                            @"-stereo",
                            @"-stretch",
                            @"-strip",
                            @"-stroke",
                            @"-strokewidth",
                            @"-style",
                            @"-subimage-search",
                            @"-swap",
                            @"-swirl",
                            @"-synchronize",
                            @"-taint",
                            @"-text-font",
                            @"-texture",
                            @"-threshold",
                            @"-thumbnail",
                            @"-tile",
                            @"-tile-offset",
                            @"-tint",
                            @"-title",
                            @"-transform",
                            @"-transparent",
                            @"-transparent-color",
                            @"-transpose",
                            @"-transverse",
                            @"-treedepth",
                            @"-trim",
                            @"-type",
                            @"-undercolor",
                            @"-unique-colors",
                            @"-units",
                            @"-unsharp",
                            @"-update",
                            @"-verbose",
                            @"-version",
                            @"-view",
                            @"-vignette",
                            @"-virtual-pixel",
                            @"-visual",
                            @"-watermark",
                            @"-wave",
                            @"-weight",
                            @"-white-point",
                            @"-white-threshold",
                            @"-window",
                            @"-window-group",
                            @"-write",
                            
                            @"TEXTCLEANER",
                            @"2COLORTHRESH",
                            
                            nil];

    imageMagickEffectNameList = [effectNames retain];

    return imageMagickEffectNameList;
}

-(NSArray*) getImageMagickEffectCommandList {
    
    if( imageMagickEffectCommandList != nil )
        return imageMagickEffectCommandList;
    
    NSArray* effectNames = [NSArray arrayWithObjects:
                            /*@"-adaptive-blur,*/               @"",
                            /*@"-adaptive-resize,*/             @"",
                            /*@"-adaptive-sharpen,*/            @"",
                            /*@"-adjoin,*/                      @"",
                            /*@"-affine,*/                       @"",
                            /*@"-alpha,*/                       @"",
                            /*@"-annotate,*/                    @"",
                            /*@"-antialias,*/                   @"",
                            /*@"-append,*/                      @"",
                            /*@"-attenuate,*/                   @"",
                            /*@"-authenticate,*/                @"",
                            /*@"-auto-gamma,*/                  @"",
                            /*@"-auto-level,*/                  @"",
                            /*@"-auto-orient,*/                 @"",
                            /*@"-backdrop,*/                    @"",
                            /*@"-background,*/                  @"",
                            /*@"-bench,*/                       @"",
                            /*@"-bias,*/                        @"",
                            /*@"-black-point-compensation,*/    @"",
                            /*@"-black-threshold,*/             @"",
                            /*@"-blend,*/                       @"",
                            /*@"-blue-primary,*/                @"",
                            /*@"-blue-shift,*/                  @"",
                            /*@"-blur,*/                        @"",
                            /*@"-border,*/                      @"",
                            /*@"-bordercolor,*/                 @"",
                            /*@"-borderwidth,*/                 @"",
                            /*@"-brightness-contrast,*/         @"",
                            /*@"-cache,*/                       @"",
                            /*@"-caption,*/                     @"",
                            /*@"-cdl,*/                         @"",
                            /*@"-channel,*/                     @"",
                            /*@"-charcoal,*/                    @"",
                            /*@"-chop,*/                        @"",
                            /*@"-clamp,*/                       @"",
                            /*@"-clip,*/                        @"",
                            /*@"-clip-mask,*/                   @"",
                            /*@"-clip-path,*/                   @"",
                            /*@"-clone,*/                       @"",
                            /*@"-clut,*/                        @"",
                            /*@"-coalesce,*/                    @"",
                            /*@"-colorize,*/                    @"",
                            /*@"-colormap,*/                    @"",
                            /*@"-color-matrix,*/                @"",
                            /*@"-colors,*/                      @"",
                            /*@"-colorspace,*/                  @"",
                            /*@"-combine,*/                     @"",
                            /*@"-comment,*/                     @"",
                            /*@"-compose,*/                     @"",
                            /*@"-composite,*/                   @"",
                            /*@"-compress,*/                    @"",
                            /*@"-contrast,*/                    @"",
                            /*@"-contrast-stretch,*/            @"",
                            /*@"-convolve,*/                    @"",
                            /*@"-crop,*/                        @"",
                            /*@"-cycle,*/                       @"",
                            /*@"-debug,*/                       @"",
                            /*@"-decipher,*/                    @"",
                            /*@"-deconstruct,*/                 @"",
                            /*@"-define,*/                       @"",
                            /*@"-delay,*/                       @"",
                            /*@"-delete,*/                      @"",
                            /*@"-density,*/                     @"",
                            /*@"-depth,*/                       @"",
                            /*@"-descend,*/                     @"",
                            /*@"-deskew,*/                      @"",
                            /*@"-despeckle,*/                   @"",
                            /*@"-direction,*/                   @"",
                            /*@"-displace,*/                    @"",
                            /*@"-display,*/                     @"",
                            /*@"-dispose,*/                     @"",
                            /*@"-dissimilarity-threshold,*/     @"",
                            /*@"-dissolve,*/                    @"",
                            /*@"-distort,*/                     @"",
                            /*@"-dither,*/                      @"",
                            /*@"-draw,*/                        @"",
                            /*@"-duplicate,*/                   @"",
                            /*@"-edge,*/                        @"",
                            /*@"-emboss,*/                      @"",
                            /*@"-encipher,*/                    @"",
                            /*@"-encoding,*/                    @"",
                            /*@"-endian,*/                      @"",
                            /*@"-enhance,*/                     @"",
                            /*@"-equalize,*/                    @"",
                            /*@"-evaluate,*/                    @"",
                            /*@"-evaluate-sequence,*/           @"",
                            /*@"-extent,*/                      @"",
                            /*@"-extract,*/                     @"",
                            /*@"-family,*/                      @"",
                            /*@"-features,*/                    @"",
                            /*@"-fft,*/                         @"",
                            /*@"-fill,*/                         @"",
                            /*@"-filter,*/                       @"",
                            /*@"-flatten,*/                      @"",
                            /*@"-flip,*/                         @"",
                            /*@"-floodfill,*/                     @"",
                            /*@"-flop,*/                         @"",
                            /*@"-font,*/                        @"",
                            /*@"-foreground,*/                  @"",
                            /*@"-format,*/                      @"",
                            /*@"-format[identify],*/            @"",
                            /*@"-frame,*/                       @"",
                            /*@"-frame[import],*/               @"",
                            /*@"-function,*/                    @"",
                            /*@"-fuzz,*/                        @"",
                            /*@"-fx,*/                          @"",
                            /*@"-gamma,*/                       @"",
                            /*@"-gaussian-blur,         i=107 */@"convert %@ -gaussian-blur %@x%@ %@",
                            /*@"-geometry,*/                    @"",
                            /*@"-gravity,*/                     @"",
                            /*@"-green-primary,*/               @"",
                            /*@"-hald-clut,*/                   @"",
                            /*@"-help,*/                        @"",
                            /*@"-highlight-color,*/             @"",
                            /*@"-iconGeometry,*/                @"",
                            /*@"-iconic,*/                      @"",
                            /*@"-identify,*/                    @"",
                            /*@"-ift,*/                         @"",
                            /*@"-immutable,*/                   @"",
                            /*@"-implode,*/                     @"",
                            /*@"-insert,*/                      @"",
                            /*@"-intent,*/                      @"",
                            /*@"-interlace,*/                   @"",
                            /*@"-interpolate,*/                 @"",
                            /*@"-interline-spacing,*/           @"",
                            /*@"-interword-spacing,*/           @"",
                            /*@"-kerning,*/                     @"",
                            /*@"-label,*/                       @"",
                            /*@"-lat,*/                         @"",
                            /*@"-layers,*/                      @"",
                            /*@"-level,*/                       @"",
                            /*@"-level-colors,*/                @"",
                            /*@"-limit,*/                       @"",
                            /*@"-linear-stretch,*/              @"",
                            /*@"-linewidth,*/                   @"",
                            /*@"-liquid-rescale,*/              @"",
                            /*@"-list,*/                        @"",
                            /*@"-log,*/                         @"",
                            /*@"-loop,*/                        @"",
                            /*@"-lowlight-color,*/              @"",
                            /*@"-magnify,*/                     @"",
                            /*@"-map,*/                         @"",
                            /*@"-map[stream],*/                 @"",
                            /*@"-mask,*/                        @"",
                            /*@"-mattecolor,*/                  @"",
                            /*@"-median,*/                      @"",
                            /*@"-metric,*/                      @"",
                            /*@"-mode,*/                        @"",
                            /*@"-modulate,*/                    @"",
                            /*@"-monitor,*/                     @"",
                            /*@"-monochrome,*/                  @"",
                            /*@"-morph,*/                       @"",
                            /*@"-morphology,*/                  @"",
                            /*@"-mosaic,*/                      @"",
                            /*@"-motion-blur,*/                 @"",
                            /*@"-name,*/                        @"",
                            /*@"-negate,*/                      @"",
                            /*@"-noise,*/                       @"",
                            /*@"-normalize,*/                   @"",
                            /*@"-opaque,*/                      @"",
                            /*@"-ordered-dither,*/              @"",
                            /*@"-orient,*/                      @"",
                            /*@"-page,*/                        @"",
                            /*@"-paint,*/                       @"",
                            /*@"-path,*/                        @"",
                            /*@"-pause[animate],*/              @"",
                            /*@"-pause[import],*/               @"",
                            /*@"-pen,*/                         @"",
                            /*@"-ping,*/                        @"",
                            /*@"-pointsize,*/                   @"",
                            /*@"-polaroid,*/                    @"",
                            /*@"-posterize,*/                   @"",
                            /*@"-precision,*/                   @"",
                            /*@"-preview,*/                     @"",
                            /*@"-print,*/                       @"",
                            /*@"-process,*/                     @"",
                            /*@"-profile,*/                      @"",
                            /*@"-quality,*/                     @"",
                            /*@"-quantize,*/                    @"",
                            /*@"-quiet,*/                       @"",
                            /*@"-radial-blur,*/                 @"",
                            /*@"-raise,*/                       @"",
                            /*@"-random-threshold,*/            @"",
                            /*@"-red-primary,*/                 @"",
                            /*@"-regard-warnings,*/             @"",
                            /*@"-region,*/                      @"",
                            /*@"-remap,*/                       @"",
                            /*@"-remote,*/                      @"",
                            /*@"-render,*/                      @"",
                            /*@"-repage,*/                      @"",
                            /*@"-resample,*/                    @"",
                            /*@"-resize,*/                      @"",
                            /*@"-respect-parentheses,*/         @"",
                            /*@"-reverse,*/                     @"",
                            /*@"-roll,*/                        @"",
                            /*@"-rotate,*/                      @"",
                            /*@"-sample,*/                      @"",
                            /*@"-sampling-factor,*/             @"",
                            /*@"-scale,*/                       @"",
                            /*@"-scene,*/                       @"",
                            /*@"-screen,*/                      @"",
                            /*@"-seed,*/                        @"",
                            /*@"-segment,*/                     @"",
                            /*@"-selective-blur,*/              @"",
                            /*@"-separate,*/                    @"",
                            /*@"-sepia-tone,*/                  @"",
                            /*@"-set,*/                         @"",
                            /*@"-shade,*/                       @"",
                            /*@"-shadow,*/                      @"",
                            /*@"-shared-memory,*/               @"",
                            /*@"-sharpen,*/                     @"",
                            /*@"-shave,*/                       @"",
                            /*@"-shear,*/                       @"",
                            /*@"-sigmoidal-contrast,*/          @"",
                            /*@"-silent,*/                      @"",
                            /*@"-size,*/                        @"",
                            /*@"-sketch,*/                      @"",
                            /*@"-smush,*/                       @"",
                            /*@"-snaps,*/                       @"",
                            /*@"-solarize,*/                    @"",
                            /*@"-sparse-color,*/                @"",
                            /*@"-splice,*/                      @"",
                            /*@"-spread,*/                      @"",
                            /*@"-statistic,*/                   @"",
                            /*@"-stegano,*/                     @"",
                            /*@"-stereo,*/                      @"",
                            /*@"-stretch,*/                     @"",
                            /*@"-strip,*/                       @"",
                            /*@"-stroke,*/                      @"",
                            /*@"-strokewidth,*/                 @"",
                            /*@"-style,*/                       @"",
                            /*@"-subimage-search,*/             @"",
                            /*@"-swap,*/                        @"",
                            /*@"-swirl,*/                       @"",
                            /*@"-synchronize,*/                 @"",
                            /*@"-taint,*/                       @"",
                            /*@"-text-font,*/                   @"",
                            /*@"-texture,*/                     @"",
                            /*@"-threshold,*/                   @"",
                            /*@"-thumbnail,*/                   @"",
                            /*@"-tile,*/                        @"",
                            /*@"-tile-offset,*/                 @"",
                            /*@"-tint,*/                        @"",
                            /*@"-title,*/                       @"",
                            /*@"-transform,*/                   @"",
                            /*@"-transparent,*/                 @"",
                            /*@"-transparent-color,*/           @"",
                            /*@"-transpose,*/                   @"",
                            /*@"-transverse,*/                  @"",
                            /*@"-treedepth,*/                   @"",
                            /*@"-trim,*/                        @"",
                            /*@"-type,*/                        @"",
                            /*@"-undercolor,*/                  @"",
                            /*@"-unique-colors,*/               @"",
                            /*@"-units,*/                       @"",
                            /*@"-unsharp,*/                     @"convert %@ -unsharp %@x%@+%@+%@ %@",
                            /*@"-update,*/                      @"",
                            /*@"-verbose,*/                     @"",
                            /*@"-version,*/                     @"",
                            /*@"-view,*/                        @"",
                            /*@"-vignette,*/                    @"",
                            /*@"-virtual-pixel,*/               @"",
                            /*@"-visual,*/                      @"",
                            /*@"-watermark,*/                   @"",
                            /*@"-wave,*/                        @"",
                            /*@"-weight,*/                      @"",
                            /*@"-white-point,*/                 @"",
                            /*@"-white-threshold,*/             @"",
                            /*@"-window,*/                      @"",
                            /*@"-window-group,*/                @"",
                            /*@"-write,*/                       @"",
                            
                            // index = 0 -> 269, => + 1
                            /*@"TEXTCLEANER",*/                 @"convert ( %@ -colorspace gray -type grayscale -contrast-stretch 0 ) ( -clone 0 -colorspace gray -negate -contrast-stretch 0 ) -compose copy_opacity -composite -fill white -opaque none +matte %@", // -deskew 40%%
                            /*@"2COLORTHRESH,*/                 @"convert %@ +dither -colors 2 -colorspace gray -contrast-stretch 1 %@",
                            
                            nil];

    imageMagickEffectCommandList = [effectNames retain];
    
    return imageMagickEffectCommandList;
}

-(NSArray*) getImageMagickEffectConfigList {
    
    if( imageMagickEffectConfigList != nil )
        return imageMagickEffectConfigList;
    
    NSArray* effectNames = [NSArray arrayWithObjects:
                            /*@"-adaptive-blur,*/               [NSArray arrayWithObjects: nil],
                            /*@"-adaptive-resize,*/             [NSArray arrayWithObjects: nil],
                            /*@"-adaptive-sharpen,*/            [NSArray arrayWithObjects: nil],
                            /*@"-adjoin,*/                      [NSArray arrayWithObjects: nil],
                            /*@"-affine,*/                       [NSArray arrayWithObjects: nil],
                            /*@"-alpha,*/                       [NSArray arrayWithObjects: nil],
                            /*@"-annotate,*/                    [NSArray arrayWithObjects: nil],
                            /*@"-antialias,*/                   [NSArray arrayWithObjects: nil],
                            /*@"-append,*/                      [NSArray arrayWithObjects: nil],
                            /*@"-attenuate,*/                   [NSArray arrayWithObjects: nil],
                            /*@"-authenticate,*/                [NSArray arrayWithObjects: nil],
                            /*@"-auto-gamma,*/                  [NSArray arrayWithObjects: nil],
                            /*@"-auto-level,*/                  [NSArray arrayWithObjects: nil],
                            /*@"-auto-orient,*/                 [NSArray arrayWithObjects: nil],
                            /*@"-backdrop,*/                    [NSArray arrayWithObjects: nil],
                            /*@"-background,*/                  [NSArray arrayWithObjects: nil],
                            /*@"-bench,*/                       [NSArray arrayWithObjects: nil],
                            /*@"-bias,*/                        [NSArray arrayWithObjects: nil],
                            /*@"-black-point-compensation,*/    [NSArray arrayWithObjects: nil],
                            /*@"-black-threshold,*/             [NSArray arrayWithObjects: nil],
                            /*@"-blend,*/                       [NSArray arrayWithObjects: nil],
                            /*@"-blue-primary,*/                [NSArray arrayWithObjects: nil],
                            /*@"-blue-shift,*/                  [NSArray arrayWithObjects: nil],
                            /*@"-blur,*/                        [NSArray arrayWithObjects: nil],
                            /*@"-border,*/                      [NSArray arrayWithObjects: nil],
                            /*@"-bordercolor,*/                 [NSArray arrayWithObjects: nil],
                            /*@"-borderwidth,*/                 [NSArray arrayWithObjects: nil],
                            /*@"-brightness-contrast,*/         [NSArray arrayWithObjects: nil],
                            /*@"-cache,*/                       [NSArray arrayWithObjects: nil],
                            /*@"-caption,*/                     [NSArray arrayWithObjects: nil],
                            /*@"-cdl,*/                         [NSArray arrayWithObjects: nil],
                            /*@"-channel,*/                     [NSArray arrayWithObjects: nil],
                            /*@"-charcoal,*/                    [NSArray arrayWithObjects: nil],
                            /*@"-chop,*/                        [NSArray arrayWithObjects: nil],
                            /*@"-clamp,*/                       [NSArray arrayWithObjects: nil],
                            /*@"-clip,*/                        [NSArray arrayWithObjects: nil],
                            /*@"-clip-mask,*/                   [NSArray arrayWithObjects: nil],
                            /*@"-clip-path,*/                   [NSArray arrayWithObjects: nil],
                            /*@"-clone,*/                       [NSArray arrayWithObjects: nil],
                            /*@"-clut,*/                        [NSArray arrayWithObjects: nil],
                            /*@"-coalesce,*/                    [NSArray arrayWithObjects: nil],
                            /*@"-colorize,*/                    [NSArray arrayWithObjects: nil],
                            /*@"-colormap,*/                    [NSArray arrayWithObjects: nil],
                            /*@"-color-matrix,*/                [NSArray arrayWithObjects: nil],
                            /*@"-colors,*/                      [NSArray arrayWithObjects: nil],
                            /*@"-colorspace,*/                  [NSArray arrayWithObjects: nil],
                            /*@"-combine,*/                     [NSArray arrayWithObjects: nil],
                            /*@"-comment,*/                     [NSArray arrayWithObjects: nil],
                            /*@"-compose,*/                     [NSArray arrayWithObjects: nil],
                            /*@"-composite,*/                   [NSArray arrayWithObjects: nil],
                            /*@"-compress,*/                    [NSArray arrayWithObjects: nil],
                            /*@"-contrast,*/                    [NSArray arrayWithObjects: nil],
                            /*@"-contrast-stretch,*/            [NSArray arrayWithObjects: nil],
                            /*@"-convolve,*/                    [NSArray arrayWithObjects: nil],
                            /*@"-crop,*/                        [NSArray arrayWithObjects: nil],
                            /*@"-cycle,*/                       [NSArray arrayWithObjects: nil],
                            /*@"-debug,*/                       [NSArray arrayWithObjects: nil],
                            /*@"-decipher,*/                    [NSArray arrayWithObjects: nil],
                            /*@"-deconstruct,*/                 [NSArray arrayWithObjects: nil],
                            /*@"-define,*/                       [NSArray arrayWithObjects: nil],
                            /*@"-delay,*/                       [NSArray arrayWithObjects: nil],
                            /*@"-delete,*/                      [NSArray arrayWithObjects: nil],
                            /*@"-density,*/                     [NSArray arrayWithObjects: nil],
                            /*@"-depth,*/                       [NSArray arrayWithObjects: nil],
                            /*@"-descend,*/                     [NSArray arrayWithObjects: nil],
                            /*@"-deskew,*/                      [NSArray arrayWithObjects: nil],
                            /*@"-despeckle,*/                   [NSArray arrayWithObjects: nil],
                            /*@"-direction,*/                   [NSArray arrayWithObjects: nil],
                            /*@"-displace,*/                    [NSArray arrayWithObjects: nil],
                            /*@"-display,*/                     [NSArray arrayWithObjects: nil],
                            /*@"-dispose,*/                     [NSArray arrayWithObjects: nil],
                            /*@"-dissimilarity-threshold,*/     [NSArray arrayWithObjects: nil],
                            /*@"-dissolve,*/                    [NSArray arrayWithObjects: nil],
                            /*@"-distort,*/                     [NSArray arrayWithObjects: nil],
                            /*@"-dither,*/                      [NSArray arrayWithObjects: nil],
                            /*@"-draw,*/                        [NSArray arrayWithObjects: nil],
                            /*@"-duplicate,*/                   [NSArray arrayWithObjects: nil],
                            /*@"-edge,*/                        [NSArray arrayWithObjects: nil],
                            /*@"-emboss,*/                      [NSArray arrayWithObjects: nil],
                            /*@"-encipher,*/                    [NSArray arrayWithObjects: nil],
                            /*@"-encoding,*/                    [NSArray arrayWithObjects: nil],
                            /*@"-endian,*/                      [NSArray arrayWithObjects: nil],
                            /*@"-enhance,*/                     [NSArray arrayWithObjects: nil],
                            /*@"-equalize,*/                    [NSArray arrayWithObjects: nil],
                            /*@"-evaluate,*/                    [NSArray arrayWithObjects: nil],
                            /*@"-evaluate-sequence,*/           [NSArray arrayWithObjects: nil],
                            /*@"-extent,*/                      [NSArray arrayWithObjects: nil],
                            /*@"-extract,*/                     [NSArray arrayWithObjects: nil],
                            /*@"-family,*/                      [NSArray arrayWithObjects: nil],
                            /*@"-features,*/                    [NSArray arrayWithObjects: nil],
                            /*@"-fft,*/                         [NSArray arrayWithObjects: nil],
                            /*@"-fill,*/                         [NSArray arrayWithObjects: nil],
                            /*@"-filter,*/                       [NSArray arrayWithObjects: nil],
                            /*@"-flatten,*/                      [NSArray arrayWithObjects: nil],
                            /*@"-flip,*/                         [NSArray arrayWithObjects: nil],
                            /*@"-floodfill,*/                     [NSArray arrayWithObjects: nil],
                            /*@"-flop,*/                         [NSArray arrayWithObjects: nil],
                            /*@"-font,*/                        [NSArray arrayWithObjects: nil],
                            /*@"-foreground,*/                  [NSArray arrayWithObjects: nil],
                            /*@"-format,*/                      [NSArray arrayWithObjects: nil],
                            /*@"-format[identify],*/            [NSArray arrayWithObjects: nil],
                            /*@"-frame,*/                       [NSArray arrayWithObjects: nil],
                            /*@"-frame[import],*/               [NSArray arrayWithObjects: nil],
                            /*@"-function,*/                    [NSArray arrayWithObjects: nil],
                            /*@"-fuzz,*/                        [NSArray arrayWithObjects: nil],
                            /*@"-fx,*/                          [NSArray arrayWithObjects: nil],
                            /*@"-gamma,*/                       [NSArray arrayWithObjects: nil],
                            /*@"-gaussian-blur,         i=107 */[NSArray arrayWithObjects: @"Radius", @"Sigma", nil],
                            /*@"-geometry,*/                    [NSArray arrayWithObjects: nil],
                            /*@"-gravity,*/                     [NSArray arrayWithObjects: nil],
                            /*@"-green-primary,*/               [NSArray arrayWithObjects: nil],
                            /*@"-hald-clut,*/                   [NSArray arrayWithObjects: nil],
                            /*@"-help,*/                        [NSArray arrayWithObjects: nil],
                            /*@"-highlight-color,*/             [NSArray arrayWithObjects: nil],
                            /*@"-iconGeometry,*/                [NSArray arrayWithObjects: nil],
                            /*@"-iconic,*/                      [NSArray arrayWithObjects: nil],
                            /*@"-identify,*/                    [NSArray arrayWithObjects: nil],
                            /*@"-ift,*/                         [NSArray arrayWithObjects: nil],
                            /*@"-immutable,*/                   [NSArray arrayWithObjects: nil],
                            /*@"-implode,*/                     [NSArray arrayWithObjects: nil],
                            /*@"-insert,*/                      [NSArray arrayWithObjects: nil],
                            /*@"-intent,*/                      [NSArray arrayWithObjects: nil],
                            /*@"-interlace,*/                   [NSArray arrayWithObjects: nil],
                            /*@"-interpolate,*/                 [NSArray arrayWithObjects: nil],
                            /*@"-interline-spacing,*/           [NSArray arrayWithObjects: nil],
                            /*@"-interword-spacing,*/           [NSArray arrayWithObjects: nil],
                            /*@"-kerning,*/                     [NSArray arrayWithObjects: nil],
                            /*@"-label,*/                       [NSArray arrayWithObjects: nil],
                            /*@"-lat,*/                         [NSArray arrayWithObjects: nil],
                            /*@"-layers,*/                      [NSArray arrayWithObjects: nil],
                            /*@"-level,*/                       [NSArray arrayWithObjects: nil],
                            /*@"-level-colors,*/                [NSArray arrayWithObjects: nil],
                            /*@"-limit,*/                       [NSArray arrayWithObjects: nil],
                            /*@"-linear-stretch,*/              [NSArray arrayWithObjects: nil],
                            /*@"-linewidth,*/                   [NSArray arrayWithObjects: nil],
                            /*@"-liquid-rescale,*/              [NSArray arrayWithObjects: nil],
                            /*@"-list,*/                        [NSArray arrayWithObjects: nil],
                            /*@"-log,*/                         [NSArray arrayWithObjects: nil],
                            /*@"-loop,*/                        [NSArray arrayWithObjects: nil],
                            /*@"-lowlight-color,*/              [NSArray arrayWithObjects: nil],
                            /*@"-magnify,*/                     [NSArray arrayWithObjects: nil],
                            /*@"-map,*/                         [NSArray arrayWithObjects: nil],
                            /*@"-map[stream],*/                 [NSArray arrayWithObjects: nil],
                            /*@"-mask,*/                        [NSArray arrayWithObjects: nil],
                            /*@"-mattecolor,*/                  [NSArray arrayWithObjects: nil],
                            /*@"-median,*/                      [NSArray arrayWithObjects: nil],
                            /*@"-metric,*/                      [NSArray arrayWithObjects: nil],
                            /*@"-mode,*/                        [NSArray arrayWithObjects: nil],
                            /*@"-modulate,*/                    [NSArray arrayWithObjects: nil],
                            /*@"-monitor,*/                     [NSArray arrayWithObjects: nil],
                            /*@"-monochrome,*/                  [NSArray arrayWithObjects: nil],
                            /*@"-morph,*/                       [NSArray arrayWithObjects: nil],
                            /*@"-morphology,*/                  [NSArray arrayWithObjects: nil],
                            /*@"-mosaic,*/                      [NSArray arrayWithObjects: nil],
                            /*@"-motion-blur,*/                 [NSArray arrayWithObjects: nil],
                            /*@"-name,*/                        [NSArray arrayWithObjects: nil],
                            /*@"-negate,*/                      [NSArray arrayWithObjects: nil],
                            /*@"-noise,*/                       [NSArray arrayWithObjects: nil],
                            /*@"-normalize,*/                   [NSArray arrayWithObjects: nil],
                            /*@"-opaque,*/                      [NSArray arrayWithObjects: nil],
                            /*@"-ordered-dither,*/              [NSArray arrayWithObjects: nil],
                            /*@"-orient,*/                      [NSArray arrayWithObjects: nil],
                            /*@"-page,*/                        [NSArray arrayWithObjects: nil],
                            /*@"-paint,*/                       [NSArray arrayWithObjects: nil],
                            /*@"-path,*/                        [NSArray arrayWithObjects: nil],
                            /*@"-pause[animate],*/              [NSArray arrayWithObjects: nil],
                            /*@"-pause[import],*/               [NSArray arrayWithObjects: nil],
                            /*@"-pen,*/                         [NSArray arrayWithObjects: nil],
                            /*@"-ping,*/                        [NSArray arrayWithObjects: nil],
                            /*@"-pointsize,*/                   [NSArray arrayWithObjects: nil],
                            /*@"-polaroid,*/                    [NSArray arrayWithObjects: nil],
                            /*@"-posterize,*/                   [NSArray arrayWithObjects: nil],
                            /*@"-precision,*/                   [NSArray arrayWithObjects: nil],
                            /*@"-preview,*/                     [NSArray arrayWithObjects: nil],
                            /*@"-print,*/                       [NSArray arrayWithObjects: nil],
                            /*@"-process,*/                     [NSArray arrayWithObjects: nil],
                            /*@"-profile,*/                      [NSArray arrayWithObjects: nil],
                            /*@"-quality,*/                     [NSArray arrayWithObjects: nil],
                            /*@"-quantize,*/                    [NSArray arrayWithObjects: nil],
                            /*@"-quiet,*/                       [NSArray arrayWithObjects: nil],
                            /*@"-radial-blur,*/                 [NSArray arrayWithObjects: nil],
                            /*@"-raise,*/                       [NSArray arrayWithObjects: nil],
                            /*@"-random-threshold,*/            [NSArray arrayWithObjects: nil],
                            /*@"-red-primary,*/                 [NSArray arrayWithObjects: nil],
                            /*@"-regard-warnings,*/             [NSArray arrayWithObjects: nil],
                            /*@"-region,*/                      [NSArray arrayWithObjects: nil],
                            /*@"-remap,*/                       [NSArray arrayWithObjects: nil],
                            /*@"-remote,*/                      [NSArray arrayWithObjects: nil],
                            /*@"-render,*/                      [NSArray arrayWithObjects: nil],
                            /*@"-repage,*/                      [NSArray arrayWithObjects: nil],
                            /*@"-resample,*/                    [NSArray arrayWithObjects: nil],
                            /*@"-resize,*/                      [NSArray arrayWithObjects: nil],
                            /*@"-respect-parentheses,*/         [NSArray arrayWithObjects: nil],
                            /*@"-reverse,*/                     [NSArray arrayWithObjects: nil],
                            /*@"-roll,*/                        [NSArray arrayWithObjects: nil],
                            /*@"-rotate,*/                      [NSArray arrayWithObjects: nil],
                            /*@"-sample,*/                      [NSArray arrayWithObjects: nil],
                            /*@"-sampling-factor,*/             [NSArray arrayWithObjects: nil],
                            /*@"-scale,*/                       [NSArray arrayWithObjects: nil],
                            /*@"-scene,*/                       [NSArray arrayWithObjects: nil],
                            /*@"-screen,*/                      [NSArray arrayWithObjects: nil],
                            /*@"-seed,*/                        [NSArray arrayWithObjects: nil],
                            /*@"-segment,*/                     [NSArray arrayWithObjects: nil],
                            /*@"-selective-blur,*/              [NSArray arrayWithObjects: nil],
                            /*@"-separate,*/                    [NSArray arrayWithObjects: nil],
                            /*@"-sepia-tone,*/                  [NSArray arrayWithObjects: nil],
                            /*@"-set,*/                         [NSArray arrayWithObjects: nil],
                            /*@"-shade,*/                       [NSArray arrayWithObjects: nil],
                            /*@"-shadow,*/                      [NSArray arrayWithObjects: nil],
                            /*@"-shared-memory,*/               [NSArray arrayWithObjects: nil],
                            /*@"-sharpen,*/                     [NSArray arrayWithObjects: nil],
                            /*@"-shave,*/                       [NSArray arrayWithObjects: nil],
                            /*@"-shear,*/                       [NSArray arrayWithObjects: nil],
                            /*@"-sigmoidal-contrast,*/          [NSArray arrayWithObjects: nil],
                            /*@"-silent,*/                      [NSArray arrayWithObjects: nil],
                            /*@"-size,*/                        [NSArray arrayWithObjects: nil],
                            /*@"-sketch,*/                      [NSArray arrayWithObjects: nil],
                            /*@"-smush,*/                       [NSArray arrayWithObjects: nil],
                            /*@"-snaps,*/                       [NSArray arrayWithObjects: nil],
                            /*@"-solarize,*/                    [NSArray arrayWithObjects: nil],
                            /*@"-sparse-color,*/                [NSArray arrayWithObjects: nil],
                            /*@"-splice,*/                      [NSArray arrayWithObjects: nil],
                            /*@"-spread,*/                      [NSArray arrayWithObjects: nil],
                            /*@"-statistic,*/                   [NSArray arrayWithObjects: nil],
                            /*@"-stegano,*/                     [NSArray arrayWithObjects: nil],
                            /*@"-stereo,*/                      [NSArray arrayWithObjects: nil],
                            /*@"-stretch,*/                     [NSArray arrayWithObjects: nil],
                            /*@"-strip,*/                       [NSArray arrayWithObjects: nil],
                            /*@"-stroke,*/                      [NSArray arrayWithObjects: nil],
                            /*@"-strokewidth,*/                 [NSArray arrayWithObjects: nil],
                            /*@"-style,*/                       [NSArray arrayWithObjects: nil],
                            /*@"-subimage-search,*/             [NSArray arrayWithObjects: nil],
                            /*@"-swap,*/                        [NSArray arrayWithObjects: nil],
                            /*@"-swirl,*/                       [NSArray arrayWithObjects: nil],
                            /*@"-synchronize,*/                 [NSArray arrayWithObjects: nil],
                            /*@"-taint,*/                       [NSArray arrayWithObjects: nil],
                            /*@"-text-font,*/                   [NSArray arrayWithObjects: nil],
                            /*@"-texture,*/                     [NSArray arrayWithObjects: nil],
                            /*@"-threshold,*/                   [NSArray arrayWithObjects: nil],
                            /*@"-thumbnail,*/                   [NSArray arrayWithObjects: nil],
                            /*@"-tile,*/                        [NSArray arrayWithObjects: nil],
                            /*@"-tile-offset,*/                 [NSArray arrayWithObjects: nil],
                            /*@"-tint,*/                        [NSArray arrayWithObjects: nil],
                            /*@"-title,*/                       [NSArray arrayWithObjects: nil],
                            /*@"-transform,*/                   [NSArray arrayWithObjects: nil],
                            /*@"-transparent,*/                 [NSArray arrayWithObjects: nil],
                            /*@"-transparent-color,*/           [NSArray arrayWithObjects: nil],
                            /*@"-transpose,*/                   [NSArray arrayWithObjects: nil],
                            /*@"-transverse,*/                  [NSArray arrayWithObjects: nil],
                            /*@"-treedepth,*/                   [NSArray arrayWithObjects: nil],
                            /*@"-trim,*/                        [NSArray arrayWithObjects: nil],
                            /*@"-type,*/                        [NSArray arrayWithObjects: nil],
                            /*@"-undercolor,*/                  [NSArray arrayWithObjects: nil],
                            /*@"-unique-colors,*/               [NSArray arrayWithObjects: nil],
                            /*@"-units,*/                       [NSArray arrayWithObjects: nil],
                            /*@"-unsharp,               i=255 */[NSArray arrayWithObjects: @"Radius", @"Sigma", @"Amout", @"Treshold", nil],
                            /*@"-update,*/                      [NSArray arrayWithObjects: nil],
                            /*@"-verbose,*/                     [NSArray arrayWithObjects: nil],
                            /*@"-version,*/                     [NSArray arrayWithObjects: nil],
                            /*@"-view,*/                        [NSArray arrayWithObjects: nil],
                            /*@"-vignette,*/                    [NSArray arrayWithObjects: nil],
                            /*@"-virtual-pixel,*/               [NSArray arrayWithObjects: nil],
                            /*@"-visual,*/                      [NSArray arrayWithObjects: nil],
                            /*@"-watermark,*/                   [NSArray arrayWithObjects: nil],
                            /*@"-wave,*/                        [NSArray arrayWithObjects: nil],
                            /*@"-weight,*/                      [NSArray arrayWithObjects: nil],
                            /*@"-white-point,*/                 [NSArray arrayWithObjects: nil],
                            /*@"-white-threshold,*/             [NSArray arrayWithObjects: nil],
                            /*@"-window,*/                      [NSArray arrayWithObjects: nil],
                            /*@"-window-group,*/                [NSArray arrayWithObjects: nil],
                            /*@"-write,*/                       [NSArray arrayWithObjects: nil],
                            
                            // index = 0 -> 270, => + 1 = 271
                            /*@"TEXTCLEANER",*/                 [NSArray arrayWithObjects: nil],
                            /*@"2COLORTHRESH,*/                 [NSArray arrayWithObjects: nil],
                            
                            nil];
    
    imageMagickEffectConfigList = effectNames;
    
    return [imageMagickEffectConfigList retain];
}


// Helpers Undo List
// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
-(NSArray*) getUndoNameList {
    
    NSMutableArray* undoList = [[NSMutableArray new] autorelease];
    
    for( int i=0; i < [undoCommandList count]; i++ ) {
        
        int commandIndex = [(NSNumber*)[undoCommandList objectAtIndex:i] intValue];

        if( commandIndex == -1 )
            [undoList addObject:@"Inital"];
        
        else 
            [undoList addObject:[[self getImageMagickEffectNameList] objectAtIndex:commandIndex]];
    }

    return undoList;
}


// Helpers
// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
- (NSString*) applicationDocumentsDirectory {
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    
    NSString* basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    
    return basePath;
}

-(void) applyEffect {
    
    UIImage* workingImage = imageView.image;
    
    NSDateFormatter *formatter;
    NSString        *dateString;
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    
    dateString = [formatter stringFromDate:[NSDate date]];
    
    [formatter release];    
    
    // Do the magick
    NSString* docsFolder = [self applicationDocumentsDirectory];
    NSString* inFile = [docsFolder stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", dateString]];
    NSString* outFile = [docsFolder stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", dateString]];

    [UIImageJPEGRepresentation(workingImage,1.0) writeToFile:inFile atomically:NO];
    
    NSString* command = [[self getImageMagickEffectCommandList] objectAtIndex:actionIndex];

    switch( actionIndex ) {
            
        case 107: command = [NSString stringWithFormat: command, inFile, [[[propertiesValues titleForSegmentAtIndex:0] substringWithRange:NSMakeRange(0,2)] stringByReplacingOccurrencesOfString:@"." withString:@""], 
                                                                         [[[propertiesValues titleForSegmentAtIndex:1] substringWithRange:NSMakeRange(0,2)] stringByReplacingOccurrencesOfString:@"." withString:@""], 
                                                                         outFile]; break;

        case 255: command = [NSString stringWithFormat: command, inFile, [[[propertiesValues titleForSegmentAtIndex:0] substringWithRange:NSMakeRange(0,2)] stringByReplacingOccurrencesOfString:@"." withString:@""],
                                                                         [[[propertiesValues titleForSegmentAtIndex:1] substringWithRange:NSMakeRange(0,2)] stringByReplacingOccurrencesOfString:@"." withString:@""], 
                                                                         [[[propertiesValues titleForSegmentAtIndex:2] substringWithRange:NSMakeRange(0,2)] stringByReplacingOccurrencesOfString:@"." withString:@""], 
                                                                         [[[propertiesValues titleForSegmentAtIndex:3] substringWithRange:NSMakeRange(0,2)] stringByReplacingOccurrencesOfString:@"." withString:@""], 
                                                                         outFile]; break;
            
        case 271: command = [NSString stringWithFormat: command, inFile, outFile]; break;
        case 272: command = [NSString stringWithFormat: command, inFile, outFile]; break;
                
        default:
            break;
    }
    
    [ImageMagick convertImage:nil command:command];

    imageView.image = [UIImage imageWithContentsOfFile:outFile];

    [undoCommandList addObject:[NSNumber numberWithInt:actionIndex]];
    [undoImages addObject:outFile];
    
    activityIndicator.hidden = TRUE;
}

-(void) applyUndo {
    
    currentInHistory = actionIndex;

    imageView.image = [UIImage imageWithContentsOfFile:[undoImages objectAtIndex:actionIndex]];
}


// Implementation
// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
-(void ) initHelper:(UIImage*)inputImage {
    
    image = inputImage;
    
    [UIImageJPEGRepresentation(image,1.0) writeToFile:@"original.jpg" atomically:NO];
    
    undoCommandList = [NSMutableArray new];
    undoImages = [NSMutableArray new];

    [undoCommandList addObject: [NSNumber numberWithInt:-1]];
    [undoImages addObject:@"original.jpg"];    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    imageView.image = image;
    
    [applyCameraButtons addTarget:self action:@selector(applyCameraButtonsTap:) forControlEvents:UIControlEventValueChanged];
    
    actionIndex = -1;
    
    imageMagickEffectNameList = nil;
    imageMagickEffectCommandList = nil;
    imageMagickEffectConfigList = nil;
    [self getImageMagickEffectNameList];
    [self getImageMagickEffectCommandList];
    [self getImageMagickEffectConfigList];
    
    currentInHistory = 0;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    
    [super viewDidUnload];
}

- (void)dealloc {

    [imageMagickEffectNameList release];
    [imageMagickEffectCommandList release];
    [imageMagickEffectConfigList release];
    
    [super dealloc];
}

-(IBAction) slider1ChangedValue:(id)sender {

    UISlider* slider = (UISlider*)sender;

    NSString* valueAsString = [NSString stringWithFormat:@"%.2f",[slider value]];

    [propertiesValues setTitle:valueAsString forSegmentAtIndex:3];
}

-(IBAction) slider2ChangedValue:(id)sender {
    
    UISlider* slider = (UISlider*)sender;
    
    NSString* valueAsString = [NSString stringWithFormat:@"%.2f",[slider value]];
    
    [propertiesValues setTitle:valueAsString forSegmentAtIndex:2];
}

-(IBAction) slider3ChangedValue:(id)sender {
    
    UISlider* slider = (UISlider*)sender;
    
    NSString* valueAsString = [NSString stringWithFormat:@"%.2f",[slider value]];
    
    [propertiesValues setTitle:valueAsString forSegmentAtIndex:1];
}

-(IBAction) slider4ChangedValue:(id)sender {
    
    UISlider* slider = (UISlider*)sender;
    
    NSString* valueAsString = [NSString stringWithFormat:@"%.2f",[slider value]];
    
    [propertiesValues setTitle:valueAsString forSegmentAtIndex:0];
}

-(IBAction) effectsButtonTap:(id)sender {
    
    action = eEffect;
    
	UIActionSheet* effectList = [[UIActionSheet alloc] initWithTitle:nil 
                                                            delegate:self 
                                                   cancelButtonTitle:nil 
                                              destructiveButtonTitle:nil 
                                                   otherButtonTitles:nil];
    
    NSArray* effectNames = [self getImageMagickEffectNameList];
    
    for( int i=0; i<[effectNames count]; i++ ) {
        
        NSString* buttonName = [effectNames objectAtIndex:i];
        [effectList addButtonWithTitle:buttonName];
    }
    
    [effectList addButtonWithTitle:@"Cancel"];
    effectList.cancelButtonIndex = effectList.numberOfButtons - 1;
    effectList.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [effectList showInView:self.view];
    [effectList release];    
}

-(IBAction) historyButtonTap:(id)sender {
    
    action = eHistory;
    
	UIActionSheet* undoList = [[UIActionSheet alloc] initWithTitle:nil 
                                                          delegate:self 
                                                 cancelButtonTitle:nil
                                            destructiveButtonTitle:nil 
                                                 otherButtonTitles:nil];
    
    NSArray* undoNames = [self getUndoNameList];
    
    for( int i=0; i<[undoNames count]; i++ ) {
        
        NSString* buttonName = [undoNames objectAtIndex:i];
        [undoList addButtonWithTitle:buttonName];
    }
    
    [undoList addButtonWithTitle:@"Cancel"];
    undoList.cancelButtonIndex = undoList.numberOfButtons - 1;
    undoList.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [undoList showInView:self.view];
    [undoList release];    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if( action == 0 ) {
        
        if( buttonIndex < [[self getImageMagickEffectNameList] count] ) {
        
            [propertiesLabels setTitle:@"-" forSegmentAtIndex:0];
            [propertiesLabels setTitle:@"-" forSegmentAtIndex:1];
            [propertiesLabels setTitle:@"-" forSegmentAtIndex:2];
            [propertiesLabels setTitle:@"-" forSegmentAtIndex:3];

            [propertiesValues setTitle:@"-" forSegmentAtIndex:0];
            [propertiesValues setTitle:@"-" forSegmentAtIndex:1];
            [propertiesValues setTitle:@"-" forSegmentAtIndex:2];
            [propertiesValues setTitle:@"-" forSegmentAtIndex:3];
            
            propertyValueSlider1.hidden = TRUE;
            propertyValueSlider2.hidden = TRUE;
            propertyValueSlider3.hidden = TRUE;
            propertyValueSlider4.hidden = TRUE;
            
            actionIndex = buttonIndex;
            effectName.text = [[self getImageMagickEffectNameList] objectAtIndex:buttonIndex];
            
            NSArray* config = [[self getImageMagickEffectConfigList] objectAtIndex:buttonIndex];
            for( int i=0; i < [config count]; i++ ) {

                [propertiesLabels setTitle: [config objectAtIndex:i] forSegmentAtIndex:i];
            }
            
            propertyValueSlider1.hidden = !([config count] > 0);
            propertyValueSlider2.hidden = !([config count] > 1);
            propertyValueSlider3.hidden = !([config count] > 2);
            propertyValueSlider4.hidden = !([config count] > 3);
        }
    }

    else {
        
        if( buttonIndex < [[self getUndoNameList] count] ) {

            actionIndex = buttonIndex;
            [self applyUndo];
        }
    } 
}

-(void) applyCameraButtonsTap:(id)sender {
    
    if( applyCameraButtons.selectedSegmentIndex == 0 ) { // Apply

        applyCameraButtons.selectedSegmentIndex = -1;

        if( actionIndex == -1 )
            return;

        activityIndicator.hidden = FALSE;

        [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(applyEffect) userInfo:nil repeats:NO];
    }
    
    else if( applyCameraButtons.selectedSegmentIndex == 1 ) { // Camera
        
        [self.delegate imageMagickWorkspaceDidFinished:self];
    }
}

-(IBAction) prevHistoryButtonTap:(id)sender {
    
    currentInHistory = currentInHistory - 1;
    
    if( currentInHistory < 0 )
        currentInHistory = 0;
    
    imageView.image = [UIImage imageWithContentsOfFile:[undoImages objectAtIndex:currentInHistory]];
}

-(IBAction) nextHistoryButtonTap:(id)sender {
    
    currentInHistory = currentInHistory + 1;
    
    if( currentInHistory >= [undoImages count] )
        currentInHistory = currentInHistory - 1;

    imageView.image = [UIImage imageWithContentsOfFile:[undoImages objectAtIndex:currentInHistory]];
}


@end
