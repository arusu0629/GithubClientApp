//
//  User.swift
//  GithubClient
//
//  Created by Toru Nakandakari on 2020/02/24.
//  Copyright © 2020 仲村渠亨. All rights reserved.
//

import Foundation

struct SearchUsersResponse: Codable {
    let items: [User]
}

struct User: Codable {
    let name: String
    let avatarUrl: String
    let htmlUrl: String
    let type: String
}

extension User {
    enum CodingKeys: String, CodingKey {
        case name = "login"
        case avatarUrl = "avatar_url"
        case htmlUrl = "html_url"
        case type = "type"
    }
}
