//
//  PlayerModel.swift
//  PlayerList
//
//  Created by André Lucas Ota on 27/10/21.
//

import Foundation

struct PlayerModel: Decodable, Equatable {
    let id: Int
    let name: String
    let avatarURL: String
    
    private enum CodingKeys: String, CodingKey {
        case id, name
        case avatarURL = "avatar_url"
    }
}
