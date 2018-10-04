//
//  ViewController.swift
//  TaipeiZooDemo
//
//  Created by PeterDing on 2018/9/30.
//  Copyright © 2018 DinDin. All rights reserved.
//

import UIKit
class FirstPageViewController: UIViewController {
    
    let headerHeight: CGFloat = 200
    
    @IBOutlet weak var headerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var bannerLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mTableViewTop: NSLayoutConstraint!
    @IBOutlet weak var mainTableView: UITableView! {
        didSet {
            mainTableView.dataSource = self
            mainTableView.delegate = self
        }
    }
    @IBOutlet weak var headerView: UIView!
    private var refreshControl: UIRefreshControl!
    lazy var data = FirstPageViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        updateStatus()
        requestData()
    }
    
    private func initUI() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        titleLabel.alpha = 0
        headerViewHeight.constant = headerHeight + ((UIApplication.shared.keyWindow?.safeAreaInsets.top) ?? 20) + 44
        initRefreshControl()
    }
    private func initRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.pullToRefresh), for: .valueChanged)
        mainTableView.addSubview(refreshControl)
    }
    
}

extension FirstPageViewController {
    
    @objc func pullToRefresh() {
        data.refreshData()
        requestData()
    }
    private func refreshUI() {
        self.refreshControl.endRefreshing()
        self.mainTableView.reloadData()
    }
    private func requestData() {
        switch  data.status {
        case .loading:
            break
        default:
            data.requestAPI()
        }
    }
    
    private func updateStatus() {
        data.updateStatus = { [weak self] state in
            switch state {
            case .finish:
                DispatchQueue.main.async {
                    self?.refreshUI()
                }
            case .loading:
                self?.mainTableView.reloadData()
            case .empty:
                break
            case .fail(let error):
                self?.refreshUI()
                print(error.debugDescription)
            }
        }
        requestData()
    }
}

//MARK: 
extension FirstPageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: InfoTableViewCell.self), for: indexPath) as! InfoTableViewCell
        cell.selectionStyle = .none
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
            if  mTableViewTop.constant < headerHeight {
                mTableViewTop.constant += -scrollView.contentOffset.y
                setLabelAlpha(with: mTableViewTop.constant)
                scrollView.contentOffset.y = 0
                
            }
            
        } else if scrollView.contentOffset.y > 0 {
            if mTableViewTop.constant > 0 {
                let offset = mTableViewTop.constant - scrollView.contentOffset.y
                mTableViewTop.constant = offset < 0 ? 0 : offset
                setLabelAlpha(with: mTableViewTop.constant)
                scrollView.contentOffset.y = 0
            }
        } else {
            if mTableViewTop.constant > 0 {
                scrollView.contentOffset.y = 0                
            }
        }
    }
    
    private func setLabelAlpha(with constant: CGFloat) {
        let ratio = (constant / headerHeight)
        bannerLabel.alpha = ratio
        titleLabel.alpha = 1 - ratio
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        setTableViewHeight(scrollView)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        setTableViewHeight(scrollView)
    }
    
    private func setTableViewHeight(_ scrollView: UIScrollView) {
        let translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
        print(scrollView.contentOffset.y)
        if translation.y > 0, scrollView.contentOffset.y == 0 {
            UIView.animate(withDuration: 0.5) {
                scrollView.contentOffset.y = 0
                self.mTableViewTop.constant = self.headerHeight
                self.view.layoutIfNeeded()
                self.setLabelAlpha(with: self.mTableViewTop.constant)
                
            }
        } else if translation.y < 0, scrollView.contentOffset.y == 0 {
            UIView.animate(withDuration: 0.5) {
                scrollView.contentOffset.y = 0
                self.mTableViewTop.constant = 0
                self.view.layoutIfNeeded()
                self.setLabelAlpha(with: self.mTableViewTop.constant)
                
            }
        }
    }
}
