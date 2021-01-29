//
//  MyHelper.swift
//  CommitList
//
//  Created by Jing Zhao on 1/28/21.
//

import UIKit

extension String {
    func my_convertDateFormatter() -> String {
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
        let commitTimeStamp = dateFormatter.string(from: convertedDate!)
        
        dateFormatter.dateFormat = "MM-dd-yyyy"
        let dateStr = dateFormatter.string(from: convertedDate!)
//        let finalDate = getDiff(commitDate: commitTimeStamp,dateStr: dateStr)
        return dateStr
    }
//    func getDiff(commitDate: String, dateStr: String) -> String {
//
//    }
}

extension UIColor { 
    static func rgb(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}

let kScreenWitdh = UIScreen.main.bounds.width
