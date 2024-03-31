//
//  MoviesListCell.swift
//  BuyMeCoffePjt
//
//  Created by NigilKowsi on 29/03/24.
//

import UIKit

class MoviesListCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var bookmark_btn: UIButton!

    var bookmarkAction: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

    @IBAction func bookmarkButtonTapped(_ sender: UIButton) {
        bookmarkAction?()
    }
    
}
