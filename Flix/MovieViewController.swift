//
//  MovieViewController.swift
//  Flix
//
//  Created by Xiangwei Li on 1/27/21.
//

import UIKit
import AlamofireImage

class MovieViewController: UIViewController , UITableViewDataSource, UITableViewDelegate{
    
    
    @IBOutlet var TableView: UITableView!
    // syntac of array of dictionaly
    var movies = [[String:Any]]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TableView.dataSource = self
        TableView.delegate = self

        // Do any additional setup after loading the view.
        print("Hello")
        
        // Download the movie content JSON from the provied API
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
           // This will run when the network request returns
           if let error = error {
              print(error.localizedDescription)
           } else if let data = data {
              let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
            
              // var movies to get the reuslts from the JSON file, cast as array of dictional
              self.movies = dataDictionary["results"] as! [[String:Any]]
          
              // reload the data
              self.TableView.reloadData()
            
            
              //print(self.movies)
            
              // TODO: Get the array of movies
              // TODO: Store the movies in a property to use elsewhere
              // TODO: Reload your table view data

           }
        }
        task.resume()
        
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // recycall any cell outside screen
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell

        let movie = movies[indexPath.row]
        //                            casting : its a string
        let title = movie["title"] as! String
        //print(title)
        let synopsis = movie["overview"] as! String

        cell.titleLabel.text = title
        cell.synopsisLabel.text = synopsis
        
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL(string: baseUrl + posterPath)
        
        cell.posterView.af.setImage(withURL: posterUrl!)
        return cell
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // the sender was the MovieCell that was tapped on
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        print("Loading up the details")
        
        // Find the selected movie
        let cell = sender as! UITableViewCell
        let indexPath = TableView.indexPath(for: cell)!
        let movie = movies[indexPath.row]
        
        // Pass the selected movie to the details view conroller
        let detailsViewController =
            segue.destination as!
            MovieDetailsViewController
          
        detailsViewController.movie = movie // this second movie is refering to the movie at line97
        
       TableView.deselectRow(at: indexPath, animated: true)
    }
    

}
