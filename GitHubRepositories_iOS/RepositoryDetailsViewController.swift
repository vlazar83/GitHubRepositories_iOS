//
//  RepositoryDetailsViewController.swift
//  GitHubRepositories_iOS
//
//  Created by admin on 2020. 07. 10..
//  Copyright © 2020. admin. All rights reserved.
//

import UIKit

class Contributor: NSObject, Codable {
   var name = ""
   var avatarImageUrl = ""
    
    enum CodingKeys : String, CodingKey {
          case name = "login"
          case avatarImageUrl = "avatar_url"
    }
}

class RepositoryDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var forksCountLabel: UILabel!
    @IBOutlet weak var stargazersCountLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBAction func backButtonPressed(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    var repository: Repository?
    
    var contributors:Array<Contributor> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        // Do any additional setup after loading the view.
        
        self.sizeLabel.text = String(repository!.size)
        self.forksCountLabel.text = String(repository!.forksCount)
        self.stargazersCountLabel.text = String(repository!.stargazersCount)
        self.fullNameLabel.text = String(repository!.fullName)
        self.nameLabel.text = String(repository!.name)
        
        sendRequest()
    }
    
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return contributors.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "RepositoryDetailsTableViewCell"

        // Configure the cell...
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! RepositoryDetailsTableViewCell
        
        let contributor = contributors[indexPath.row]
        
        cell.contributorName.text = contributor.name
        cell.avatarImageURL = contributor.avatarImageUrl
        
        let url = URL(string: contributor.avatarImageUrl)!
        
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            DispatchQueue.main.async {
                cell.avatarImage.image = UIImage(data: data!)
            }
        }

        return cell
    }
    
    func sendRequest(){
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        sendHttpRequest(contributorsUrl: self.repository!.contributorsURL, finished: {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.tableView.layoutIfNeeded()
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
            }
        })
    }
    
    func sendHttpRequest(contributorsUrl: String, finished: @escaping () -> Void){
        
        // Create URL, encode the "{" and "}" characters around query. https://api.github.com/search/repositories?q={query}&per_page=25&page=

        let url = URL(string: contributorsUrl)
        guard let requestUrl = url else { fatalError("Failed to load a MyCustomCell from the table.") }

        // Create URL Request
        var request = URLRequest(url: requestUrl)

        // Specify HTTP Method to use
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        //request.setValue("Basic htu574kfj584kfnd84kdlwut92jayebgpylg8md72msgrk", forHTTPHeaderField: "Authorization")

        // Send HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Check if Error took place
            if let error = error {
                print("Error took place \(error)")
                return
            }
            
            // Read HTTP Response Status code
            if let response = response as? HTTPURLResponse {
                print("Response HTTP Status code: \(response.statusCode)")
            }
            
            // Convert HTTP Response Data to a simple String
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                print("Response data string:\n \(dataString)")

                let decoder = JSONDecoder()
                let parsedData = try! decoder.decode([Contributor].self, from: data)
                self.contributors = parsedData
                
                finished()
                /*
                self.list.forEach {
                    print($0)
                    print("thiss")
                } */
            }
            
        }
        task.resume()
        
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
