//
//  BaseViewController.swift
//  LeaksSupervise
//
//  Created by 林文俊 on 2018/12/10.
//  Copyright © 2018 林文俊. All rights reserved.
//

import UIKit

private let onceToken = "BaseViewController Method Swizzling"

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension BaseViewController {
    
    public class func initializeMethod() {
        if self != BaseViewController.self { return }
        // DispatchQueue函数保证代码只被执行一次，防止又被交换回去导致得不到想要的效果
        DispatchQueue.once(token: onceToken) {
            // 交换viewWillAppear
            let originalSelector = #selector(BaseViewController.viewWillAppear(_:))
            let swizzledSelector = #selector(BaseViewController.swizzled_viewWillAppear(animated:))
            MethodSwizzlingTool.swizzling(cls: self, originalSelector: originalSelector, swizzledSelector: swizzledSelector)
            
            // 交换viewWillDisappear
            let originalSelector1 = #selector(BaseViewController.viewWillDisappear(_:))
            let swizzledSelector1 = #selector(BaseViewController.swizzled_viewWillDisappear(animated:))
            MethodSwizzlingTool.swizzling(cls: self, originalSelector: originalSelector1, swizzledSelector: swizzledSelector1)
            
            // 交换dissmiss
            let originalSelector2 = #selector(BaseViewController.dismiss(animated:completion:))
            let swizzledSelector2 = #selector(BaseViewController.swizzlied_dismiss(animated:completion:))
            MethodSwizzlingTool.swizzling(cls: self, originalSelector: originalSelector2, swizzledSelector: swizzledSelector2)
            
        }
    }
    
    
    @objc func swizzled_viewWillAppear(animated: Bool) {
        self.swizzled_viewWillAppear(animated: animated)
        // 更改关联属性状态设置false，表示view才将要显示了
        objc_setAssociatedObject(self, &AssociatedKeys.ViewContorllerWillDeinit, false, .OBJC_ASSOCIATION_ASSIGN)
    }

    @objc func swizzled_viewWillDisappear(animated: Bool) {
        self.swizzled_viewWillDisappear(animated: animated)
        // 得到关联属性的状态，如果是true，表示视图要消失即将回收VC的资源，这个时候才是关键！！给self发送对象看它是否响应，若响应了，说明没有释放内存
        guard let state = objc_getAssociatedObject(self, &AssociatedKeys.ViewContorllerWillDeinit) as? Bool else { return }
        if state {
            // 核心在这！
            willDeinit()
        }
    }
    
    @objc func swizzlied_dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        self.swizzlied_dismiss(animated: flag, completion: completion)
        // 给要dimiss出去的VC更改关联属性状态，true表示准备释放这个VC
        objc_setAssociatedObject(self, &AssociatedKeys.ViewContorllerWillDeinit, true, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
    }
    
    private func willDeinit() {
        /* 核心思想：
            1.给nil对象发送消息是不会崩溃的
            2.查看pop出去的那个控制器是否还有内存，如果是，则没有被释放
         */
        
        // ps:这里的延时是因为popViewController执行还是需要一定的时间
        DispatchQueue.main.asyncAfter(deadline: .now()+2.0) { [weak self] in
            // 如果self被释放了，给nil发送消息是不会响应的
            self?.isNotDeinit()
        }
    }
    
    private func isNotDeinit() {
        // 打印VC内存
        print(String.init(format: "%p is not deinit", self))
    }
}
