//
//  SomethingViewModel.swift
//  PlayerList
//
//  Created by André Lucas Ota on 02/11/21.
//

import Foundation

final class PlayerListManager {
    private(set) var list: [PlayerModel] = []
    
    func add(_ player: PlayerModel) {
        list.append(player)
    }
    
    func removeFirst(_ player: PlayerModel) {
        guard let index = list.firstIndex(of: player) else { return }
        list.remove(at: index)
    }
    
    func getFrom(_ index: Int) -> PlayerModel? {
        guard list.count > index else { return nil }
        return list[index]
    }
    
    init() {
        print("Player List initialized")
    }
    
    deinit {
        print("Player List deinitialized")
    }
}
