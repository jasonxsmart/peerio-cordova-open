#import "Open.h"

@interface SimpleAlert : NSObject<UIAlertViewDelegate>

typedef void (^AlertViewCompletionBlock)(NSInteger buttonIndex);
@property (strong,nonatomic) AlertViewCompletionBlock callback;

+ (void)showAlertView:(UIAlertView *)alertView withCallback:(AlertViewCompletionBlock)callback;

@end


@implementation SimpleAlert
@synthesize callback;

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    callback(buttonIndex);
}

+ (void)showAlertView:(UIAlertView *)alertView
         withCallback:(AlertViewCompletionBlock)callback {
    __block SimpleAlert *delegate = [[SimpleAlert alloc] init];
    alertView.delegate = delegate;
    delegate.callback = ^(NSInteger buttonIndex) {
        callback(buttonIndex);
        alertView.delegate = nil;
        delegate = nil;
    };
    [alertView show];
}

@end

@implementation Open

/**
 *  open
 *
 *  @param command An array of arguments passed from javascript
 */
- (void)open:(CDVInvokedUrlCommand *)command {

  // Check command.arguments here.
  [self.commandDelegate runInBackground:^{
    CDVPluginResult* commandResult = nil;
    NSString *path = [command.arguments objectAtIndex:0];

    if (path != nil && [path length] > 0) {

      NSURL *url = [NSURL URLWithString:path];
      NSError *err;

      if (url.isFileURL &&
          [url checkResourceIsReachableAndReturnError:&err] == YES) {

        self.fileUrl = url;

        QLPreviewController *previewCtrl = [[QLPreviewController alloc] init];
        previewCtrl.delegate = self;
        previewCtrl.dataSource = self;
          
        [previewCtrl.navigationItem setRightBarButtonItem:nil];
          
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.viewController presentViewController:previewCtrl animated:YES completion:nil];
            });

        NSLog(@"cordova.disusered.open - Success!");
        commandResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                          messageAsString:@""];

      } else {
        NSLog(@"cordova.disusered.open - Invalid file URL");
        commandResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
      }
    } else {
      NSLog(@"cordova.disusered.open - Missing URL argument");
      commandResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    }

    [self.commandDelegate sendPluginResult:commandResult
                                callbackId:command.callbackId];
  }];
}

#pragma - QLPreviewControllerDataSource Protocol

- (NSInteger)numberOfPreviewItemsInPreviewController:
                 (QLPreviewController *)controller {
  return 1;
}

- (id<QLPreviewItem>)previewController:(QLPreviewController *)controller
                    previewItemAtIndex:(NSInteger)index {
  return self;
}

#pragma - QLPreviewItem Protocol

- (NSURL *)previewItemURL {
  return self.fileUrl;
}

	
#pragma - QLPreviewControllerDelegate Protocol
/*
 * @abstract Invoked by the preview controller before trying to open an URL tapped in the preview.
 * @result Returns NO to prevent the preview controller from calling -[UIApplication openURL:] on url.
 * @discussion If not implemented, defaults is YES.
 */
- (BOOL)previewController:(QLPreviewController *)controller
            shouldOpenURL:(NSURL *)url
           forPreviewItem:(id<QLPreviewItem>)item {
  UIAlertView *alert = [[UIAlertView alloc]
      initWithTitle:[NSString stringWithFormat:@"Are you sure you want to open the link?"]
      message:[url absoluteString]
      delegate:nil
      cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
  [SimpleAlert showAlertView:alert withCallback:^(NSInteger buttonIndex) {
    // if user pressed yes
    if(buttonIndex == 1) {
      [[UIApplication sharedApplication] openURL:url];
    }
}];
  return NO;
}

@end

