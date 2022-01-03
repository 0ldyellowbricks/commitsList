//
//  CommitCell.swift
//  CommitList
//
//  Created by Jing Zhao on 1/28/21.
//

import UIKit

class CommitCell: UITableViewCell {
    //    test for commit this cell
    //    Jan 3 2022 add test for commit this cell
    var cellCommitVM: CommitViewModel! {
        didSet {
            msgLabel.text = cellCommitVM.message
            detailLabel.text = cellCommitVM.sha
            authorDateLabel.text = cellCommitVM.author
        }
    }
    let msgLabel: UILabel = {
        let lbl = UILabel(frame: CGRect(x: 10, y: 10, width: kScreenWitdh - 20, height: 60))
        lbl.numberOfLines = 0
        lbl.font = .boldSystemFont(ofSize: 16)
        lbl.text = "1111111"
        return lbl
    }()
    let detailLabel: UILabel = {
        let lbl = UILabel(frame: CGRect(x: 10, y: 80, width: kScreenWitdh - 20, height: 25))
        lbl.textColor = UIColor.rgb(r: 50, g: 199, b: 242)
        lbl.font = .systemFont(ofSize: 14)
        lbl.text = "1111111"
        return lbl
    }()
    let authorDateLabel: UILabel = {
        let lbl = UILabel(frame: CGRect(x: 10, y: 105, width: kScreenWitdh - 20, height: 25))
        lbl.font = .systemFont(ofSize: 14)
        lbl.text = "1111111"
        return lbl
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .white
        addSubview(msgLabel)
        addSubview(detailLabel)
        addSubview(authorDateLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
