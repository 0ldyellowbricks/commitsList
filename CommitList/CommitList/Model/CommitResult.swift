//
//  CommitResult.swift
//  CommitList
//
//  Created by Jing Zhao on 1/28/21.
//

import Foundation

struct CommitResult: Codable {
    var sha: String?
    var commit: Commit?
}

struct Commit: Codable {
    var author: Author?
    var message: String
}

struct Author: Codable {
    var name: String?
    var date: String?
}
//ss
