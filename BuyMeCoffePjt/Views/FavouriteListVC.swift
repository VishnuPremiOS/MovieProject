//
//  FavouriteListVC.swift
//  BuyMeCoffePjt
//
//  Created by NigilKowsi on 30/03/24.
//

import UIKit

class FavouriteListVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var filteredMovies: [Results] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let data = UserDefaults.standard.data(forKey: "bookmarkedMovies") {
            let decoder = JSONDecoder()
            if let bookmarkedMovies = try? decoder.decode([Results].self, from: data) {
                filteredMovies = bookmarkedMovies
            }
        }
        
        
        let nib = UINib(nibName: "MoviesListCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "MoviesListCell")
    }
     
    // MARK: - Back Button Tapped
    @IBAction func backAr(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }

}

extension FavouriteListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MoviesListCell", for: indexPath) as! MoviesListCell
            let movie = filteredMovies[indexPath.row]
            cell.titleLabel.text = movie.artistName
            cell.ratingLabel.text = "\(movie.releaseDate ?? "")"
        cell.detailsLabel.text = movie.shortDescription ?? " "
        let bookmarkImageName =  "bookmark.fill"
        cell.bookmark_btn.setImage(UIImage(systemName: bookmarkImageName), for: .normal)

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
    
}
