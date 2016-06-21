//
//  Wireframe.swift
//  SwiftSum
//
//  Created by sihuan on 16/3/4.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit
import RxSwift

enum RetryResult {
    case Retry
    case Cancel
}

extension RetryResult : CustomStringConvertible {
    var description: String {
        switch self {
        case .Retry:
            return "Retry"
        case .Cancel:
            return "Cancel"
        }
    }
}

protocol Wireframe {
    func openURL(URL: NSURL)
    func promtFor<Action: CustomStringConvertible>(message: String, cancelAction: Action, actions: [Action]) -> Observable<Action>
}

class DefaultWireframe: Wireframe {
    static let sharedInstance = DefaultWireframe()
    
    private static func rootViewController() -> UIViewController {
        return UIApplication.sharedApplication().keyWindow!.rootViewController!
    }
    
    static func presentAlert(message: String) {
        let alertView = UIAlertController(title: "RxDemo", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertView.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: { _ in
            rootViewController().presentViewController(alertView, animated: true, completion: nil)
        }))
    }
    
    // MARK: - Wireframe
    func openURL(URL: NSURL) {
        UIApplication.sharedApplication().openURL(URL)
    }
    
    func promtFor<Action : CustomStringConvertible>(message: String, cancelAction: Action, actions: [Action]) -> Observable<Action> {
        return Observable.create{ observer in
            let alertView = UIAlertController(title: "RxDemo", message: message, preferredStyle: UIAlertControllerStyle.Alert)
            alertView.addAction(UIAlertAction(title: cancelAction.description, style: UIAlertActionStyle.Cancel) { _ in
                    observer.on(.Next(cancelAction))
                })
            
            for action in actions {
                alertView.addAction(UIAlertAction(title: action.description, style: UIAlertActionStyle.Default) { _ in
                        observer.on(.Next(action))
                    })
            }
            
            DefaultWireframe.rootViewController().presentViewController(alertView, animated: true, completion: nil)
            
            return AnonymousDisposable {
                alertView.dismissViewControllerAnimated(false, completion: nil)
            }
        }
    }
}































