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
        let diffTime = fullDate.datesCompare()
        
        var detailStr = " committed "
        if diffTime < 60 {
            detailStr += "\(diffTime % 60) minutes ago" 
        } else if diffTime < 60 * 24 {
            detailStr += "\(diffTime / 60) hours ago"
        } else if diffTime < 60 * 24 * 30 {
            if diffTime / (60 * 24) < 2 {
                detailStr += "yesterday"
            } else {
                detailStr += "\(diffTime / (60 * 24)) days ago"
            }
        } else {
            detailStr += "on \(shortDate)"
        }
        
        self.author = author + detailStr
    }
}
