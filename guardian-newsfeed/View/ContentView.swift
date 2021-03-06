//
//  ContentView.swift
//  guardian-newsfeed
//
//  Created by Nouman on 03/05/2021.
//

import SwiftUI
import Combine
import SDWebImageSwiftUI

// Routing
enum Coordinator {
    case detail(Result)
}

struct Navigator {
    static func navigate<T: View>(_ coordinate: Coordinator, @ViewBuilder content: () -> T) -> AnyView {
        switch coordinate {
        
        case .detail(let item):
            return AnyView(NavigationLink(
                            destination: DetailView(story: item)) {
                            content()
            })
        }
    }
}

// Main
struct ContentView: View {
    var body: some View {
        NavigationView {
            Home()
                .accessibility(identifier: "newsList")
            .navigationBarTitle("Newsfeed")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

// Home View
struct Home: View {
    @ObservedObject var newsfeed = Newsfeed()
    @State var page: Int = 1

    var body: some View {
        List {
            ForEach(newsfeed.data) { item in
                
                Navigator.navigate(.detail(item)) {
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
                        newsfeed.loadData(pageParam: page + 1, search: nil, key: nil) { result, size in
                            if (result != nil) { newsfeed.data.append(contentsOf: result!) }
                            if (size != nil) { newsfeed.pageSize += size! }
                        }
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
        .accessibility(identifier: "detailList")
    }
}

