//
//  DealDetailCell.swift
//  Project
//
//  Created by JohnConnor on 2019/10/1.
//  Copyright © 2019 HHCSZGD. All rights reserved.
//

import UIKit

class DealDetailCell: UITableViewCell {
    @IBOutlet weak var roundBgview: UIView!
    
    @IBOutlet weak var personName: UILabel!
    @IBOutlet weak var carNum: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var tips: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.roundBgview.layer.cornerRadius = 8
        self.roundBgview.layer.masksToBounds = true
        self.contentView.backgroundColor = mainBgColor
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
