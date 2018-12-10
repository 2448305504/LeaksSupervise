//
//  FirstViewController.swift
//  LeaksSupervise
//
//  Created by 林文俊 on 2018/12/10.
//  Copyright © 2018 林文俊. All rights reserved.
//

import UIKit

class FirstViewController: BaseViewController {
    
    var str = "aaa"
    
    var callBack: (()->())?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        // 实现一个有循环引用问题的block
        self.callBack = {
            DispatchQueue.main.asyncAfter(deadline: .now()+2.0, execute: {
                print(self.str)
            })
        }
        callBack?()
    }
 
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        navigationController?.popViewController(animated: true)
//        dismiss(animated: true, completion: nil)
    }
    
    deinit {
        // deinit不会执行，因为block造成循环引用了
        print("FirstViewController deinit")
    }
}
