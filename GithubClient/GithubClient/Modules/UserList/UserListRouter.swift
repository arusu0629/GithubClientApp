//
//  UserListRouter.swift
//  GithubClient
//
//  Created by Toru Nakandakari on 2020/02/27.
//  Copyright © 2020 仲村渠亨. All rights reserved.
//

import Foundation
import UIKit

protocol UserListRouterInterface {
    // UserListPresenter -> UserListRouter
    func performSeque(with identifier: String)
    func performPopup(with errorMessage: String)
}

class UserListRouter {

    weak var presenter: UserListPresenter?
    weak var navigationController: UINavigationController?

    static func createModule() -> UIViewController {
        // Create layers
        let router = UserListRouter()
        let presenter = UserListPresenter()
        let interactor = UserListInteractor()
        guard let view = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserListVC") as? UserListViewController else {
            return UserListViewController()
        }

        let navigationController = UINavigationController(rootViewController: view)

        // Connect layers
        presenter.interactor = interactor
        presenter.router = router
        presenter.view = view
        view.presenter = presenter
        interactor.presenter = presenter
        router.presenter = presenter
        router.navigationController = navigationController

        return navigationController
    }
}

extension UserListRouter: UserListRouterInterface {

    func performSeque(with identifier: String) {
        self.navigationController?.visibleViewController?.performSegue(withIdentifier: identifier, sender: nil)
    }

    func performPopup(with errorMessage: String) {
        let alert = UIAlertController(title: "Alert", message: "データの取得に失敗しました", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        navigationController?.present(alert, animated: true, completion: nil)
    }
}
