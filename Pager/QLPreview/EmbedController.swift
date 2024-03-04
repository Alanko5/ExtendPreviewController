//
//  EmbedController.swift
//  Pager
//
//  Created by Test on 02/03/2024.
//

import UIKit

class WeakObject {
    weak var object: AnyObject?
    init(object: AnyObject) { self.object = object}
}

class EmbedController {

    private weak var rootViewController: UIViewController?
    private(set) var controllers = [WeakObject]()
    init (rootViewController: UIViewController) { self.rootViewController = rootViewController }

    func append(viewController: UIViewController, to view: UIView) {
        guard let rootViewController = rootViewController else { return }
        controllers.append(WeakObject(object: viewController))
        rootViewController.addChild(viewController)
        view.addSubview(viewController.view)
    }

    deinit {
        if rootViewController == nil || controllers.isEmpty { return }
        for controller in controllers {
            if let controller = controller.object {
                controller.view.removeFromSuperview()
                controller.removeFromParent()
            }
        }
        controllers.removeAll()
    }
}
