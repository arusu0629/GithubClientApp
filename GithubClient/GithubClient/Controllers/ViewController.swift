//
//  ViewController.swift
//  GithubClient
//
//  Created by Toru Nakandakari on 2020/02/24.
//  Copyright © 2020 仲村渠亨. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet var userTableView: UITableView!

    var users: [User] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        userNameTextField.delegate = self
        userTableView.delegate = self
        userTableView.dataSource = self
    }

    private func findUser(name: String) {
        self.users.removeAll()
        GithubApi.searchUser(name: name) { (result) in
            switch result {
            case .success(let response):
                self.users.append(contentsOf: response.value.items)
                self.userTableView.reloadData()
            case .failure(let error):
                print("find user error = \(error)")
                self.userTableView.reloadData()
            }
        }
    }

}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        findUser(name: userNameTextField.text ?? "")
        userNameTextField.resignFirstResponder()
        return true
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)

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
