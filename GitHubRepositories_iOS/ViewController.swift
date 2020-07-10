//
//  ViewController.swift
//  GitHubRepositories_iOS
//
//  Created by admin on 2020. 07. 08..
//  Copyright © 2020. admin. All rights reserved.
//

import UIKit

protocol RefreshTableViewDelegateProtocol {
  func refreshTableView()
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, RefreshTableViewDelegateProtocol {

    func refreshTableView() {
      // do something
        self.tableView.reloadData()
    } 
    
    @IBAction func nextButtonClicked(_ sender: Any) {
        
    }
    @IBAction func prevButtonClicked(_ sender: Any) {
        
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var nextButtonOutlet: UIButton!
    
    @IBOutlet weak var prevButtonOutlet: UIButton!
    
    var repositories:Array<Repository> = []
    
    struct RepositoryData: Codable {
        var total_count :Int = 0
        var incomplete_results : Bool
        var items: [Repository]
    }
    
    struct Repository: Codable {
       var name = ""
       var fullName = ""
       var contributorsURL = ""
       var size : Int = 0
       var stargazersCount : Int = 0
       var forksCount : Int = 0
        
        enum CodingKeys : String, CodingKey {
              case name
              case fullName = "full_name"
              case contributorsURL = "contributors_url"
              case size
              case stargazersCount = "stargazers_count"
              case forksCount = "forks_count"
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        senndHttpRequest(finished: {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
    
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return repositories.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "RepositoryTableViewCell"

        // Configure the cell...
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! RepositoryTableViewCell
        
        let repository = repositories[indexPath.row]
        
        cell.nameLabel.text = repository.name
        cell.fullNameLabel.text = repository.fullName

        return cell
    }

    
    func senndHttpRequest(finished: @escaping () -> Void){
        
        // Create URL, encode the "{" and "}" characters around query. https://api.github.com/search/repositories?q={query}&per_page=25&page=
        let originalUrlString = "https://api.github.com/search/repositories?q=%7Bquery%7D&per_page=25&page=1"
        let url = URL(string: originalUrlString)
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
                let parsedData = try! decoder.decode(RepositoryData.self, from: data)
                self.repositories = parsedData.items
                
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

}

