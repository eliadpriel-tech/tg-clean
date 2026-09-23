#import <UIKit/UIKit.h>
#import <objc/runtime.h>

__attribute__((constructor)) static void initTweak(void) {
    Class chatListClass = objc_getClass("TelegramUI.ChatListController");
    if (!chatListClass) {
        chatListClass = objc_getClass("ChatListController");
    }
    
    if (chatListClass) {
        Method origMethod = class_getInstanceMethod(chatListClass, sel_registerName("viewWillAppear:"));
        if (origMethod) {
            void (*origImpl)(id, SEL, BOOL) = (void (*)(id, SEL, BOOL))method_getImplementation(origMethod);
            
            id newImpl = ^(id self, BOOL animated) {
                origImpl(self, sel_registerName("viewWillAppear:"), animated);
                
                UIViewController *vc = (UIViewController *)self;
                if ([vc respondsToSelector:@selector(navigationItem)]) {
                    vc.navigationItem.searchController = nil;
                    vc.navigationItem.hidesSearchBarWhenScrolling = YES;
                }
            };
            
            method_setImplementation(origMethod, imp_implementationWithBlock(newImpl));
        }
    }
}
