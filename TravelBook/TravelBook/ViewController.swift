//
//  ViewController.swift
//  TravelBook
//
//  Created by Yunus Emre Bitkay on 24.10.2021.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    //Definitions
    @IBOutlet weak var tableViewMain: UITableView!
    var locationNameArray = [String]()
    var locationCommentArray = [String]()
    var idArray  = [UUID]()
    
    //Variables we define to send data from the other screen
    var chosenLocation = ""
    var chosenId : UUID?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //We indicate that TableView resources are on this screen.
        tableViewMain.dataSource = self
        //We delegate to TableView.
        tableViewMain.delegate = self
        
        //We add an "add" button to the navigation bar.
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addLocation))
        
        //We run the function to pull information from the database
        getData()
    }
    
    //When it returns, run the getData function.
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name(rawValue: "newData"), object: nil)
    }

    //We define a segue for the add button in the navigation
    @objc func addLocation(){
        
        //We send the data is empty
        chosenLocation = ""
        
        //We're doing a segue.
        performSegue(withIdentifier: "toAddLocationVC", sender: nil)
    }
    
    //We get information from the database
    @objc func getData(){
        //We connect to the database
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appdelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Locations")
        
        //A Boolean value that indicates whether the objects resulting from a fetch request are faults.
        fetchRequest.returnsObjectsAsFaults = false
        
        //In case of an error in any operation performed in the database with Try-Catch, the program
        do{
            //If the number of results is more than one, do the following
            let results = try context.fetch(fetchRequest)
            if results.count > 0 {
                
                //We use the removeall method so that there are no duplicate elements in the array.
                self.idArray.removeAll(keepingCapacity: false)
                self.locationNameArray.removeAll(keepingCapacity: false)
                self.locationCommentArray.removeAll(keepingCapacity: false)

                //We take the objects we receive into the for loop.
                for vrResult in results as! [NSManagedObject]{
                    
                    //We took the location name from the database and added it to the array
                    if let locationName =  vrResult.value(forKey: "location_name") as? String{
                        locationNameArray.append(locationName)
                    }
                    
                    //We took the location subtitle from the database and added it to the array
                    if let locationComment =  vrResult.value(forKey: "location_comment") as? String{
                        locationCommentArray.append(locationComment)
                    }
                    
                    //We took the id from the database and added it to the array
                    if let id = vrResult.value(forKey: "id") as? UUID{
                        idArray.append(id)
                    }

                    //We are refreshing the elements of the TableView
                   self.tableViewMain.reloadData()
                }
            }
        }catch{
            print("Christ no! we encountered a problem")
        }
    }
    
    //We create the function to rename the TableView items
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //We define the Cell class
        let cell = UITableViewCell()
        
        //We assign the names in the array to the cell we created.
        cell.textLabel?.text = locationNameArray[indexPath.row]
        
        //We send cell back
        return cell
    }
    
    //We create the function that specifies the number of TableView items.In the function here we define the number of elements in the array
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //We send Tableview item count back
        return locationNameArray.count
    }

    //We create a function to find the selected item from Table View
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //We take the selected index number and assign it to the variables we defined earlier.
        chosenLocation = locationNameArray[indexPath.row]
        chosenId = idArray[indexPath.row]
        //We're doing a segue.
        performSegue(withIdentifier: "toAddLocationVC", sender: nil)
    }
    
    //We are sending the selected item in the TableView as data to the other screen before it segues.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //When we work on more than one screen, we can control the segues with if
        if segue.identifier == "toAddLocationVC" {
            
            //We define the other screen and bring the items in it to this screen
            let destinationVC = segue.destination as! AddLocationVC
            
            //We send the data
            destinationVC.selectedLocation = chosenLocation
            destinationVC.selectedID = chosenId
        }
    }
}

