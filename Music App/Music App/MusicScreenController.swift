//
//  MusicScreenController.swift
//  Music App
//
//  Created by Yunus Emre Bitkay on 21.10.2021.
//

import UIKit
import CoreData

class MusicScreenController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var imageViewAlbum: UIImageView!
    @IBOutlet weak var tableViewMusic: UITableView!
    
    var songNameArray = [String]()
    var artistNameArray = [String]()
    var idArray = [UUID]()
    var chosenData = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewMusic.delegate = self
        tableViewMusic.dataSource = self
        self.navigationItem.title = chosenData
        getData()

    }
    
    func getData(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Musics")

        let albumString = chosenData
        fetchRequest.predicate = NSPredicate(format: " album_name = %@", albumString)
        fetchRequest.returnsObjectsAsFaults = false
        
        do{
            let results = try context.fetch(fetchRequest)
            if results.count > 0 {
                for vrResult in results as! [NSManagedObject]{
                    
                    if let songName = vrResult.value(forKey: "music_name") as? String{
                        self.songNameArray.append(songName)
                    }
                    
                    if let id = vrResult.value(forKey: "id") as? UUID{
                        self.idArray.append(id)
                    }
                    
                    if let artistName = vrResult.value(forKey: "artist") as? String{
                        artistNameArray.removeAll(keepingCapacity: false)
                        self.artistNameArray.append(artistName)
                    }
                    
                    if let image = vrResult.value(forKey: "album_image") as? Data{
                        imageViewAlbum.image = UIImage(data: image)
                    }
                
                    self.tableViewMusic.reloadData()
                }
            }
        }catch{
            print("Christ no! we encountered a problem")
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = songNameArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let appDeletegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDeletegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Musics")
            let idString = idArray[indexPath.row].uuidString
            fetchRequest.predicate = NSPredicate(format: "id = %@", idString)
            
            do{
                let results = try context.fetch(fetchRequest)
                if results.count > 0 {
                    for result in results as! [NSManagedObject]{
                        if let id = result.value(forKey: "id") as? UUID{
                            if id == idArray[indexPath.row]{
                                context.delete(result)
                                songNameArray.remove(at: indexPath.row)
                                idArray.remove(at: indexPath.row)
                                self.tableViewMusic.reloadData()
                                
                                do{
                                    try context.save()
                                }catch{
                                    print("Christ no! we encountered a problem")
                                }
                                break;
                            }
                        }
                    }
                }
            }catch{
                print("Christ no! we encountered a problem")
            }
            
        }
    }
}
