//
//  CacheImage.swift
//  TaipeiZooDemo
//
//  Created by Din Din on 2018/10/3.
//  Copyright © 2018 DinDin. All rights reserved.
//

import Foundation
import UIKit

class CacheImageView: UIImageView {
    
    var cacheImage = NSCache<NSURL, UIImage>()
    var originRequsetURL: URL?
    var responseURL: URL?

    
    var currentTask: URLSessionTask? {
        didSet {
            oldValue?.cancel()
            currentTask?.resume()
        }
    }
}


extension CacheImageView {
    
    func render(url: URL, placeholder: UIImage? = nil) {
        originRequsetURL = url
        
        if let imgFromCache = cacheImage.object(forKey: url as NSURL) {
            DispatchQueue.main.async { [weak self] in
                self?.image = imgFromCache
            }
        } else {
            image = placeholder
            
            
            currentTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let img = data else {
                    print("fail \(url)")
                    return
                }
                
                guard let responseURL = response?.url else { return }
                guard let orginURL = self.originRequsetURL, orginURL == responseURL else { return }
                print("download \(responseURL.absoluteString)")
                guard let image = UIImage(data: img) else { return }
                DispatchQueue.main.async { [weak self] in
                    self?.image = image
                }
                self.responseURL = responseURL
                self.cacheImage.setObject(image, forKey: url as NSURL)
            }
        }
    }
}
