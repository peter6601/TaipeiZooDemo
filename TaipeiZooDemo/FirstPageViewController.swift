//
//  ViewController.swift
//  TaipeiZooDemo
//
//  Created by PeterDing on 2018/9/30.
//  Copyright © 2018 DinDin. All rights reserved.
//

import UIKit
class FirstPageViewController: UIViewController {
    
    
    @IBOutlet weak var mTableViewTop: NSLayoutConstraint!
    @IBOutlet weak var mainTableView: UITableView! {
        didSet {
//            mainTableView.register(InfoTableViewCell.self, forCellReuseIdentifier: "InfoCell")
            mainTableView.dataSource = self
            mainTableView.delegate = self
        }
    }
    @IBOutlet weak var headerView: UIView!
    lazy var data = FirstPageViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestData()
    } 
}

extension FirstPageViewController {
    
    private func requestData() {
        data.updateData = { [weak self] in
            DispatchQueue.main.async {
                self?.mainTableView.reloadData()
            }
        }
        
        data.requestAPI { (error) in
            print(error.debugDescription)
        }
    }
}

extension FirstPageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: InfoTableViewCell.self), for: indexPath) as! InfoTableViewCell
        cell.bind(data: data[indexPath.row]) 
        return cell
    }
}

extension FirstPageViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath.row == data.count - 10  else {
            return 
        }
        requestData()
    }
}


extension FirstPageViewController: UIScrollViewDelegate {
    
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
