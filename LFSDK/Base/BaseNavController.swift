//
//  BaseNavController.swift
//  ymsports
//
//  Created by wood on 21/1/21.
//

import UIKit

open class BaseNavController: UINavigationController {
    override open func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.tintColor = UIKitSettings.primaryColor
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
