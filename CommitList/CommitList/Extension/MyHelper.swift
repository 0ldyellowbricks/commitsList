//
//  MyHelper.swift
//  CommitList
//
//  Created by Jing Zhao on 1/28/21.
//

import UIKit

extension String {
    func my_convertDateFormatter(fullDate: Bool) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        dateFormatter.locale = Locale(identifier: "en_US")
        let convertedDate = dateFormatter.date(from: self)
        guard dateFormatter.date(from: self) != nil else {
            assert(false, "no date from string")
            return ""
        }
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(name: "America/Los_Angeles") as TimeZone?
        let fullDateStr = dateFormatter.string(from: convertedDate!)
        
        dateFormatter.dateFormat = "MM-dd-yyyy"
        let shortDateStr = dateFormatter.string(from: convertedDate!)
        
        if fullDate {
            return fullDateStr
        } else {
            return shortDateStr
        }
    }
    func datesCompare() -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let currentTimeString = dateFormatter.string(from: Date())
        dateFormatter.timeZone = TimeZone.init(identifier: "America/Los_Angeles")
        let dateModel = dateFormatter.date(from: self)
        let dateNow = dateFormatter.date(from: currentTimeString)
        let timeModel = String.init(format: "%ld", Int(dateModel!.timeIntervalSince1970))
        let timeNow = String.init(format: "%ld", Int(dateNow!.timeIntervalSince1970))
        
        let diffTime = (Int(timeNow)! - Int(timeModel)!) / 60
        return diffTime
    }
}

extension UIColor { 
    static func rgb(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}

let kScreenWitdh = UIScreen.main.bounds.width

/*
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

 */
