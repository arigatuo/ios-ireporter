//
//  PhotoScreen.m
//  iReporter
//
//  Created by Marin Todorov on 09/02/2012.
//  Copyright (c) 2012 Marin Todorov. All rights reserved.
//

#import "PhotoScreen.h"
#import "API.h"
#import "UIImage+REsize.h"
#import "UIAlertView+error.h"

@interface PhotoScreen(private)
-(void)takePhoto;
-(void)effects;
-(void)uploadPhoto;
-(void)logout;
@end

@implementation PhotoScreen

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Custom initialization
    self.navigationItem.rightBarButtonItem = btnAction;
    self.navigationItem.title = @"Post photo";
    
    if(![[API sharedInstance] isAuthorized]){
        [self performSegueWithIdentifier:@"ShowLogin" sender:nil];
    }
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - menu

-(IBAction)btnActionTapped:(id)sender
{
    [fldTitle resignFirstResponder];
    [ [[UIActionSheet alloc] initWithTitle:nil
                                delegate:self
                   cancelButtonTitle:@"Close"
                  destructiveButtonTitle:nil
                       otherButtonTitles:@"Take Photo", @"Effects!",@"Post Photos", @"Logout",nil]
                          showInView:self.view];
}

-(void)takePhoto{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
#if TARGET_IPHONE_SIMULATOR
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
#else
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
#endif
    imagePickerController.editing = YES;
    imagePickerController.delegate = (id)self;
    
    [self presentModalViewController:imagePickerController animated:YES];
}

-(void)effects{
    CIImage *beginImage = [CIImage imageWithData:UIImagePNGRepresentation(photo.image)];
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CIFilter *filter = [CIFilter filterWithName:@"CISepiaTone"
                                  keysAndValues:kCIInputImageKey,beginImage,
                        @"inputIntensity", [NSNumber numberWithFloat:0.8], nil];
    CIImage *outputImage = [filter outputImage];
    
    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
    photo.image = [UIImage imageWithCGImage:cgimg];
    
    CGImageRelease(cgimg);
}

-(void)uploadPhoto{
    [[API sharedInstance] commandWithParams:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"upload", @"command",
                                             UIImageJPEGRepresentation(photo.image,70), @"file",
                                             fldTitle.text, @"title",
                                             nil] onCompletion:^(NSDictionary *json){
        if(![json objectForKey:@"error"]){
            [[[UIAlertView alloc]initWithTitle:@"Success"
                                       message:@"Your PHoto is uploaded"
                                      delegate:nil
                             cancelButtonTitle:@"ya"
                             otherButtonTitles:nil] show];
        }else{
            NSString* errorMsg = [json objectForKey:@"error"];
            [UIAlertView error:errorMsg];
            
            if([@"Authorization required" compare:errorMsg] == NSOrderedSame){
                [self performSegueWithIdentifier:@"ShowLogin" sender:nil];
            }
        }
    }];
}

-(void)logout{
    [[API sharedInstance] commandWithParams:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"logout", @"command", nil]
                               onCompletion:^(NSDictionary *json){
                                   [API sharedInstance].user = nil;
                                   [self performSegueWithIdentifier:@"ShowLogin" sender:nil];
                               }];
}

#pragma mark - Image Picker delegate methods
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImage *scaledImage = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:CGSizeMake(photo.frame.size.width, photo.frame.size.height)interpolationQuality:kCGInterpolationHigh];
    UIImage *croppedImage = [scaledImage croppedImage:CGRectMake((scaledImage.size.width - photo.frame.size.width)/2, (scaledImage.size.height-photo.frame.size.height)/2, photo.frame.size.width, photo.frame.size.height)];
    photo.image = croppedImage;
    [picker dismissModalViewControllerAnimated:NO];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissModalViewControllerAnimated:NO];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch(buttonIndex){
        case 0:
            [self takePhoto];
            break;
        case 1:
            [self effects];
            break;
        case 2:
            [self uploadPhoto];
            break;
        case 3:
            [self logout];
            break;
    }
}

@end
