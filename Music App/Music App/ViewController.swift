//
//  ViewController.swift
//  Music App
//
//  Created by Yunus Emre Bitkay on 21.10.2021.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var imageViewMain: UIImageView!
    @IBOutlet weak var tableViewMain: UITableView!
    
    var albumsNameArray = [String]()
    var artistNameArray = [String]()
    var selectedData = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewMain.delegate = self
        tableViewMain.dataSource = self
        self.navigationItem.title = "Apple Music"
        getData()

        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addMusicButton))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name(rawValue: "newData"), object: nil)
    }
    
    @objc func addMusicButton(){
        performSegue(withIdentifier: "toAddMusicScreen", sender: nil)
    }
    
    @objc func getData(){        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Musics")
        fetchRequest.returnsObjectsAsFaults = false

        do{
            let results = try context.fetch(fetchRequest)
            if results.count > 0 {
                for vrResult in results as! [NSManagedObject]{
                    if let albumName = vrResult.value(forKey: "album_name") as? String{
                        if !(albumsNameArray.contains(albumName)){
                            self.albumsNameArray.append(albumName)
                        }
                    }
                    if let artistName = vrResult.value(forKey: "artist") as? String{
                        if !(artistNameArray.contains(artistName)){
                            self.artistNameArray.append(artistName)
                        }
                    }
                   self.tableViewMain.reloadData()
                }
            }
        }catch{
            print("Christ no! we encountered a problem")
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedData = albumsNameArray[indexPath.row]
        performSegue(withIdentifier: "toMusicScreen", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMusicScreen"{
            let destinationVC = segue.destination as! MusicScreenController
            destinationVC.chosenData = selectedData
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if(artistNameArray.count>1){
            cell.textLabel?.text = " \(artistNameArray[indexPath.row]) - \(albumsNameArray[indexPath.row])"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albumsNameArray.count
    }
    
}

