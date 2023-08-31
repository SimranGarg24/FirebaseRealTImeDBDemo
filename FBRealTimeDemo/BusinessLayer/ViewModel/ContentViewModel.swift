//
//  ContentViewModel.swift
//  FBRealTimeDemo
//
//  Created by Saheem Hussain on 24/08/23.
//

import Foundation

class ContentViewModel: ObservableObject {
    
    @Published var status: String = String()
    @Published var movie: String = String()
    @Published var user: String = String()
    @Published var id: String?
    @Published var movieList: [MovieModel] = []
    @Published var add = true
    @Published var isScrolling = false
    @Published var currentIndex: Int = 0
    
    let dbManager = RealTimeDBManager.shared
    
    func setupRoot(key: String) {
        dbManager.setUpReference(key: key)
    }
    
    func addMovie() {
        
        let movie = ["id": dbManager.getuniquekey() ?? "", "name": movie, "addedByUser": user]
        status = "Adding movie..."
        dbManager.addData(key: movie["id"] ?? "", data: movie) { status, error in
            
            if status {
                self.status = "Movie added successfully."
                self.movie = String()
                self.user = String()
            } else {
                self.status = "Error saving movie: \(error?.localizedDescription ?? "")"
            }
        }
    }
    
    func editMovie() {
        let movie = ["id": id ?? "", "name": movie, "addedByUser": user]
        status = "Updating movie..."
        dbManager.currentIndex = currentIndex
        dbManager.update(id: id ?? "", data: movie) { status, error in
            
            if status {
                self.status = "Movie updated successfully."
                self.movie = String()
                self.user = String()
                self.id = nil
                self.add = true
                
            } else {
                self.status = "Error updating movie: \(error?.localizedDescription ?? "")"
            }
        }
    }
    
    func delete(id: String) {
        status = "Deleting movie..."
        dbManager.currentIndex = currentIndex
        dbManager.delete(id: id) {success, error in
            if success {
                self.status = "Movie deleted successfully."
            } else {
                self.status = "Error deleting movie: \(error?.localizedDescription ?? "")"
            }
        }
    }
    
    func getMovieList() {
        
        dbManager.setObserver { list in
            
            if let list {
                self.movieList.removeAll()
                for movie in list {
                    let mov = movie["name"]
                    let id = movie["id"]
                    let user = movie["addedByUser"]
                    
                    let model = MovieModel(id: id, name: mov, addedByUser: user)
                    
                    self.movieList.append(model)
                }
                
                print(self.movieList)
            }
        }
    }
    
    func loadMoreContent() {

        if self.movieList.isEmpty {
            dbManager.lastFetchedKey = nil
        } else {
            if isScrolling {
                dbManager.lastFetchedKey = movieList.last?.id
            }
        }
        
        dbManager.pagingData { list in
            
            if let list {
                self.movieList.removeAll()
                for movie in list {
                    let mov = movie["name"]
                    let id = movie["id"]
                    let user = movie["addedByUser"]
                    
                    let model = MovieModel(id: id, name: mov, addedByUser: user)
                    
                    self.movieList.append(model)
                }
                
                print(self.movieList)
            }
            self.isScrolling = false
        }
    }
    
    func removeObservers() {
        dbManager.removeObserver()
    }
}
