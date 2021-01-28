//
//  CommitCell.swift
//  CommitList
//
//  Created by Jing Zhao on 1/28/21.
//

import UIKit

class CommitCell: UITableViewCell {
    let msgLabel: UILabel = {
        let lbl = UILabel(frame: CGRect(x: 10, y: 10, width: kScreenWitdh - 20, height: 30))
        lbl.numberOfLines = 0
        lbl.font = .boldSystemFont(ofSize: 16)
        lbl.backgroundColor = .blue
        lbl.text = "1111111"
        return lbl
    }()
    let detailLabel: UILabel = {
        let lbl = UILabel(frame: CGRect(x: 10, y: 50, width: kScreenWitdh - 20, height: 30))
        lbl.textColor = UIColor.rgb(r: 50, g: 199, b: 242)
        lbl.font = .systemFont(ofSize: 14)
        lbl.backgroundColor = .yellow
        lbl.text = "1111111"
        return lbl
    }()
    let authorDateLabel: UILabel = {
        let lbl = UILabel(frame: CGRect(x: 10, y: 90, width: kScreenWitdh - 20, height: 30))
        lbl.font = .systemFont(ofSize: 14)
        lbl.backgroundColor = .orange
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
