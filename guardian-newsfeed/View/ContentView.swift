//
//  ContentView.swift
//  guardian-newsfeed
//
//  Created by Nouman on 03/05/2021.
//

import SwiftUI
import Combine
import SDWebImageSwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            Home()
            .navigationBarTitle("Newsfeed")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

// Home View
struct Home: View {
    @ObservedObject var newsfeed = Newsfeed()
    @State var page: Int = 1
    
    init() {
        newsfeed.loadData(pageParam: page, search: nil, key: nil)
    }
    
    var body: some View {
        
        if (newsfeed.error != "") {
            Error(message: newsfeed.error)
            
        } else {
            List {
                ForEach(newsfeed.data) { item in
                    NavigationLink (destination: DetailView(story: item) ){
                        HStack {
                            WebImage(url: URL(string: item.fields.thumbnail)!)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 120, height: 120)
                                .cornerRadius(2)
                        }
                        VStack (alignment: .leading, spacing: 5) {
                            Text(item.fields.headline)
                                .font(.headline)
                                .fontWeight(.bold)
                            Text(item.fields.trailText)
                                .font(.caption)
                        }
                        .frame(maxHeight: 120)
                    }
                    .onAppear() {
                        if (newsfeed.data.last == item) {
                            newsfeed.loadData(pageParam: page + 1, search: nil, key: nil)
                            self.page += 1
                        }
                    }
                }
            }
        }
    }
}

// Detail View
struct DetailView: View {
    let story: Result
    var body: some View {
        
        ScrollView {
            VStack (alignment: .leading, spacing: 10) {
                WebImage(url: URL(string: story.fields.thumbnail)!)
                    .resizable()
                    .scaledToFit()
                    .frame(alignment: .center)
                Text("\(story.pillarName) / \(story.sectionName)")
                    .font(.caption)
                Text(story.fields.headline)
                    .fontWeight(.bold)
                    .font(.system(size: 20))
                Text(story.fields.trailText)
                    .font(.subheadline)
                Spacer()
                Text(story.fields.bodyText)
                    .font(.subheadline)
            }
            .padding(20)
            .navigationBarTitle(story.fields.headline)
        }
    }
}

// Error View
struct Error: View {
    let message: String
    var body: some View {
        VStack {
            Text(message)
                .fontWeight(.light)
                .multilineTextAlignment(.center)
                .font(.body)
                .padding()
            Spacer()
        }
    }
}
