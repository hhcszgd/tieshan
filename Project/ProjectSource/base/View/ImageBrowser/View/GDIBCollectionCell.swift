//
//  GDIBCollectionCell.swift
//  zjlao
//
//  Created by WY on 04/05/2017.
//  Copyright © 2017 com.16lao.zjlao. All rights reserved.
//

import UIKit

class GDIBCollectionCell: UICollectionViewCell {
    let scrollView  = GDIBScrollView()
    
    var photo : GDIBPhoto?{
        willSet{
                scrollView.photo = newValue
        }
        didSet{}
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame )
        self.configScrollView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func prepareForReuse() {
        scrollView.prepareForReuse()
    }
}


extension GDIBCollectionCell {
    func configScrollView ()  {
        self.addSubview(scrollView)
        scrollView.frame = self.bounds
    }
}
