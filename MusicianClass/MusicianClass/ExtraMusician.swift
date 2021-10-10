//
//  ExtraMusician.swift
//  MusicianClass
//
//  Created by Yunus Emre Bitkay on 11.10.2021.
//

import Foundation

class ExtraMusician : Musicians{
    func sing2(){
        print("Hangimiz Düşmedik")
    }
    
    override func sing() {
        super.sing()
        print("Bu Karaya Sevdaya!")
    }
}
