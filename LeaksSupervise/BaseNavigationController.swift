

import UIKit

private let onceToken = "BaseNavigationController Method Swizzling"

class BaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

extension BaseNavigationController {
    // 系统的initialize已经禁用，我们自己写一个，在AppDelegate的didFinishLaunchingWithOptions调用
    public class func initializeMethod() {
        if self != BaseNavigationController.self {
            return
        }
        DispatchQueue.once(token: onceToken) {
            let originalSelector = #selector(popViewController(animated:))
            let swizzlingSelector = #selector(swizzling_popViewController(animated:))
            // 封装好方法交换
            MethodSwizzlingTool.swizzling(cls: self, originalSelector: originalSelector, swizzledSelector: swizzlingSelector)
        }
        
    }
    
    @objc func swizzling_popViewController(animated: Bool) -> UIViewController? {
        // 插入动态关联属性
        let popVC = self.swizzling_popViewController(animated: animated)
        if let vc = popVC {
            // 给要pop出去的VC更改关联属性状态，true表示准备释放这个VC
            objc_setAssociatedObject(vc, &AssociatedKeys.ViewContorllerWillDeinit, true, .OBJC_ASSOCIATION_ASSIGN)
        }
        return popVC
    }
}
