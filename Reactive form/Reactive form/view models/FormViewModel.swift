//
//  FormViewModel.swift
//  Reactive form
//
//  Created by Pirush Prechathavanich on 6/25/17.
//  Copyright © 2017 Pirush Prechathavanich. All rights reserved.
//

import ReactiveSwift
import Result

enum FormError: Error {
    case empty
    case invalid
    case unavailable
    case mismatch
    case underage
    
    var reason: String {
        switch self {
        case .empty:        return "cannot be empty"
        case .invalid:      return "invalid"
        case .unavailable:  return "unavailble"
        case .mismatch:     return "do not match"
        case .underage:     return "under-age"
        }
    }
}

final class FormViewModel {
    
    let fullname: ValidatingProperty<String, FormError>
    let email: ValidatingProperty<String, FormError>
    let birthday: ValidatingProperty<Date?, FormError>
    let username: ValidatingProperty<String, FormError>
    let password: ValidatingProperty<String, FormError>
    let confirmPassword: ValidatingProperty<String, FormError>
    
    let dateString: ValidatingProperty<String, FormError>
    
//    let valid: Property<Bool>
//    let submit: Action<[String: Any], [String: Any], FormError>
    
    let validatedPassword: Property<String?>
    let reasons: Signal<String, NoError>
    
    var fields: [(property: ValidatingProperty<String, FormError>, type: FieldType)] {
        let fullname = (property:self.fullname, FieldType.textField)
        let email = (self.email, FieldType.emailField)
        let dateString = (self.dateString, FieldType.dateField(nil))
        return [fullname, email, dateString]
    }
    
    
    
    init() {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM YYYY"
        
        fullname = ValidatingProperty<String, FormError>("") { input in
            guard input != "" else { return .invalid(.empty) }
            return FormViewModel.validateFullname(input) ? .valid : .invalid(.invalid)
        }

        email = ValidatingProperty<String, FormError>("") { input in
            guard input != "" else { return .invalid(.empty) }
            return FormViewModel.validateEmail(input) ? .valid : .invalid(.invalid)
        }

        birthday = ValidatingProperty<Date?, FormError>(nil) { input in
            guard let input = input else { return .invalid(.empty) }
            return FormViewModel.validateBirthday(input) ? .valid : .invalid(.underage)
        }
        
        dateString = ValidatingProperty<String, FormError>("") { input in
            guard input != "" else { return .invalid(.empty) }
            return FormViewModel.validateBirthday(dateFormatter.date(from: input)) ? .valid : .invalid(.underage)
        }

        username = ValidatingProperty<String, FormError>("") { input in
            switch input {
            case "teamdisc":
                return .invalid(.unavailable)
            case "":
                return .invalid(.empty)
            default:
                return FormViewModel.validateUsername(input) ? .valid : .invalid(.invalid)
            }
        }

        password = ValidatingProperty<String, FormError>("") { input in
            return FormViewModel.validateUsername(input) ? .valid : .invalid(.invalid)
        }
        
        confirmPassword = ValidatingProperty<String, FormError>("", with: password) { input, password in
            return input == password ? .valid : .invalid(.mismatch)
        }
        
        validatedPassword =
            Property.combineLatest(password.result, confirmPassword.result)
                .map { password, confirmPassword -> String? in
                    return !confirmPassword.isInvalid ? password.value : nil
                }

        reasons = Property.combineLatest(password.result, confirmPassword.result)
            .signal
            .debounce(0.1, on: QueueScheduler.main)
            .map { [$0, $1].flatMap { $0.error?.reason }.joined(separator: "\n") }
        
//        submit = Action(enabledIf: valid.value, { _ -> SignalProducer<Any, FormError> in
//            let dict: [String: Any] = ["fullname": fullname]
//            return SignalProducer(dict)
//        })
//        valid = Property<Bool>(false)
    }
    
    private static func validateFullname(_ fullname: String) -> Bool {
        let regex = "[A-Za-z]+( [A-Za-z]{1,}){1,}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with:fullname)
    }
    
    private static func validateEmail(_ email: String) -> Bool {
        let regex = "[0-9A-Za-z._%+-]+@[0-9A-Za-z.-]+\\.[A-Za-z]{2,}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with:email)
    }
    
    private static func validateBirthday(_ birthday: Date?) -> Bool {
        guard let birthday = birthday else { return false }
        let calendar = Calendar.current
        if let age = calendar.dateComponents([.year], from: birthday, to: Date()).year {
            return age >= 18
        }
        return false
    }
    
    private static func validateUsername(_ username: String) -> Bool {
        let regex = "[0-9A-Za-z]{4,16}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with:username)
    }
}
