//
//  Musician.swift
//  MusicianClass
//
//  Created by Yunus Emre Bitkay on 11.10.2021.
//

import Foundation

enum MusicianType{
    case LeadGuitar
    case Vocalist
    case Drummer
    case Bassist
    case Violenist
}

class Musicians{
    
    //Property
    var name : String
    var age : Int
    var instrument : String
    var type : MusicianType
    
    init(nameInit: String, ageInit: Int, instrumentInit: String, typeInit: MusicianType){
        name = nameInit
        age = ageInit
        instrument = instrumentInit
        type = typeInit
    }

    func sing(){
        print("Hangimiz Sevmedik")
    }
    
}
