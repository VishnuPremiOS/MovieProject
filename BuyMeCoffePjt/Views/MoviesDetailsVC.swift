//
//  MoviesDetailsVC.swift
//  BuyMeCoffePjt
//
//  Created by NigilKowsi on 29/03/24.
//

import UIKit

class MoviesDetailsVC: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel! 

    var movie: Results?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let movie = movie {
                        
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "MMM dd, yyyy"
            
            let date: Date? = dateFormatterGet.date(from: movie.releaseDate ?? "")
            let releaseDate = dateFormatterPrint.string(from: date!)
            
            let url = URL(string: movie.artworkUrl100 ?? "")!

            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, let image = UIImage(data: data) else { return }
                DispatchQueue.main.async {
                    self.movieImage.image = image
                }
            }.resume()
            
            titleLabel.text = movie.artistName
           descriptionLabel.text = movie.shortDescription
           releaseDateLabel.text = releaseDate

       }
        
    }
    
    // MARK: - Back Button Tapped
    @IBAction func backAr(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }

}
