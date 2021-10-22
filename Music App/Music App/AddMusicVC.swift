//
//  AddMusicVC.swift
//  Music App
//
//  Created by Yunus Emre Bitkay on 22.10.2021.
//

import UIKit
import CoreData

class AddMusicVC: UIViewController,  UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var textFieldAlbumName: UITextField!
    @IBOutlet weak var textFieldArtist: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var textFieldSongName: UITextField!
    @IBOutlet weak var imageViewMusic: UIImageView!
    
    var chosenData = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Add Music"

        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HideKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
        
        let imageTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        view.addGestureRecognizer(imageTapRecognizer)
        
    }
    
    @objc func HideKeyboard(){
        view.endEditing(true)
    }
    
    @objc func selectImage(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageViewMusic.image = info[.originalImage] as? UIImage
        saveButton.isEnabled = true
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func saveButtonClicked(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newMusic = NSEntityDescription.insertNewObject(forEntityName: "Musics", into: context)

        //Attributes
        newMusic.setValue(UUID(), forKey: "id")
        newMusic.setValue(textFieldAlbumName.text!, forKey: "album_name")
        newMusic.setValue(textFieldArtist.text!, forKey: "artist")
        newMusic.setValue(textFieldSongName.text!, forKey: "music_name")
        let data = imageViewMusic.image!.jpegData(compressionQuality: 0.5)
        newMusic.setValue(data, forKey: "album_image")
        
        do{
            try context.save()
            print("Success")
        } catch {
            print("Error")
        }
        NotificationCenter.default.post(name: NSNotification.Name("newData"), object: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
}
