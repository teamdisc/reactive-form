//
//  UITableViewHelper.swift
//  Reactive form
//
//  Created by Pirush Prechathavanich on 6/25/17.
//  Copyright © 2017 Pirush Prechathavanich. All rights reserved.
//

import UIKit

extension UITableView {
    
    //note:- automatically look for self reuseIdentifier without defining
    
    func registerReusableCell<T: UITableViewCell>(_: T.Type) where T: Reusable {
        self.register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
    }
    
    func registerReusableCell<T: UITableViewCell>(_: T.Type) where T: Reusable, T: Nibable {
        self.register(T.nib, forCellReuseIdentifier: T.reuseIdentifier)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T where T: Reusable {
        return self.dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as! T
    }
    
}

//note:- for reusing tableViewCell without hard-coding reuseIdentifier

protocol Reusable: class {
    static var reuseIdentifier: String { get }
}

extension Reusable {
    //note:- default defining
    static var reuseIdentifier: String { return String(describing: Self.self) }
}

//note:- for getting nib without hard-coding

protocol Nibable {
    static var nib: UINib { get }
}

extension Nibable {
    static var nib: UINib { return UINib(nibName: String(describing: Self.self), bundle: nil) }
}

extension Nibable where Self: UIView {
    
    @discardableResult
    static func loadViewFromNib(owner: Self = Self()) -> Self {
        let layoutAttributes: [NSLayoutAttribute] = [.top, .leading, .bottom, .trailing]
        for view in nib.instantiate(withOwner: owner, options: nil) {
            if let view = view as? UIView {
                view.translatesAutoresizingMaskIntoConstraints = false
                owner.addSubview(view)
                layoutAttributes.forEach { attribute in
                    owner.addConstraint(NSLayoutConstraint(item: view,
                                                           attribute: attribute,
                                                           relatedBy: .equal,
                                                           toItem: owner,
                                                           attribute: attribute,
                                                           multiplier: 1,
                                                           constant: 0.0))
                }
            }
        }
        return owner
    }
    
}
