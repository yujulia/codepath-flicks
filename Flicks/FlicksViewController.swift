//
//  ViewController.swift
//  Flicks
//
//  Created by Julia Yu on 2/15/16.
//  Copyright © 2016 Julia Yu. All rights reserved.
//

import UIKit

private let APIKEY = "229cf9c285d7dcc65abd26a73d9fa804"
private let NOW_PLAYING = "https://api.themoviedb.org/3/movie/now_playing?api_key=\(APIKEY)"
private let TOP_RATED = "https://api.themoviedb.org/3/movie/top_rated?api_key=\(APIKEY)"

class FlicksViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
//    private var data: [NSDictionary] = []
    private var movies:[Movie] = []
    
    private func getData(urlString:String) {
    
        let url = NSURL(string:urlString)
        let request = NSURLRequest(URL: url!)
        
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            
                            if let results = responseDictionary["results"] as? NSArray {
                                var movies: [Movie] = []
                                for oneMovie in results as! [NSDictionary] {
                                    movies.append(Movie(data: oneMovie))
                                }
                                
                                self.movies = movies
                            }

                            self.tableView.reloadData()
                
                    }
                }
        });
        task.resume()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.rowHeight = 130
        
        getData(NOW_PLAYING)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension FlicksViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FlicksCell") as! FlicksTableViewCell
        
        if (self.movies.count > 0) {
            cell.cellData = self.movies[indexPath.row]
        }
        
        return cell
    }
}