//
//  ValidationResult.swift
//  SwiftSum
//
//  Created by sihuan on 16/3/4.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import Foundation
import RxSwift


enum ValidationResult {
    case OK(message: String)
    case Empty
    case Validating
    case Failed(message: String)
}

extension ValidationResult {
    var isValid: Bool {
        switch self {
        case .OK:
            return true
        default:
            return false
        }
    }
}

extension ValidationResult: CustomStringConvertible {
    var description: String {
        switch self {
        case let .OK(message):
            return message
        case .Empty:
            return ""
        case .Validating:
            return "validating..."
        case let .Failed(message):
            return message
        }
    }
}

struct ValidationColors {
    static let okColor = UIColor(red: 138.0 / 255.0, green: 221.0 / 255.0, blue: 109.0 / 255.0, alpha: 1.0)
    static let errorColor = UIColor.redColor()
}

extension ValidationResult {
    var textColor: UIColor {
        switch self {
        case .OK:
            return ValidationColors.okColor
        case .Empty:
            return UIColor.blackColor()
        case .Validating:
            return UIColor.blackColor()
        case .Failed:
            return ValidationColors.errorColor
        }
    }
}


extension UILabel {
    var ex_validationResult: AnyObserver<ValidationResult> {
        return AnyObserver { [weak self] event in
            switch event {
            case let .Next(result):
                self?.textColor = result.textColor
                self?.text = result.description
            case let .Error(error):
                print(error)
            case .Completed:
                break
            }
        }
    }
}


























