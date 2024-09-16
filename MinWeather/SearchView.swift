//
//  SearchView.swift
//  WeatherApp
//
//  Created by Gregori Farias on 14/9/24.
//

import SwiftUI

struct SearchView: View {
    @State var searchText = ""
    @ObservedObject var viewmodel : HomeViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 18) {
            
            TextField("Search city...", text: $searchText)
                .padding(12)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.top, 28)
                .keyboardType(.webSearch)
                .onSubmit {
                    Task {
                        viewmodel.fetchCity(cityName: searchText)
                    }
                }
            
            if let city = viewmodel.city {
                HStack(spacing: 6) {
                    Image(systemName: "building.2.crop.circle")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.cyan)
                        .padding(8)
                    HStack(spacing: 0) {
                        Text("Check weather in ")
                        Text(city.name)
                            .bold()
                    }
                    .font(.custom("Manrope", size: 17))
                    Spacer()
                    
                    Image(systemName: "chevron.forward.2")
                        .resizable()
                        .foregroundColor(.cyan)
                        .frame(width: 10, height: 10)
                        .opacity(0.8)
                        .padding(4)
                    
                }
                .frame(width: 350, height: 55)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
                .cornerRadius(12)
                .onTapGesture {
                    viewmodel.state = .loading
                    Task {
                        viewmodel.fetchData(lat: city.coord.lat, lon: city.coord.lon)
                    }
                    dismiss()
                }
                
            } else if viewmodel.hasSearched && viewmodel.city == nil {
                HStack() {
                    Spacer()
                    HStack(spacing: -2) {
                        Image(systemName: "exclamationmark.warninglight.fill")
                            .resizable()
                            .foregroundColor(.red)
                            .frame(width: 30, height: 30)
                            .padding(8)
                        Text("Location was not found")
                    }
                    Spacer()
                }
            }
            HStack(spacing: 2) {
                Image(systemName: "location.square.fill")
                    .resizable()
                    .foregroundColor(.cyan)
                    .frame(width: 40, height: 40)
                    .padding(8)
                Text("Check the weather at my location" )
                    .font(.custom("Manrope", size: 17))
                
                Spacer()
                
                Image(systemName: "chevron.forward.2")
                    .resizable()
                    .foregroundColor(.cyan)
                    .frame(width: 10, height: 10)
                    .opacity(0.8)
                    .padding(4)
            }
            
            .frame(width: 350, height: 55)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
            .cornerRadius(12)
            .onTapGesture {
                viewmodel.state = .loading
                Task {
                    viewmodel.fetchData(lat: nil, lon: nil)
                }
                dismiss()
            }
            
        } .modifier(BackgroundViewModifier())
            .ignoresSafeArea()
            .padding(.horizontal, 20)
            .ignoresSafeArea(.keyboard)
            .onDisappear {
                viewmodel.hasSearched = false
            }
        
        Button(action: {
            Task {
                viewmodel.fetchCity(cityName: searchText)
            }
        }, label: {
            Text("Search Location")
                .font(.custom("Manrope", size: 16))
                .fontWeight(.black)
                .frame(width: 350, height: 45)
                .background(.cyan)
                .cornerRadius(12)
                .padding(.bottom, 22)
        })
    }
}


