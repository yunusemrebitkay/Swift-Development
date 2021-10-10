//
//  ViewController.swift
//  City LandMarks
//
//  Created by Yunus Emre Bitkay on 10.10.2021.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //Definitions
    var landmarksArray = [String]()
    var landmarksImages = [UIImage]()
    var landmarksArticles = [String]()
    var chosenLandmarksName = ""
    var chosenLandmarksImage = UIImage()
    var chosenLandmarksArticles = ""
  
    
    @IBOutlet weak var tableviewLandmarks: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Identifying the source screen
        tableviewLandmarks.delegate = self
        tableviewLandmarks.dataSource = self
        //Running the function that adds the elements
        addTableViewElements()
    }

    func addTableViewElements(){
        
        //Adding elements to Name Array
        landmarksArray.append("Angkor: Siem Reap")
        landmarksArray.append("Sydney Opera House")
        landmarksArray.append("The Eiffel Tower")
        landmarksArray.append("Taj Mahal")
        landmarksArray.append("Burj Khalifa")
        landmarksArray.append("Machu Picchu")
        landmarksArray.append("Great Wall")
        landmarksArray.append("Keystone")
        landmarksArray.append("Mont Saint-Michel")
        landmarksArray.append("St. Basil's Cathedral")

        //Adding images to UIImage array
        landmarksImages.append(UIImage(named: "Angkor.jpg")!)
        landmarksImages.append(UIImage(named: "Sydney.jpg")!)
        landmarksImages.append(UIImage(named: "Eiffel.jpg")!)
        landmarksImages.append(UIImage(named: "TajMahal.jpg")!)
        landmarksImages.append(UIImage(named: "BurjKhalifa.jpg")!)
        landmarksImages.append(UIImage(named: "MachuPicchu.jpg")!)
        landmarksImages.append(UIImage(named: "GreatWall.jpg")!)
        landmarksImages.append(UIImage(named: "KeyStone.jpg")!)
        landmarksImages.append(UIImage(named: "MontSaint-Michel.jpg")!)
        landmarksImages.append(UIImage(named: "BasilsCathedral.jpg")!)

        //Adding articles to Article Array
        landmarksArticles.append("The expansive Angkor temple complex is one of Southeast Asia's most significant archaeological sites. This UNESCO World Heritage Site is where the Khmer Empire famously reigned from the ninth to 15th centuries. To best understand Angkor's history and its unique Khmer architecture, book a tour guide. And whether you get a guide or choose to explore on your own, be sure to climb to the top of Angkor Wat for truly spectacular views.")
        landmarksArticles.append("The Sydney Opera House is one of Australia's top tourist attractions and one of the world's most recognizable buildings. It's also known as one of the busiest performing arts venues in the world. To get to know the famous Opera House, take The Sydney Opera House Tour, a guided, hourlong journey that costs $40 (about $29 USD). Several additional guided options are also available, including a comprehensive backstage tour of the venue. Afterward, stay for drinks or dinner harborside at one of the venue's outdoor restaurants.")
        landmarksArticles.append("The Eiffel Tower is one of the most visited monuments in the world (especially in June, July and August), so you'll want to plan a visit during the shoulder seasons (spring or fall) to avoid crowds. Splurge on a ticket to the top of this iconic structure for unparalleled views of Paris. Afterward, dine at 58 Tour Eiffel or famed Le Jules Verne. After sunset, you'll see why this must-visit destination in France is known as the City of Light: The Eiffel Tower puts on its own dazzling light show every hour on the hour after dark.")
        landmarksArticles.append("The Taj Mahal is a tribute to Mughal Emperor Shah Jahan's favorite wife. This opulent structure, completed in 1648, has been recognized as the best example of Indo-Islamic architecture by UNESCO. Located in the city of Agra, the Taj Mahal is accessible via an hour plane ride or a three-hour train ride from the capital city of New Delhi. Considering the large crowds this world-renowned site draws, it's best to plan a visit in the morning. Plus, an early morning visit means you can catch the sunrise, which will no doubt cast an enchanting glow upon the white marble structure.")
        landmarksArticles.append("Burj Khalifa is the tallest building and tallest free-standing structure in the world, measuring more than 2,716 feet high. This impressive architectural feat has more than 160 stories to its name, affording unforgettable views of Dubai below. Visitors will want to reserve tickets ahead of time for privileged access to the world's highest observation deck, At The Top, Burj Khalifa SKY. Then, head to the world's highest lounge, The Lounge, Burj Khalifa, for afternoon tea or Champagne at sunset.")
        landmarksArticles.append("The ancient Incan city of Machu Picchu sits perched on a mountaintop in the Andes Mountains at 8,047 feet above sea level. Before you visit this incredible site, it's best to spend the evening in nearby Aguas Calientes to adjust to the region's altitude. Then, take an early morning bus or hike to the citadel. It's important to know that there is an entrance fee to visit, so you'll need to book tickets well in advance of your trip. There are also additional fees to climb to Huayna Picchu and Machu Picchu peaks, where you'll find more spectacular views.")
        landmarksArticles.append("Built more than 2,300 years ago, The Great Wall of China is the longest wall in the world, measuring 13,170 miles in length. The most visited area near Beijing is the Mutianyu section, the longest and one of the more restored parts of the wall. If you're looking for more of an adventure, travel to Jiankou, the most treacherous section. The unrestored Jiankou offers a challenging hike with steep inclines throughout. May and June are the best months to visit for ideal weather and stunning scenery.")
        landmarksArticles.append("This iconic American landmark overlooks the picturesque Black Hills of South Dakota. For the best photo opportunity, arrive at sunrise when the golden light illuminates the faces of the four U.S. presidents. And if you're planning on traveling here during the warmer months, don't miss the nightly lighting ceremony, which occurs from May to September. This outdoor event features a video about the history and the making of the monument; it also pays tribute to veterans as the sculpture is illuminated.")
        landmarksArticles.append("This medieval Benedictine monastery is one of the most spectacular sights in Europe. Dating back to the eighth century, Mont Saint-Michel sits atop an island in the Bay of Saint-Michel at the convergence of Brittany and Normandy. Visitors can reach the abbey on foot, by bus or maringote (horse-drawn carriage). For a treat, stay on the island and enjoy a world-renowned omelet at La Mère Poulard or Normandy specialties, such as crepes and galettes.")
        landmarksArticles.append("St. Basil's Cathedral is prominently located in the center of Moscow's Red Square. The cathedral was built between 1555 and 1561 under Ivan IV, or 'Ivan the Terrible', and is a symbol of the Russian Orthodox Church. Take a tour inside the cathedral, then visit the top attractions at the Kremlin and Lenin's Mausoleum, also on Red Square. Summers are short and incredibly busy, so you may want to consider planning your tour of Moscow for the fall or, if you can handle the cold, the winter when snow blankets the city.")
    }
    
    //Deleting the element requested by user from the TableView
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            landmarksArray.remove(at: indexPath.row)
            landmarksImages.remove(at: indexPath.row)
            tableviewLandmarks.deleteRows(at: [indexPath], with: UITableView.RowAnimation.middle)
        }
    }
    
    //Specifying the name of TableViews
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = landmarksArray[indexPath.row]
        return cell
    }
    
    //Determining the number of TableViews
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return landmarksArray.count
    }

    //Determining the selected row before switching between screens
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenLandmarksName = landmarksArray[indexPath.row]
        chosenLandmarksImage = landmarksImages[indexPath.row]
        chosenLandmarksArticles = landmarksArticles[indexPath.row]
        performSegue(withIdentifier: "toSecondVC", sender: nil)
    }
    
    //Data transmission between screens
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSecondVC"{
            let destinationVC = segue.destination as! ViewControllerSecond
            destinationVC.selectedLandmarksImages = chosenLandmarksImage
            destinationVC.selectedLandmarksName = chosenLandmarksName
            destinationVC.selectedLandmarksArticles = chosenLandmarksArticles
        }
    }
}

