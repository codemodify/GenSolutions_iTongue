
#import <UIKit/UIKit.h>

@protocol ImageMagickWorkspaceDelegate;
@interface ImageMagickWorkspaceViewController : UIViewController<UIActionSheetDelegate> {

    // house keeping
    enum { eEffect, eHistory } action;
    int actionIndex;
    NSMutableArray* undoCommandList;
    NSMutableArray* undoImages;
    NSArray* imageMagickEffectNameList;
    NSArray* imageMagickEffectCommandList;
    NSArray* imageMagickEffectConfigList;
    int currentInHistory;    
    
    // publics
    id <ImageMagickWorkspaceDelegate> delegate;
    
    UIImage* image;

    IBOutlet UIImageView* imageView;
    
    IBOutlet UIActivityIndicatorView* activityIndicator;
    
    IBOutlet UISegmentedControl* propertiesLabels;
    IBOutlet UISegmentedControl* propertiesValues;
    IBOutlet UISegmentedControl* applyCameraButtons;

    IBOutlet UISlider* propertyValueSlider1;
    IBOutlet UISlider* propertyValueSlider2;
    IBOutlet UISlider* propertyValueSlider3;
    IBOutlet UISlider* propertyValueSlider4;
    
    IBOutlet UILabel* effectName;
}

-(void) initHelper:(UIImage*)inputImage;

@property (nonatomic, assign) id <ImageMagickWorkspaceDelegate> delegate;

@property (nonatomic, retain) UIImage* image;

@property (nonatomic, assign) UIImageView* imageView;

@property (nonatomic, assign) UIActivityIndicatorView* activityIndicator;

@property (nonatomic, assign) UISegmentedControl* propertiesLabels;
@property (nonatomic, assign) UISegmentedControl* propertiesValues;
@property (nonatomic, assign) UISegmentedControl* applyCameraButtons;

@property (nonatomic, assign) UISlider* propertyValueSlider1;
@property (nonatomic, assign) UISlider* propertyValueSlider2;
@property (nonatomic, assign) UISlider* propertyValueSlider3;
@property (nonatomic, assign) UISlider* propertyValueSlider4;

@property (nonatomic, assign) UILabel* effectName;


-(IBAction) slider1ChangedValue:(id)sender;
-(IBAction) slider2ChangedValue:(id)sender;
-(IBAction) slider3ChangedValue:(id)sender;
-(IBAction) slider4ChangedValue:(id)sender;

-(IBAction) effectsButtonTap:(id)sender;
-(IBAction) historyButtonTap:(id)sender;
-(void) applyCameraButtonsTap:(id)sender;
-(IBAction) prevHistoryButtonTap:(id)sender;
-(IBAction) nextHistoryButtonTap:(id)sender;

@end


// Delegates
// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
@protocol ImageMagickWorkspaceDelegate

-(void) imageMagickWorkspaceDidFinished:(ImageMagickWorkspaceViewController*)sender;

@end
