//
//  DDAboutUsVC.swift
//  Project
//
//  Created by WY on 2019/9/22.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit

class DDAboutUsVC: DDNormalVC {

    @IBOutlet weak var versionLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let currentAppVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.2.1"
        versionLabel.text = "Version  \(currentAppVersion)"
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
