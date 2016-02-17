//
//  Movie.swift
//  Flicks
//
//  Created by Julia Yu on 2/16/16.
//  Copyright © 2016 Julia Yu. All rights reserved.
//

import Foundation

public class Movie:NSObject {
    
    var lowresPoster: String?
    var highresPoster: String?
    var poster: String?
    var overview: String?
    var title: String?
    var thumbnailPoster: String?

    // Initializes a GitHubRepo from a JSON dictionary
    init(data: NSDictionary) {
        if let originalTitle = data["title"] as? String {
            self.title = originalTitle
        }
        
        if let desc = data["overview"] as? String {
            self.overview = desc
        }
        
        if let poster = data["poster_path"] as? String {
            self.thumbnailPoster = "https://image.tmdb.org/t/p/w342\(poster)"
            self.lowresPoster = "https://image.tmdb.org/t/p/w45\(poster)"
            self.highresPoster = "https://image.tmdb.org/t/p/original\(poster)"
        }
    }
    
}