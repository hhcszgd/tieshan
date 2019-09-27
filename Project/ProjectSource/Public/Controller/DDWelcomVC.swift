//
//  DDWelcomVC.swift
//  Project
//
//  Created by WY on 2019/9/16.
//  Copyright © 2019年 HHCSZGD. All rights reserved.
//

import UIKit

class DDWelcomVC: DDNormalVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .green
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let loginVC = DDLoginVC()
//        self.present(loginVC, animated: true , completion: nil)
//         let a = DDAccount.share()
//         a.token = "as;dofopasid"
//        a.save()
//        DDAccount.share().token = "ddd"
//        DDAccount.share().save()
        self.navigationController?.pushViewController(loginVC, animated: true )
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+4) {
//
//            NotificationCenter.default.post(name: NSNotification.Name.init("loginSuccess"), object: nil )
//        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true )
        self.navigationController?.setNavigationBarHidden(true , animated: true )
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
