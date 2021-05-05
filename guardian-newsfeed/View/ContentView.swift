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
            .navigationTitle("Newsfeed")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// Home View
struct Home: View {
    @ObservedObject var newsfeed = Newsfeed()
    @State var page: Int = 1
    
    init() {
        newsfeed.loadData(pageParam: page)
    }
    
    var body: some View {
        List {
            ForEach(newsfeed.data) { item in
                NavigationLink (destination: DetailView(story: item) ){
                    HStack {
                        WebImage(url: URL(string: item.fields.thumbnail)!)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .background(Color.secondary)
                            .cornerRadius(5)
                    }

                    VStack (alignment: .leading, spacing: 10) {
                        Text(item.fields.headline)
                            .fontWeight(.bold)
                        Text(item.fields.trailText)
                            .font(.caption)
                            .multilineTextAlignment(.leading)
                    }
                    .frame(maxHeight: 100)
                }
                .onAppear() {
                    if (newsfeed.data.last == item) {
                        newsfeed.loadData(pageParam: page + 1)
                        self.page += 1
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
                Text(story.fields.headline)
                    .fontWeight(.bold)
                Text(story.sectionName)
                    .font(.caption)
                    .multilineTextAlignment(.leading)
                Text(story.fields.trailText)
                    .fontWeight(.bold)
                    .font(.subheadline)
                    .multilineTextAlignment(.leading)
                Text(story.fields.bodyText)
                    .font(.subheadline)
                    .multilineTextAlignment(.leading)
            }
            .padding(20)
            .navigationTitle(story.fields.headline)
        }
    }
}
