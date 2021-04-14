#import "HlDesPlugin.h"
#if __has_include(<hl_des/hl_des-Swift.h>)
#import <hl_des/hl_des-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "hl_des-Swift.h"
#endif

@implementation HlDesPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftHlDesPlugin registerWithRegistrar:registrar];
}
@end
