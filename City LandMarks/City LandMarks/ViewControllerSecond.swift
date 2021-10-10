//
//  ViewControllerSecond.swift
//  City LandMarks
//
//  Created by Yunus Emre Bitkay on 10.10.2021.
//

import UIKit

class ViewControllerSecond: UIViewController {

    @IBOutlet weak var labelHeader: UILabel!
    @IBOutlet weak var labelArticles: UILabel!
    @IBOutlet weak var imageviewVC2: UIImageView!
    var selectedLandmarksName = ""
    var selectedLandmarksImages = UIImage()
    var selectedLandmarksArticles = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        labelHeader.text = selectedLandmarksName
        labelArticles.text = selectedLandmarksArticles
        imageviewVC2.image = selectedLandmarksImages
        // Do any additional setup after loading the view.
    }
    


}
