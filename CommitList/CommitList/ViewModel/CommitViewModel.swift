//
//  CommitViewModel.swift
//  CommitList
//
//  Created by Jing Zhao on 1/28/21.
//

import Foundation

struct CommitViewModel {
    let auther: String
    let sha: String
    let message: String
    let commitTime: String
    
    init(commit: CommitResult) {
        self.message = commit.commit?.message ?? ""
        self.sha = commit.sha ?? ""
        self.commitTime = commit.commit?.author?.date ?? ""
        
        let auther = commit.commit?.author?.name ?? ""
        
        self.auther = auther + self.commitTime.my_convertDateFormatter()

    }
}
