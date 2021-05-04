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
    
    var body: some View {
        List(newsfeed.data) { i in
            
            NavigationLink (destination: DetailView(story: i) ){
                HStack {
                    if (i.fields.thumbnail != "") {
                        WebImage(url: URL(string: i.fields.thumbnail)!)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 120)
                            .background(Color.secondary)
                            .cornerRadius(5)
                    } else {
                        Image("not-found").resizable().frame(width: 120, height: 80).cornerRadius(10)
                    }
                }
                
                VStack (alignment: .leading, spacing: 10) {
                    Text(i.fields.headline)
                        .fontWeight(.bold)
                    Text(i.fields.trailText)
                        .font(.caption)
                        .multilineTextAlignment(.leading)
                }
                .frame(maxHeight: 100)
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
