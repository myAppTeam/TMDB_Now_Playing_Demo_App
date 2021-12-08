//
//  Box.swift
//  TMDB_Now_Playing_Demo_App
//
//  Created by Sachin Ambegave on 04/12/21.
//

import Foundation
import UIKit

class Box<T> {
    typealias CompletionHandler = (() -> Void)
    private var observers = [String: CompletionHandler]()
    
    var value : T {
        didSet {
            self.notify()
        }
    }
    
    var filteredValue : T {
        didSet {
            self.notify()
        }
    }
    
    
    init(_ value: T,_ filteredValue: T) {
        self.value = value
        self.filteredValue = filteredValue
    }
    
    var isDeletedRow: Bool = false
    var deletedRowIndex: Int!
    var selectedMovie: Movie!
    
    public func addObserver(_ observer : NSObject, completionHandler : @escaping CompletionHandler) {
        observers[observer.description] = completionHandler
    }
    
    public func addAndNotify(observer : NSObject, completionHandler : @escaping CompletionHandler) {
        self.addObserver(observer, completionHandler: completionHandler)
        self.notify()
    }
    
    private func notify() {
        observers.forEach({ $0.value() })
    }
    
    deinit {
        observers.removeAll()
    }
}
