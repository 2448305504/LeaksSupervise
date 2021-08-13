

import UIKit

class MethodSwizzlingTool: NSObject {

    class func swizzling(cls: AnyClass, originalSelector: Selector, swizzledSelector: Selector) {
        let originalMethod: Method? = class_getInstanceMethod(cls, originalSelector)
        let swizzledMethod: Method? = class_getInstanceMethod(cls, swizzledSelector)
        
        let didAddMethod: Bool = class_addMethod(cls, originalSelector, method_getImplementation(swizzledMethod!), method_getTypeEncoding(swizzledMethod!))
        
        if didAddMethod {
            class_replaceMethod(cls, swizzledSelector, method_getImplementation(originalMethod!), method_getTypeEncoding(originalMethod!))
        } else {
            method_exchangeImplementations(originalMethod!, swizzledMethod!)
        }

    }
    
}
