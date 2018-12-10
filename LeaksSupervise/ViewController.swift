//
//  ViewController.swift
//  LeaksSupervise
//
//  Created by 林文俊 on 2018/12/6.
//  Copyright © 2018 林文俊. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        navigationController?.pushViewController(FirstViewController(), animated: true)
//        present(FirstViewController(), animated: true, completion: nil)
    }
    
}

