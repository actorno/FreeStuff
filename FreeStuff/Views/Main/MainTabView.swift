//
//  MainTabView.swift
//  FreeStuff
//
//  Created by Aerhelle Torno on 9/9/25.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @StateObject private var locationService = LocationService.shared
    
    var body: some View {
        TabView {
            ItemFeedView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            
            ChatListView()
                .tabItem {
                    Image(systemName: "message")
                    Text("Messages")
                }
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person")
                    Text("Profile")
                }
        }
        .onAppear {
            // Request location permission when app starts
            locationService.requestLocationPermission()
        }
    }
}

#Preview {
    MainTabView()
}
