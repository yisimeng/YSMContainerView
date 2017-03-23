//
//  ViewController.swift
//  WeiboProfile
//
//  Created by 忆思梦 on 2017/3/17.
//  Copyright © 2017年 忆思梦. All rights reserved.
//

import UIKit

/*
 需求效果：
 1、当header没有进入nav时，tableView没有滑动效果，
 2、所有tableView的top，都是统一的
 3、当header进入nav之后，切换tableView并滑动，tableView会保持上一次滑动的位置
 4、当tableView向下滑动时，header顶部粘连效果
 
 思路：
 1、使用ScrollView和tableView嵌套
 2、ScrollView控制左右切换多个tableView
 3、tableView共用一个headerView
 *4、当scrollView开始滑动（左右切换）时，在scrollViewWillBeginDragging方法中，先将headerView添加到scrollView或者更外层的view上
 *5、继续滑动调用scrollViewDidScroll方法，如果是添加在scrollView上，则需要不断计算scrollView的contentOffset.x值设置为view.left
 *6、当左右滑动结束后，需要将headerView放回当前的tableView的headerView上。
 7、tableView上下滚动时，headerView是作为tableView.tableHeaderView的子视图跟随当前的tableView滚动的
 */

let headerHeight: CGFloat = 200
let changeBarHeight: CGFloat = 40
let navBarHeight: CGFloat = 64

class ViewController: UIViewController, UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate {
    
    lazy var headerView: UIImageView = UIImageView(image: UIImage(named: "header-back"))
    
    lazy var changeBar: UIView = {
        let changeBar = UIView(frame: CGRect(x: 0, y: self.headerView.frame.height-changeBarHeight, width: self.view.frame.width, height: changeBarHeight))
        changeBar.backgroundColor = UIColor.red
        return changeBar
    }()
    
    @IBOutlet weak var bgScrollView: UIScrollView!
    
    lazy var tableView1: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height), style: .plain)
        tableView.dataSource = self
        tableView.rowHeight = 75
        tableView.delegate = self
        return tableView
    }()
    
    lazy var tableView2: UITableView = {
        let tableView = UITableView(frame: CGRect(x: self.view.frame.width, y: 0, width: self.view.frame.width, height: self.view.frame.height), style: .plain)
        tableView.dataSource = self
        tableView.rowHeight = 75
        tableView.delegate = self
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        
        
        self.headerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 200)
        self.headerView.clipsToBounds = true
        self.headerView.contentMode = .scaleAspectFill
        changeBar.autoresizingMask = [.flexibleTopMargin]
        headerView.addSubview(changeBar)
        
        bgScrollView.contentSize = CGSize(width: bgScrollView.frame.width*2, height: 0)
        bgScrollView.isPagingEnabled = true
        bgScrollView.bounces = false
        
        tableView1.tableHeaderView = UITableViewHeaderFooterView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 200))
        tableView2.tableHeaderView = UITableViewHeaderFooterView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 200))
        
        tableView1.scrollIndicatorInsets = UIEdgeInsets(top: headerHeight, left: 0, bottom: 0, right: 0)
        tableView2.scrollIndicatorInsets = UIEdgeInsets(top: headerHeight, left: 0, bottom: 0, right: 0)
        
        bgScrollView.addSubview(tableView1)
        bgScrollView.addSubview(tableView2)
        bgScrollView.addSubview(headerView)
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let zfbVC = ZFBViewController()
        navigationController?.pushViewController(zfbVC, animated: true)
        
        
    }
    
    
    //将要开始拖拽
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //1、首先获取headimage的父视图，获取contentoffset
        //2、调整其他滚动视图的contentoffset，保持一致
        if scrollView == bgScrollView{
            if let superTableView = headerView.superview?.superview as? UITableView{
                let offset = superTableView.contentOffset
                if offset.y <  headerHeight-navBarHeight-changeBarHeight {
                    tableView1.contentOffset = offset
                    tableView2.contentOffset = offset
                }else {
                    if tableView1.contentOffset.y < headerHeight-navBarHeight-changeBarHeight {
                        tableView1.contentOffset = CGPoint(x: 0, y: headerHeight-navBarHeight-changeBarHeight)
                    }
                    if tableView2.contentOffset.y < headerHeight-navBarHeight-changeBarHeight {
                        tableView2.contentOffset = CGPoint(x: 0, y: headerHeight-navBarHeight-changeBarHeight)
                    }
                }
                adjustHeaderView()
                scrollView.addSubview(headerView)
            }
        }else if let tableView = scrollView as? UITableView {
            if headerView.superview != tableView.tableHeaderView{
                headerView.frame.origin = CGPoint(x: 0, y: 0)
                tableView.tableHeaderView?.addSubview(headerView)
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == bgScrollView  {
            //保持headerView不动
            adjustHeaderView()
        }else {
            let offsetY = scrollView.contentOffset.y;
            let tableView: UITableView = scrollView as! UITableView
            var frame = tableView.tableHeaderView!.frame;
            frame.origin.y = offsetY;
            if offsetY > headerHeight-navBarHeight-changeBarHeight{
                frame.size.height -= headerHeight-navBarHeight-changeBarHeight;
                headerView.frame = frame;
            }else {
                frame.size.height -= offsetY;
                headerView.frame = frame;
            }
        }
        
    }
    
    //调整headerView的位置
    func adjustHeaderView() {
        var point: CGPoint = headerView.frame.origin
        if headerView.superview?.superview == tableView1 {
            point = CGPoint(x: point.x, y: -tableView1.contentOffset.y)
        }else if headerView.superview?.superview == tableView2 {
            point = CGPoint(x: point.x, y: -tableView2.contentOffset.y)
        }
        headerView.frame.origin = CGPoint(x: bgScrollView.contentOffset.x, y: 0)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == bgScrollView{
            if scrollView.contentOffset.x == 0{
                headerView.frame.origin = CGPoint(x: 0, y: tableView1.contentOffset.y)
                tableView1.tableHeaderView?.addSubview(headerView)
            }else {
                headerView.frame.origin = CGPoint(x: 0, y: tableView2.contentOffset.y)
                tableView2.tableHeaderView?.addSubview(headerView)
            }
        }
    }
    
}

