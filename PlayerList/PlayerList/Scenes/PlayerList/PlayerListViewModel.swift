//
//  PlayerListViewModel.swift
//  PlayerList
//
//  Created by André Lucas Ota on 27/10/21.
//

import Foundation

protocol PlayerListViewModelDelegate: AnyObject {
    func displayLoading()
    func hideLoading()
    func displayPlayerList()
    func displayError()
}

final class PlayerListViewModel {
    weak var delegate: PlayerListViewModelDelegate?
    
    private let service: PlayerListServicing
    private var players: [PlayerModel] = []
    
    init(service: PlayerListServicing) {
        self.service = service
    }
    
    var numberOfRows: Int {
        players.count
    }
    
    func player(for row: Int) -> PlayerModel {
        players[row]
    }
    
    func fetchPlayerList() {
        delegate?.displayLoading()
        
        service.fetchPlayerList { [weak self] result in
            guard let self = self else { return }
            self.delegate?.hideLoading()
            switch result {
            case .success(let list):
                self.players = list.sorted(by: {
                    $0.id > $1.id
                })
                self.delegate?.displayPlayerList()
            case .failure:
                self.delegate?.displayError()
            }
        }
    }
}
