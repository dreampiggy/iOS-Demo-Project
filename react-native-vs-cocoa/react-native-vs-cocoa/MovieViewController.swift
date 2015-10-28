//
//  ViewController.swift
//  react-native-vs-cocoa
//
//  Created by lizhuoli on 15/10/26.
//  Copyright (c) 2015年 dreampiggy. All rights reserved.
//

import UIKit
//import Alamofire

class MovieViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    let API_KEY = "7waqfqbprs7pajbz28mqf6vz"
    let API_URL = "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/in_theaters.json"
    let PAGE_SIZE = 25;
    
    var movieJSON = JSON("")
    
    func render(result:JSON) {
        indicator.stopAnimating()
        movieJSON = result
        self.tableView.reloadData()
    }
    
    func fetchData() {
        indicator.startAnimating()
        request(.GET, API_URL, parameters: ["apikey": API_KEY, "page_limit": PAGE_SIZE])
            .responseJSON{ _, _, data, _ in
                self.render(JSON(data!))
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var movieNum = movieJSON["movies"].arrayValue.count
        return movieNum
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("movieIdentifier", forIndexPath: indexPath) as! MovieTableViewCell

        let row = indexPath.row
        
        cell.movieTitle.text = movieJSON["movies"][row]["title"].stringValue
        cell.movieYear.text = movieJSON["movies"][row]["year"].stringValue
        var movieImageUrl = movieJSON["movies"][row]["posters"]["thumbnail"].stringValue
        
        if cell.movieImage.image == nil {
            request(.GET, movieImageUrl).response{ _, _, data, _ in
                let movieImage = UIImage(data: data as! NSData)
                cell.movieImage.image = movieImage
            }
        }
        
        return cell
    }
}
