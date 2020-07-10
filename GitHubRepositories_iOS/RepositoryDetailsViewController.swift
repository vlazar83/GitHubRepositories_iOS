//
//  RepositoryDetailsViewController.swift
//  GitHubRepositories_iOS
//
//  Created by admin on 2020. 07. 10..
//  Copyright © 2020. admin. All rights reserved.
//

import UIKit

class RepositoryDetailsViewController: UIViewController {
    
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var forksCountLabel: UILabel!
    @IBOutlet weak var stargazersCountLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBAction func backButtonPressed(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    var repository: Repository?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.sizeLabel.text = String(repository!.size)
        self.forksCountLabel.text = String(repository!.forksCount)
        self.stargazersCountLabel.text = String(repository!.stargazersCount)
        self.fullNameLabel.text = String(repository!.fullName)
        self.nameLabel.text = String(repository!.name)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
