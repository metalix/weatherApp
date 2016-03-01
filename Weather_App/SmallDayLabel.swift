//
//  SmallDayLabel.swift
//  Weather_App
//
//  Created by Rafał Kozłowski on 22.02.2016.
//  Copyright © 2016 Rafał Kozłowski. All rights reserved.
//

import UIKit

class SmallDayLabel: UILabel {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = frame.size.height/2
        clipsToBounds = true
    }
}
