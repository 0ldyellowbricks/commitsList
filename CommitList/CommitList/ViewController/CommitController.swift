//
//  ViewController.swift
//  CommitList
//
//  Created by Jing Zhao on 1/28/21.
//

import UIKit

class CommitController: UITableViewController {
    private let cellId = "cellId"
    
    private var commitVMArr = [CommitViewModel]()
    private var page = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.  
        setNavBar()
        setList()
        requestData() 
        let reControl = UIRefreshControl()
        reControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        reControl.attributedTitle = NSAttributedString(string: "pull to refresh to page 1")
        self.refreshControl = reControl
    }
    @objc fileprivate func requestData() {
        Service.shared.getResults(page: page) { [weak self] result in
            switch result {
            case .success(let res):
                let arr: [CommitViewModel] = res.map({ return CommitViewModel(commit: $0)})
                if self?.page == 1 {
                    self?.commitVMArr.removeAll()
                }
                self?.commitVMArr += arr
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return commitVMArr.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CommitCell
        let commitVM = commitVMArr[indexPath.row]
        cell.cellCommitVM = commitVM
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        if maximumOffset - currentOffset <= 10.0 {
            page += 1
            requestData() 
        }
    }
    @objc fileprivate func refresh() {
        page = 1
        requestData()
        refreshControl?.endRefreshing()
    }
    
    fileprivate func setNavBar() {
        navigationItem.title = "CommitsList"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.backgroundColor = UIColor.rgb(r: 50, g: 199, b: 242) 
        navigationController?.navigationBar.barTintColor = UIColor.rgb(r: 50, g: 199, b: 242)
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
    }
    fileprivate func setList() {
        tableView.register(CommitCell.self, forCellReuseIdentifier: cellId)
        tableView.tableFooterView = UIView()
    }
}





class CustomNavigationCotroller: UINavigationController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
// master edite mar 09 2022 --1
// master edite mar 09 2022 --2
