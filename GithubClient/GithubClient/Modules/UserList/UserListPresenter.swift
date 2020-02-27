//
//  UserListPresenter.swift
//  GithubClient
//
//  Created by Toru Nakandakari on 2020/02/26.
//  Copyright © 2020 仲村渠亨. All rights reserved.
//

import Foundation

protocol UserListPresenterInterface {

    // UserListViewController -> UserListPresenter
    func notifyViewLoaded()
    func notifyViewWillAppear()
    func textFieldShouldReturn(with text: String?)

    // UserListInteractor -> UserListPresenter
    func userListFetched(userList: [User])
    func userListFetchFailed(with errorMessage: String)
}

class UserListPresenter {

    weak var view: UserListViewController?
    var router: UserListRouter?
    var interactor: UserListInteractor?
    var userList: [User]?

    func getUserList() -> [User]? {
        return userList
    }
}

extension UserListPresenter: UserListPresenterInterface {

    func notifyViewLoaded() {
    }

    func notifyViewWillAppear() {

    }

    func textFieldShouldReturn(with text: String?) {
        interactor?.fetchUserList(with: text)
        view?.showLoading()
    }

    func userListFetched(userList: [User]) {
        self.userList = userList
        view?.hideLoading()
        view?.reloadData()
    }

    func userListFetchFailed(with errorMessage: String) {
        router?.performPopup(with: errorMessage)
    }
}
