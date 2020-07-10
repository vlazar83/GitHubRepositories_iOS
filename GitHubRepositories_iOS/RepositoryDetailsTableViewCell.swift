//
//  RepositoryDetailsTableViewCell.swift
//  GitHubRepositories_iOS
//
//  Created by admin on 2020. 07. 10..
//  Copyright © 2020. admin. All rights reserved.
//

import UIKit

class RepositoryDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var contributorName: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    var avatarImageURL : String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
