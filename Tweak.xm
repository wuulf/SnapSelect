#import <UIKit/UIKit.h>
#import "substrate.h" // Needed for MSHookIvar to work

@interface AVCameraViewController: UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
	UIView *_cameraOverlay; // Declares the UIView we are going to hook
	// This is known because I dumped the SnapChat app headers and found this.
}
@end

%hook AVCameraViewController

- (void)viewDidLoad {
	%orig; // Call the original method implementations (VERY IMPORTANT)
	
	// Hook the view we want to add a button to.
	UIView *cameraOverlay = MSHookIvar<UIView *>(self,"_cameraOverlay");
	
	// Get the image for the button
	UIImage *btnImage = [UIImage imageWithContentsOfFile:@"/Library/Application Support/SnapSelect/snapselect.png"];
	int btnHeight = btnImage.size.height; // Get the dimensions of the image to make the button the correct size.
	int btnWidth = btnImage.size.width;
	
	// Create the button
	UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
	btn.frame = CGRectMake(60.0, 435.0 ,btnWidth, btnHeight);
	[btn setImage:btnImage forState:UIControlStateNormal];
	[btn addTarget:self action:@selector(showPicker) forControlEvents:UIControlEventTouchDown];
	[cameraOverlay addSubview:btn]; // Add the button to the view that was hooked earlier
	
}

%new 
-(void)showPicker {
	// Create an UIImagePickerController
	UIImagePickerController *imagePickController=[[UIImagePickerController alloc]init];
    imagePickController.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickController.delegate= self;
    imagePickController.allowsEditing=NO;
    [self presentModalViewController:imagePickController animated:YES];
    [imagePickController release];
	
}
// See the readme as to why there isn't more code needed than this.

%end
