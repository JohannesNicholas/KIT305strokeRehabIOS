//
//  Record.swift
//  strokeRehab
//
//  Created by mobiledev on 16/5/2022.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

public struct Record : Codable
{
    @DocumentID var documentID:String?
    var buttonsOrNotches: Int32?
    var goals: Bool?
    var reps: Int32?
    var start: Timestamp?
    var title: String?
    var messages: [Message]?
}

public struct Message : Codable
{
    var correctPress: Bool?
    var datetime: Timestamp?
    var message: String?
    var rep: Int32?
}
