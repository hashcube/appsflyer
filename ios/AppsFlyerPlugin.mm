#import "AppsFlyerPlugin.h"

@interface AppsFlyerPlugin()

@property (nonatomic, assign) BOOL initDone;
@property (nonatomic, assign) BOOL becameActive;

@end

@implementation AppsFlyerPlugin

// The plugin must call super dealloc.
- (void) dealloc {
  [super dealloc];
}

// The plugin must call super init.
- (id) init {
  self = [super init];
  if (!self) {
    return nil;
  }

  self.initDone = NO;
  self.becameActive = NO;
  return self;
}

- (void) initializeWithManifest:(NSDictionary *)manifest appDelegate:(TeaLeafAppDelegate *)appDelegate {
  @try {
    NSDictionary *ios = [manifest valueForKey:@"ios"];
    NSString * const APP_ID = [ios valueForKey:@"appleID"];
    NSString * const APPS_FLYER_DEV_KEY = [ios valueForKey:@"appsFlyerDevKey"];

    if (APPS_FLYER_DEV_KEY) {
      [AppsFlyerTracker sharedTracker].appleAppID = APP_ID;
      [AppsFlyerTracker sharedTracker].appsFlyerDevKey = APPS_FLYER_DEV_KEY;

      // FOR DEBUG ONLY: TURN THIS ON TO SEE DEBUG MESSAGES
      //[AppsFlyerTracker sharedTracker].isDebug = YES;

      // FOR DEBUG ONLY: USE SANDBOX MODE TO TRACK PURCHASES
      //[AppsFlyerTracker sharedTracker].useReceiptValidationSandbox = YES;

      //checking if didBecameActive was called before this
      if(self.becameActive){
        [[AppsFlyerTracker sharedTracker] trackAppLaunch];
        [AppsFlyerTracker sharedTracker].delegate = self;
      }
      self.initDone = YES; 
    }
  }
  @catch (NSException *exception) {
    NSLog(@"{AppsFlyer} Exception while initializing: %@", exception);
  }
}

- (void) setUserId:(NSDictionary *)jsonObject {
  @try {
    if([jsonObject objectForKey:@"uid"]) {
      NSString *uid = [NSString stringWithFormat:@"%@",[jsonObject valueForKey:@"uid"]];
      [AppsFlyerTracker sharedTracker].customerUserID = uid;
    }
  }
  @catch (NSException *exception) {
    NSLog(@"{AppsFlyer} Exception while setting user id: %@", exception);
  }
}


- (void) trackPurchase:(NSDictionary *)jsonObject {
//  NSString *receiptString = [jsonObject valueForKey:@"receipt"];
//  NSData *data = [receiptString dataUsingEncoding:NSUTF8StringEncoding];

  [[AppsFlyerTracker sharedTracker]validateAndTrackInAppPurchase:@"in‐app‐purchase‐success"
                     eventNameIfFailed:@"in‐app‐purchase‐failed"
                             withValue:[NSString stringWithFormat:@"%@",[jsonObject valueForKey:@"revenue"]]
                           withProduct:[NSString stringWithFormat:@"%@",[jsonObject valueForKey:@"productId"]]
                                price:[[NSDecimalNumber alloc ]initWithString:[NSString stringWithFormat:@"%@",[jsonObject valueForKey:@"revenue"]]]
                                 currency:[NSString stringWithFormat:@"%@",[jsonObject valueForKey:@"currency"]]
                               success:^(NSDictionary *response){
                                 NSLog(@"{AppsFlyer} track purchase success resonse: %@", response);
                               }
                               failure:^(NSError *error, id response){
                                 NSLog(@"{AppsFlyer} track purchase failure response: %@", response);
                               }];
}

- (void) trackEvent:(NSDictionary *)jsonObject {
  [[AppsFlyerTracker sharedTracker]trackEvent:[NSString stringWithFormat:@"%@",[jsonObject valueForKey:@"event_name"]]
                                   withValues:(NSDictionary *)[jsonObject valueForKey:@"values"]];
}

- (void) applicationDidBecomeActive:(UIApplication *)app {
  if(self.initDone) {
    [[AppsFlyerTracker sharedTracker] trackAppLaunch];
    [AppsFlyerTracker sharedTracker].delegate = self;
  }
  self.becameActive = YES;
}

- (void) handleOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication {
  [[AppsFlyerTracker sharedTracker] handleOpenURL:url sourceApplication:sourceApplication withAnnotaion:nil];
}

#pragma AppsFlyerTrackerDelegate methods
- (void) onConversionDataReceived:(NSDictionary*) installData{
    id status = [installData objectForKey:@"af_status"];
    if([status isEqualToString:@"Non-organic"]) {
        id sourceID = [installData objectForKey:@"media_source"];
        id campaign = [installData objectForKey:@"campaign"];
        NSLog(@"This is a none organic install.");
        NSLog(@"Media source: %@",sourceID);
        NSLog(@"Campaign: %@",campaign);
    } else if([status isEqualToString:@"Organic"]) {
        NSLog(@"This is an organic install.");
    }
}

- (void) onConversionDataRequestFailure:(NSError *)error{
    NSLog(@"Failed to get data from AppsFlyer's server: %@",[error localizedDescription]);
}

@end
