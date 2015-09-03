#import "AppsFlyerPlugin.h"

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
   return self;
}

- (void) initializeWithManifest:(NSDictionary *)manifest
                    appDelegate:(TeaLeafAppDelegate *)appDelegate {
  @try {
    NSDictionary *ios = [manifest valueForKey:@"ios"];
    NSString * const APP_ID = [ios valueForKey:@"appleID"];
    NSString * const APPS_FLYER_DEV_KEY = [ios valueForKey:@"appsFlyerDevKey"];

    if (APPS_FLYER_DEV_KEY) {
      [AppsFlyerTracker sharedTracker].appleAppID = APP_ID;
      [AppsFlyerTracker sharedTracker].appsFlyerDevKey = APPS_FLYER_DEV_KEY;

      // FOR DEBUG ONLY: TURN THIS ON TO SEE DEBUG MESSAGES
      // [AppsFlyerTracker sharedTracker].isDebug = YES;

      // FOR DEBUG ONLY: USE SANDBOX MODE TO TRACK PURCHASES
      // [AppsFlyerTracker sharedTracker].useReceiptValidationSandbox = YES;

    }
  }
  @catch (NSException *exception) {
    NSLOG(@"{AppsFlyer} Exception while initializing: %@", exception);
  }
}

- (void) setUserId:(NSDictionary *)jsonObject {
  @try {
    if([jsonObject objectForKey:@"uid"]) {
      NSString *uid = [NSString stringWithFormat:@"%@",[jsonObject valueForKey:@"uid"]];
      [AppsFlyerTracker sharedTracker].customerUserID = uid;
      [[AppsFlyerTracker sharedTracker] trackAppLaunch];
      [AppsFlyerTracker sharedTracker].delegate = self;
    }
  }
  @catch (NSException *exception) {
    NSLOG(@"{AppsFlyer} Exception while setting user id: %@", exception);
  }
}


- (void) trackPurchase:(NSDictionary *)jsonObject {
  [[AppsFlyerTracker sharedTracker] trackEvent: AFEventPurchase withValues:@{
                           AFEventParamRevenue: [NSString stringWithFormat:@"%@",[jsonObject valueForKey:@"revenue"]],
                         AFEventParamContentId: [NSString stringWithFormat:@"%@",[jsonObject valueForKey:@"productId"]],
                          AFEventParamCurrency: [NSString stringWithFormat:@"%@",[jsonObject valueForKey:@"currency"]],
                         AFEventParamReceiptId: [NSString stringWithFormat:@"%@",[jsonObject valueForKey:@"receipt"]] }];
}

- (void) trackEventWithValue:(NSDictionary *)jsonObject {
  [[AppsFlyerTracker sharedTracker]trackEvent:[NSString stringWithFormat:@"%@",[jsonObject valueForKey:@"event_name"]]
                                    withValue:[NSString stringWithFormat:@"%@",[jsonObject valueForKey:@"value"]]];
}

- (void) handleOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication {
  [[AppsFlyerTracker sharedTracker] handleOpenURL:url sourceApplication:sourceApplication withAnnotaion:nil];
}

@end
