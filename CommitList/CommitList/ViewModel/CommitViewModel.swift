//
//  CommitViewModel.swift
//  CommitList
//
//  Created by Jing Zhao on 1/28/21.
//

import Foundation

struct CommitViewModel {
    let author: String
    let sha: String
    let message: String
    let commitTime: String
    
    init(commit: CommitResult) {
        self.message = commit.commit?.message ?? ""
        self.sha = commit.sha ?? ""
        self.commitTime = commit.commit?.author?.date ?? ""
        
        let author = commit.commit?.author?.name ?? ""
        
        let shortDate = self.commitTime.my_convertDateFormatter(fullDate: false)
        
        let fullDate = self.commitTime.my_convertDateFormatter(fullDate: true)
        let diffTime = fullDate.getDiff()
        if diffTime < 60 {
            print("less than one hour")
        } else if diffTime < 60 * 24 {
            print("less than one day")
        } else if diffTime < 60 * 24 * 30 {
            print("--- days")
        } else {
            print("full date")
        }
        
        self.author = author
    }
}
