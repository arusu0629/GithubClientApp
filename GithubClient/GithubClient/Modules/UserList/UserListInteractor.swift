//
//  File.swift
//  GithubClient
//
//  Created by Toru Nakandakari on 2020/02/27.
//  Copyright © 2020 仲村渠亨. All rights reserved.
//

import Foundation

protocol UserListInteractorInteface {
    // UserListPresentr -> UserListInteractor
    func fetchUserList(with searchWords: String?)
}

class UserListInteractor: UserListInteractorInteface {

    weak var presenter: UserListPresenter?

    func fetchUserList(with searchWords: String?) {
        guard let searchWords = searchWords else {
            presenter?.userListFetched(userList: [])
            return
        }
        GithubApi.searchUser(name: searchWords) { (result) in
            switch result {
            case .success(let response):
                self.presenter?.userListFetched(userList: response.value.items)
            case .failure(let error):
                self.presenter?.userListFetchFailed(with: error.localizedDescription)
            }
        }
    }
}
