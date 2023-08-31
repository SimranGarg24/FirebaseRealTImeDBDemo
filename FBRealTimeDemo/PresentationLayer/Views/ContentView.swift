//
//  ContentView.swift
//  FBRealTimeDemo
//
//  Created by Saheem Hussain on 24/08/23.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var contentVm = ContentViewModel()
    
    var body: some View {
        VStack {
            
            Text("Firebase Real Time Database Demo")
                .font(.largeTitle)
                .padding(.top, 20)
            
            TextField("Movie Name", text: $contentVm.movie)
                .padding(12)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
                .padding(.top)
            
            TextField("User Name", text: $contentVm.user)
                .padding(12)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
                .padding(.top)
            
            if contentVm.add {
                Button("Add movie") {
                    contentVm.addMovie()
                }
                .padding(.top)
                .disabled((contentVm.movie.isEmpty || contentVm.user.isEmpty) ? true : false)
            } else {
                Button("Edit movie") {
                    contentVm.editMovie()
                }
                .padding(.top)
                .disabled((contentVm.movie.isEmpty || contentVm.user.isEmpty) ? true : false)
            }
            
            if !contentVm.status.isEmpty {
                Text(contentVm.status)
                    .font(.subheadline)
                    .padding(.top)
            }
            
            List(contentVm.movieList) { movie in
                        RowView(movie: movie.name ?? "", user: movie.addedByUser ?? "")
                            .swipeActions(allowsFullSwipe: false) {
                                Button {
                                    contentVm.currentIndex = contentVm.movieList.firstIndex(of: movie) ?? 0
                                    contentVm.movie = movie.name ?? ""
                                    contentVm.user = movie.addedByUser ?? ""
                                    contentVm.id = movie.id
                                    contentVm.add = false
                                } label: {
                                    Text("Edit")
                                }
                                .tint(.indigo)
                                
                                Button(role: .destructive) {
                                    contentVm.currentIndex = contentVm.movieList.firstIndex(of: movie) ?? 0
                                    contentVm.delete(id: movie.id ?? "")
                                } label: {
                                    Label("Delete", systemImage: "trash.fill")
                                }
                            }
                            .onAppear {
                                if contentVm.movieList.last == movie {
                                    contentVm.isScrolling = true
                                    contentVm.loadMoreContent()
                                }
                            }
            }
            .listStyle(.plain)
            .padding(.top)
            
            Spacer()
        }
        .padding()
        .onAppear {
            contentVm.setupRoot(key: "movie")
            contentVm.getMovieList()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
