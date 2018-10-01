//
//  ViewController.swift
//  TaipeiZooDemo
//
//  Created by PeterDing on 2018/9/30.
//  Copyright © 2018 DinDin. All rights reserved.
//

import UIKit
//https://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=a3e2b221-75e0-45c1-8f97-75acbd43d613&limit=3
class ViewController: UIViewController {
    
    @IBOutlet weak var mTableViewTop: NSLayoutConstraint!
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTableView.dataSource = self
        mainTableView.delegate = self
    }
    
    
}


extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "infoDemoCell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = String(indexPath.row)
        return cell
    }
}


extension ViewController: UITableViewDelegate {
    
}


extension ViewController: UIScrollViewDelegate {
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            if  mTableViewTop.constant < 200 {
                mTableViewTop.constant += -scrollView.contentOffset.y
                scrollView.contentOffset.y = 0
            }
            
        } else if scrollView.contentOffset.y > 0 {
            if mTableViewTop.constant > 0 {
                mTableViewTop.constant -= scrollView.contentOffset.y
                scrollView.contentOffset.y = 0

                
            }
        } else {
            if mTableViewTop.constant > 0 {
                scrollView.contentOffset.y = 0
                
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
        print(scrollView.contentOffset.y)
        if translation.y > 0, scrollView.contentOffset.y == 0 {
            UIView.animate(withDuration: 0.5) {
                scrollView.contentOffset.y = 0
                self.mTableViewTop.constant = 200
                self.view.layoutIfNeeded()
                
            }
            
        } else if translation.y < 0, scrollView.contentOffset.y == 0 {
            UIView.animate(withDuration: 0.5) {
                scrollView.contentOffset.y = 0
                self.mTableViewTop.constant = 0
                self.view.layoutIfNeeded()
                
            }
            
        }
    }
    
}
