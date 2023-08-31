//
//  RowView.swift
//  FBRealTimeDemo
//
//  Created by Saheem Hussain on 24/08/23.
//

import SwiftUI

struct RowView: View {
    var movie: String
    var user: String
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Movie Name:")
                    .font(.subheadline)
                    .foregroundColor(.accentColor)
                
                Spacer()
                
                Text(movie)
                    .font(.headline)
            }
            
            HStack {
                Text("Added by User:")
                    .font(.subheadline)
                    .foregroundColor(.accentColor)
                
                Spacer()
                
                Text(user)
                    .font(.headline)
            }
        }
        .padding()
    }
}

struct RowView_Previews: PreviewProvider {
    static var previews: some View {
        RowView(movie: "Avengers", user: "Simran")
    }
}
