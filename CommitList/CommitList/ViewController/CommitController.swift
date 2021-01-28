//
//  ViewController.swift
//  CommitList
//
//  Created by Jing Zhao on 1/28/21.
//

import UIKit

class CommitController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view. 
        self.view.backgroundColor = .red
        setNavBar()
    }
    
    
    
    fileprivate func setNavBar() {
        navigationItem.title = "CommitsList"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.backgroundColor = UIColor.rgb(r: 50, g: 199, b: 242) 
        navigationController?.navigationBar.barTintColor = UIColor.rgb(r: 50, g: 199, b: 242)
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
    }

}





class CustomNavigationCotroller: UINavigationController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
