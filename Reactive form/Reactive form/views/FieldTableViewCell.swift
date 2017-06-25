//
//  FieldTableViewCell.swift
//  Reactive form
//
//  Created by Pirush Prechathavanich on 6/24/17.
//  Copyright © 2017 Pirush Prechathavanich. All rights reserved.
//

import UIKit

class FieldTableViewCell: UITableViewCell, Reusable, Nibable {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var fieldButton: UIButton!
    
    var type: FieldType = .textField {
        didSet { update(with: type) }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func update(with type: FieldType) {
        fieldButton.isHidden = true
        switch type {
        case .textField:
            textField.keyboardType = .default
        case .passwordField:
            textField.keyboardType = .default
            textField.isSecureTextEntry = true
        case .dateField(let datePicker):
            fieldButton.isHidden = false
            textField.inputView = datePicker
        case .emailField:
            textField.keyboardType = .emailAddress
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        fieldButton.isHidden = true
        textField.inputView = nil
    }
    
}

enum FieldType {
    case textField
    case passwordField
    case emailField
    case dateField(UIDatePicker?)
}
