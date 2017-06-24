//
//  FieldTableViewCell.swift
//  Reactive form
//
//  Created by Pirush Prechathavanich on 6/24/17.
//  Copyright © 2017 Pirush Prechathavanich. All rights reserved.
//

import UIKit

class FieldTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var fieldButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
