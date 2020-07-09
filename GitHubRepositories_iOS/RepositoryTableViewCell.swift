//
//  RepositoryTableViewCell.swift
//  GitHubRepositories_iOS
//
//  Created by admin on 2020. 07. 09..
//  Copyright © 2020. admin. All rights reserved.
//

import UIKit

class RepositoryTableViewCell: UITableViewCell {

    //MARK: Properties
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    
    //MARK: functions
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
