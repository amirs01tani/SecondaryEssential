//
//  FeedImageCell.swift
//  EssentialProtoType
//
//  Created by Amir on 2/8/24.
//

import Foundation
import UIKit

class FeedImageCell: UITableViewCell {
    @IBOutlet weak var locationContainer: UIView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var feedImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        feedImageView.alpha = 0
    }
    override func prepareForReuse () {
        super .prepareForReuse ()
        feedImageView.alpha = 0
    }
    func fadeIn(_ image: UIImage?) {
        feedImageView.image = image
        UIView.animate(withDuration: 0.3, delay: 0.3, options: [],
                       animations: {
            self.feedImageView.alpha = 1
        })
    }
}

extension FeedImageCell {
    func configure(with model: FeedImageViewModel) {
        locationLabel.text = model.location
        locationContainer.isHidden = model.location == nil
        descriptionLabel.text = model.description
        descriptionLabel.isHidden = model.description == nil
        fadeIn(UIImage(named: model.imageName))
    }
}
