//
//  ViewController.swift
//  Flicks
//
//  Created by Julia Yu on 2/15/16.
//  Copyright © 2016 Julia Yu. All rights reserved.
//

import UIKit
import MBProgressHUD

private let APIKEY = "229cf9c285d7dcc65abd26a73d9fa804"
private let NOW_PLAYING = "https://api.themoviedb.org/3/movie/now_playing?api_key=\(APIKEY)"
private let TOP_RATED = "https://api.themoviedb.org/3/movie/top_rated?api_key=\(APIKEY)"

class FlicksViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var errorPanel: UIView!
    
    private var movies:[Movie]?
    private var endpoint: String?
    
    let refreshControl = UIRefreshControl()
    
    func loadData() {
    
        let url = NSURL(string:self.endpoint!)
        let request = NSURLRequest(URL: url!)
        
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            
                            MBProgressHUD.hideHUDForView(self.view, animated: true)
                            self.errorPanel.hidden = true
                            
                            if let results = responseDictionary["results"] as? NSArray {
                                var movies: [Movie] = []
                                for oneMovie in results as! [NSDictionary] {
                                    movies.append(Movie(data: oneMovie))
                                }
                                
                                self.movies = movies
                            }
                            
                            self.refreshControl.endRefreshing()
                            self.tableView.reloadData()
                    }
                }
                
                if let error = error {
                    print(error)
                    self.refreshControl.endRefreshing()
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                    self.errorPanel.hidden = false
                }
        });
        task.resume()
    }
    
    func refresh(refreshControl: UIRefreshControl) {
        self.loadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.rowHeight = 130
        self.errorPanel.hidden = true
        self.endpoint = NOW_PLAYING 
        
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.insertSubview(self.refreshControl, atIndex: 0)
        
        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detailSegue" {
            let vc = segue.destinationViewController as? FlicksDetailViewController
            
            let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)
        
            if let movies = self.movies {
                let movie = movies[indexPath!.row]
                if let destination = vc {
                    destination.detailData = movie
                }
            }
        }
    }
}

extension FlicksViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let movies = self.movies {
            return movies.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FlicksCell") as! FlicksTableViewCell
        
        if let movies = self.movies {
            cell.cellData = movies[indexPath.row]
        }
        
        return cell
    }
}