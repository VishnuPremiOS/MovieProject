//
//  ViewController.swift
//  BuyMeCoffePjt
//
//  Created by NigilKowsi on 29/03/24.
//

import UIKit

class MoviesListVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchController : UISearchController!
    
    var movies: [Results] = []
    var filteredMovies: [Results] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let nib = UINib(nibName: "MoviesListCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "MoviesListCell")

        ApiManager.shared.fetchMovies { [weak self] movies in
            self?.movies = movies ?? []
            self?.filteredMovies = movies ?? []
            DispatchQueue.main.async {
                self?.getBookMarkList();
            }
        }
    }
    
    
    func getBookMarkList()
    {
        if let data = UserDefaults.standard.data(forKey: "bookmarkedMovies") {
             let decoder = JSONDecoder()
             if var bookmarkedMovies = try? decoder.decode([Results].self, from: data) {
                 for (index, movie) in movies.enumerated() {
                     if let bookmarkedMovieIndex = bookmarkedMovies.firstIndex(where: { $0.trackName == movie.trackName }) {
                         movies[index].bookmarked = true
                         filteredMovies[index].bookmarked = true
                         bookmarkedMovies.remove(at: bookmarkedMovieIndex)
                     }
                 }
             }
         }
        self.tableView.reloadData()

    }

    func filterMovies(with searchText: String) {
       if searchText.isEmpty {
           filteredMovies = movies
       } else {
           filteredMovies = movies.filter { $0.artistName!.lowercased().contains(searchText.lowercased()) }
       }
       tableView.reloadData()
   }
    
    // MARK: - Favourite Button Tapped
    @IBAction func favouriteBtnClicked(_ sender: UIBarButtonItem) {
        
        let detailsVC = storyboard?.instantiateViewController(withIdentifier: "FavouriteListVC") as! FavouriteListVC
        self.navigationController?.pushViewController(detailsVC, animated: true)
    }
    
}

extension MoviesListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MoviesListCell", for: indexPath) as! MoviesListCell
            let movie = filteredMovies[indexPath.row]
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd, yyyy"
        
        let date: Date? = dateFormatterGet.date(from: movie.releaseDate ?? "")
        
        let releaseDate = dateFormatterPrint.string(from: date!)
        
        cell.titleLabel.text = movie.artistName
        cell.ratingLabel.text = releaseDate
        cell.detailsLabel.text = movie.shortDescription ?? " "
        print(movie.shortDescription ?? " ")
        let bookmarkImageName = movie.bookmarked ? "bookmark.fill" : "bookmark"
        cell.bookmark_btn.setImage(UIImage(systemName: bookmarkImageName), for: .normal)
        cell.bookmarkAction = { [weak self] in
            self?.bookmarkMovie(at: indexPath.row)
        }

        let url = URL(string: movie.artworkUrl100 ?? "")!

            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, let image = UIImage(data: data) else { return }
                DispatchQueue.main.async {
                    cell.thumbnailImageView.image = image
                }
            }.resume()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let movie = filteredMovies[indexPath.row]

        let detailsVC = storyboard?.instantiateViewController(withIdentifier: "MoviesDetailsVC") as! MoviesDetailsVC
        detailsVC.movie = movie
        self.navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    // Bookmark Movie
    func bookmarkMovie(at index: Int) {
        filteredMovies[index].bookmarked.toggle()
        saveBookmarkedMovies()
        tableView.reloadData()
    }
    
    // SaveBookmark Movie
    func saveBookmarkedMovies() {
        let bookmarkedMovies = filteredMovies.filter { $0.bookmarked }
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(bookmarkedMovies) {
            UserDefaults.standard.set(encoded, forKey: "bookmarkedMovies")
        }
    }
}

extension MoviesListVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterMovies(with: searchText)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        filterMovies(with: "")
    }
}
