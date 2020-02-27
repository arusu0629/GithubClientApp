//
//  UserListViewController.swift
//  GithubClient
//
//  Created by Toru Nakandakari on 2020/02/26.
//  Copyright © 2020 仲村渠亨. All rights reserved.
//

import UIKit

protocol UserListViewInterface {
    func showLoading()
    func hideLoading()
    func reloadData()
}

class UserListViewController: UIViewController {

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var userListTableView: UITableView!
    @IBOutlet weak var fetchActivityIndicatorView: UIActivityIndicatorView!

    var presenter: UserListPresenter?

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.notifyViewLoaded()

        userNameTextField.delegate = self
        userListTableView.delegate = self
        userListTableView.dataSource = self

        fetchActivityIndicatorView.hidesWhenStopped = true
        fetchActivityIndicatorView.style = .gray
        fetchActivityIndicatorView.center = self.view.center
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.notifyViewWillAppear()
    }
}

extension UserListViewController: UserListViewInterface {

    func showLoading() {
        fetchActivityIndicatorView.startAnimating()
    }

    func hideLoading() {
        fetchActivityIndicatorView.stopAnimating()
    }

    func reloadData() {
        userListTableView.reloadData()
    }
}

extension UserListViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        presenter?.textFieldShouldReturn(with: textField.text)
        userNameTextField.resignFirstResponder()
        return true
    }
}

extension UserListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let users = presenter?.getUserList() else {
            return
        }
        if indexPath.row >= users.count {
            return
        }
        guard let webVC = storyboard?.instantiateViewController(withIdentifier: "WebVC") as? WebViewController else {
            return
        }
        let user = users[indexPath.row]
        webVC.requestUrl = user.htmlUrl
        self.navigationController?.pushViewController(webVC, animated: true)
    }
}

extension UserListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let userList = presenter?.getUserList() else {
            return 0
        }
        return userList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)

        guard let users = presenter?.getUserList() else {
            return cell
        }

        if indexPath.row >= users.count {
            return cell
        }

        let user = users[indexPath.row]
        cell.textLabel!.text = user.name
        let imageUrl = URL(string: user.avatarUrl)!
        let imageData = try? Data(contentsOf: imageUrl)
        cell.imageView?.image = UIImage(data: imageData ?? Data())
        cell.detailTextLabel?.text = user.type
        return cell
    }
}
