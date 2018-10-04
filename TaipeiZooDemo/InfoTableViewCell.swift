//
//  InfoTableViewCell.swift
//  TaipeiZooDemo
//
//  Created by Din Din on 2018/10/3.
//  Copyright © 2018 DinDin. All rights reserved.
//

import UIKit

class InfoTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoOneLabel: UILabel!
    @IBOutlet weak var infoTwoLabel: UILabel!
    @IBOutlet weak var infoImageView: CacheImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bind(data: Result?) {
        guard let data = data else {
            return
        }
        self.titleLabel.text = data.aNameCh
        self.infoOneLabel.text = data.aLocation
        self.infoTwoLabel.text = data.getInfo()
        if let url = URL(string: data.aPic01URL ?? "") {
            self.infoImageView.image = UIImage(named: "taipeiZooIcon")
            self.infoImageView.render(url: url, placeholder: UIImage(named: "taipeiZooIcon"))

        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.infoImageView.image = nil

        
    }

}
