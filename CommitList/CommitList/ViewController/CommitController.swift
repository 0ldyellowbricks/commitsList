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
        navigationController?.navigationBar.backgroundColor = .blue
        navigationController?.navigationBar.barTintColor = .green
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
    }

}





class CustomNavigationCotroller: UINavigationController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
