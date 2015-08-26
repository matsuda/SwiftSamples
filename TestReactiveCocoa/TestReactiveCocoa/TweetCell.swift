//
//  TweetCell.swift
//  TestReactiveCocoa
//
//  Created by Kosuke Matsuda on 2015/08/26.
//  Copyright © 2015年 matsuda. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var statusText: UILabel!
    @IBOutlet weak var usernameText: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
