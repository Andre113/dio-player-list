//
//  PlayerListService.swift
//  PlayerList
//
//  Created by André Lucas Ota on 27/10/21.
//

import Foundation

private let apiURL = "https://run.mocky.io/v3/5edee99f-c2ca-4ce5-a6bc-3cec0ea58edf"

protocol PlayerListServicing {
    func fetchPlayerList(completion: @escaping(Result<[PlayerModel], Error>) -> Void)
}

final class PlayerListService: PlayerListServicing {
    func fetchPlayerList(completion: @escaping(Result<[PlayerModel], Error>) -> Void) {
        guard let url = URL(string: apiURL) else {
            // Handle error
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            DispatchQueue.main.async {
                self?.handle(data: data, error: error, completion: completion)
            }
        }
        task.resume()
    }
}

private extension PlayerListService {
    func handle(
        data: Data? = nil,
        response: HTTPURLResponse? = nil,
        error: Error? = nil,
        completion: @escaping(Result<[PlayerModel], Error>) -> Void
    ) {
        if let error = error {
            completion(.failure(error))
            return
        }
        
        guard let data = data else {
            // Handle error
            return
        }
        
        let jsonDecoder = JSONDecoder()
        
        do {
            let model = try jsonDecoder.decode([PlayerModel].self, from: data)
            completion(.success(model))
        } catch {
            completion(.failure(error))
        }
    }
}
