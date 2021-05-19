//
//  homeViewController.swift
//  TableTech
//
//  Created by Apple on 07/04/21.
//

import UIKit
import SceneKit.ModelIO


class homeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}


extension homeViewController {
    
    @IBAction func clickOnOpenTblBBtn(_ sender: UIButton)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "modelsKitViewController") as! modelsKitViewController
        self.navigationController?.pushViewController(vc, animated: true)

    }
}
