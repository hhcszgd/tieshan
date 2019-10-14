//
//  DealDetailHeader.swift
//  Project
//
//  Created by JohnConnor on 2019/10/1.
//  Copyright © 2019 HHCSZGD. All rights reserved.
//

import UIKit

class DealDetailHeader: UIView {
    /// 1
    @IBOutlet weak var number: UILabel!
    /// 2
    @IBOutlet weak var carType: UILabel!
    /// 3
    @IBOutlet weak var carNumber: UILabel!
    /// 4
    @IBOutlet weak var engineNumber: UILabel!
    /// 5
    @IBOutlet weak var arrivedTime: UILabel!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
