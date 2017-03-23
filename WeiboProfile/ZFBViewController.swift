//
//  ZFBViewController.swift
//  WeiboProfile
//
//  Created by 忆思梦 on 2017/3/23.
//  Copyright © 2017年 忆思梦. All rights reserved.
//

import UIKit
import MJRefresh

class ZFBViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate {
    
    
    lazy var headerView: UIImageView = UIImageView(image: UIImage(named: "header-back"))
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height), style: .plain)
        tableView.dataSource = self
        tableView.rowHeight = 75
        tableView.delegate = self
        return tableView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        self.headerView.frame = CGRect(x: 0, y: -200, width: self.view.frame.width, height: 200)
        self.headerView.clipsToBounds = true
        self.headerView.contentMode = .scaleAspectFill
        self.headerView.backgroundColor = UIColor.red
        
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            sleep(1)
            self.tableView.mj_header.endRefreshing()
        })
        
        view.addSubview(tableView)
        
        tableView.addSubview(headerView)
        
        tableView.contentInset = UIEdgeInsets(top: 200, left: 0, bottom: 0, right: 0)
        tableView.scrollIndicatorInsets = UIEdgeInsets(top: 200, left: 0, bottom: 0, right: 0)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "a")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "a")
        }
        cell!.textLabel?.text = "第\(indexPath.row)行"
        return cell!
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        var frame = headerView.frame
        
        if offsetY < -200 {
            frame.origin.y = offsetY
        }else {
            frame.origin.y = -200
        }
        headerView.frame = frame
    }

}
