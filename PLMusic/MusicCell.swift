//
//  MusicCell.swift
//  PLMusic
//
//  Created by 連振甫 on 2021/7/30.
//

import UIKit

class MusicCell: UITableViewCell {

    @IBOutlet weak var artistImageView: UIImageView!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        trackNameLabel.textColor = selected ? .white : .black
        artistNameLabel.textColor = selected ? .white : .black
    }

}
