#import <UIKit/UIKit.h>


static NSString *themePath;

extern "C" UIImage* _UIImageWithName(NSString *name);

static UIImage* (*original__UIImageWithName)(NSString *name);




UIImage* replaced__UIImageWithName(NSString *name) {
  return [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@%@",themePath,name]] ?: original__UIImageWithName(name);
}
 



%hook UIImage

+(UIImage*)kitImageNamed:(NSString*)name{
	return [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@%@",themePath,name]] ?: %orig;
}

%end


%ctor {
	if (![[NSDictionary dictionaryWithContentsOfFile:@"/User/Library/Preferences/com.bensge.uiimages.plist"] objectForKey:@"themePath"]){
		[[[[UIAlertView alloc] initWithTitle:@"UIImages" message:@"Couldn't load 'themePath' from com.bensge.uiimages" delegate:nil cancelButtonTitle:@"Ok i'll fix it" otherButtonTitles:nil] autorelease] show];
		return;
	}
	themePath = [[NSDictionary dictionaryWithContentsOfFile:@"/User/Library/Preferences/com.bensge.uiimages.plist"] objectForKey:@"themePath"];
	MSHookFunction(_UIImageWithName, replaced__UIImageWithName, &original__UIImageWithName);
}
/* How to Hook with Logos
Hooks are written with syntax similar to that of an Objective-C @implementation.
You don't need to #include <substrate.h>, it will be done automatically, as will
the generation of a class list and an automatic constructor.

%hook ClassName

// Hooking a class method
+ (id)sharedInstance {
	return %orig;
}

// Hooking an instance method with an argument.
- (void)messageName:(int)argument {
	%log; // Write a message about this call, including its class, name and arguments, to the system log.

	%orig; // Call through to the original function with its original arguments.
	%orig(nil); // Call through to the original function with a custom argument.

	// If you use %orig(), you MUST supply all arguments (except for self and _cmd, the automatically generated ones.)
}

// Hooking an instance method with no arguments.
- (id)noArguments {
	%log;
	id awesome = %orig;
	[awesome doSomethingElse];

	return awesome;
}

// Always make sure you clean up after yourself; Not doing so could have grave consequences!
%end
*/
