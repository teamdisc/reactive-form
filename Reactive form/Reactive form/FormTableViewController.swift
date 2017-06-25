//
//  FormTableViewController.swift
//  Reactive form
//
//  Created by Pirush Prechathavanich on 6/25/17.
//  Copyright © 2017 Pirush Prechathavanich. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift

//todo:- move datasource out?

class FormTableViewController: UITableViewController {
    
    let viewModel = FormViewModel()
    
    let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        return picker
    }()
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM YYYY"
        return formatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
        tableView.separatorInset = UIEdgeInsets.zero
        
        tableView.registerReusableCell(FieldTableViewCell.self)
    }
    
    private func setupView() {
        let maskLayer = CAShapeLayer()
        let path = UIBezierPath(roundedRect: tableView.bounds,
                                byRoundingCorners: [.bottomLeft, .bottomRight],
                                cornerRadii: CGSize(width: 10, height: 10))
        maskLayer.path = path.cgPath
        tableView.layer.mask = maskLayer
        tableView.clipsToBounds = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupView()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        //todo:- handle with array?
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //todo:- handle with array?
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as FieldTableViewCell
        let model = viewModel.fields[indexPath.row]
        switch model.type {
        case .dateField:
            cell.type = .dateField(datePicker)
            cell.textField.text = model.property.value
            cell.titleLabel.reactive.text <~ model.property
            model.property <~ datePicker.reactive.dates.map { [unowned self] date in
                return self.dateFormatter.string(from: date)
            }
        default:
            cell.type = model.type
            cell.textField.text = model.property.value
            cell.titleLabel.reactive.text <~ model.property
            model.property <~ cell.textField.reactive.continuousTextValues.skipNil()
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }

}
