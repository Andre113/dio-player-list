//
//  PlayerListViewModelTests.swift
//  PlayerListTests
//
//  Created by André Lucas Ota on 04/11/21.
//

import Foundation
import XCTest
@testable import PlayerList

private class PlayerListServicingStub: PlayerListServicing {
    var fetchPlayerListResult: Result<[PlayerModel], Error> = .success([])
    func fetchPlayerList(completion: @escaping (Result<[PlayerModel], Error>) -> Void) {
        completion(fetchPlayerListResult)
    }
}

private class PlayerListServiceFake: PlayerListServicing {
    func fetchPlayerList(completion: @escaping (Result<[PlayerModel], Error>) -> Void) {
        completion(.success([
            PlayerModel(id: 0, name: "Neymar", avatarURL: ""),
            PlayerModel(id: 1, name: "Messi", avatarURL: ""),
            PlayerModel(id: 2, name: "Cristiano Ronaldo", avatarURL: "")
        ]))
    }
    
    private(set) var playerList: [PlayerModel] = []
    func sendPlayer(player: PlayerModel) {
        playerList.append(player)
    }
}

private class PlayerListViewModelDelegateMock: PlayerListViewModelDelegate {
    enum Methods {
        case displayLoading, hideLoading, displayPlayerList, displayError
    }
    
    private(set) var methodCalls: [Methods] = []
    
    func displayLoading() {
        methodCalls.append(.displayLoading)
    }
    
    func hideLoading() {
        methodCalls.append(.hideLoading)
    }
    
    func displayPlayerList() {
        methodCalls.append(.displayPlayerList)
    }
    
    func displayError() {
        methodCalls.append(.displayError)
    }
}

private class PlayerListViewModelDelegateSpy: PlayerListViewModelDelegate {
    private(set) var displayLoadingCount = 0
    func displayLoading() {
        displayLoadingCount += 1
    }
    
    private(set) var hideLoadingCount = 0
    func hideLoading() {
        hideLoadingCount += 1
    }
    
    private(set) var displayPlayerListCount = 0
    func displayPlayerList() {
        displayPlayerListCount += 1
    }
    
    private(set) var displayErrorCount = 0
    func displayError() {
        displayErrorCount += 1
    }
}

private struct ErrorDummy: Error { }

final class PlayerListViewModelTests: XCTestCase {
    private var sut: PlayerListViewModel!
    private var service: PlayerListServicingStub!
    private var delegate: PlayerListViewModelDelegateSpy!
    
    override func setUp() {
        super.setUp()
        service = PlayerListServicingStub()
        sut = PlayerListViewModel(service: service)
        delegate = PlayerListViewModelDelegateSpy()
        
        sut.delegate = delegate
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
        service = nil
        delegate = nil
    }
    
    func testNumberOfRows_ShouldBeEqualToNumberOfPlayersOnList() {
        let player = PlayerModel(id: 0, name: "", avatarURL: "")
        service.fetchPlayerListResult = .success(Array(repeating: player, count: 5))
        sut.fetchPlayerList()
        
        XCTAssertEqual(5, sut.numberOfRows)
    }
    
    func testPlayerForRow_ShouldReturnPlayerForRow() {
        let player = PlayerModel(id: 0, name: "", avatarURL: "")
        let playerToCompare = PlayerModel(id: 1, name: "De Bruyne", avatarURL: "url_foto_do_de_bruyne")
        
        service.fetchPlayerListResult = .success([player, playerToCompare])
        sut.fetchPlayerList()
        
        XCTAssertEqual(playerToCompare, sut.player(for: 0))
    }
    
    func testFetchPlayerList_ShouldCallDisplayLoading() {
        sut.fetchPlayerList()
        
        XCTAssertEqual(1, delegate.displayLoadingCount)
    }
    
    func testFetchPlayerList_ShouldCallHideLoading() {
        sut.fetchPlayerList()
        
        XCTAssertEqual(1, delegate.hideLoadingCount)
    }
    
    func testFetchPlayerList_WhenSuccess_ShouldCallDisplayPlayerList() {
        sut.fetchPlayerList()
        
        XCTAssertEqual(1, delegate.displayPlayerListCount)
        XCTAssertEqual(0, delegate.displayErrorCount)
    }
    
    func testFetchPlayerList_WhenFailure_ShouldCallDisplayError() {
        service.fetchPlayerListResult = .failure(ErrorDummy())
        sut.fetchPlayerList()
        
        XCTAssertEqual(1, delegate.displayErrorCount)
        XCTAssertEqual(0, delegate.displayPlayerListCount)
    }
    
    func testFetchPlayerList_WhenSuccess_ShouldSortPlayerListByID() {
        var playerList: [PlayerModel] = [
            PlayerModel(id: 4, name: "Harry Kane", avatarURL: ""),
            PlayerModel(id: 0, name: "Vinicius Junior", avatarURL: ""),
            PlayerModel(id: 1, name: "Zlatan Ibrahimovic", avatarURL: ""),
            PlayerModel(id: 3, name: "Trent Alexander-Arnold", avatarURL: ""),
            PlayerModel(id: 2, name: "Frenkie de Jong", avatarURL: "")
        ]
        service.fetchPlayerListResult = .success(playerList)
        
        sut.fetchPlayerList()
        
        playerList = playerList.sorted(by: { $0.id > $1.id })
        XCTAssertEqual(playerList[0], sut.player(for: 0))
        XCTAssertEqual(playerList[1], sut.player(for: 1))
        XCTAssertEqual(playerList[2], sut.player(for: 2))
        XCTAssertEqual(playerList[3], sut.player(for: 3))
        XCTAssertEqual(playerList[4], sut.player(for: 4))
    }
}
