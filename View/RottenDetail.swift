//
//  RottonDetail.swift
//  Rotten games
//
//  Created by AMStudent on 11/12/21.
//

import SwiftUI
import Kingfisher


struct RottenDetails: View {
    
// gives details and reviews
    
    @ObservedObject var rottenTools = RottenTools()
    
    let ReviewData: ReviewData
    let RottenViewModel: RottenViewModel
    let backgroundColor: Color
    let flag = "flag"
    let update = "arrow.up.circle"
    
    init(ReviewData: ReviewData, RottenViewModel: RottenViewModel) {
        self.ReviewData = ReviewData
        self.RottenViewModel = RottenViewModel
        self.backgroundColor = Color(RottenViewModel.detectBackgroundColor(forDevs: ReviewData.devs))
    }
    
    var body: some View {
        NavigationView{
            ScrollView{
                
// gives the description and geral look of the page

        ZStack {
            backgroundColor.edgesIgnoringSafeArea(.all)
            
            VStack {
                
                KFImage(URL(string: ReviewData.gameImageURL))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()
                    .offset(y: 25)
                    .zIndex(1)
                
                VStack(alignment: .leading) {
                    
                    VStack(spacing: 1) {
                        
                        Text(ReviewData.id.capitalized)
                            .font(.title)
                        
                        Text(ReviewData.devs.uppercased())
                            .font(.title2).bold()
                            .frame(width: 300, height: 40)
                            .background(backgroundColor)
                            .cornerRadius(20)
                            .shadow(color: .black, radius: 5)
                        
                        
                        Text(ReviewData.description)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(.gray))
                            .padding(.horizontal, 15)
                        
                        VStack {
                            
                            HStack {
                                
                                Text("critic review")
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                    .padding(.top, 10)
                                    .padding(.horizontal, 20)
                                
                            }
                            
                            // gives the reviews of critics and alows user to flag a review if they thinks its biasis or false
                            // also alows users to do their own review
                            // all reviews are based on a 1-10 scale
                            
                            VStack(spacing: 1) {
                                ForEach(0..<2) { i in
                                    if ( i == 0) {
                                        ReviewList(statusName: "GameSpot", value: ReviewData.GameSpot/10, color: backgroundColor)
                                        Button {
                                            rottenTools.flagedGamespot.toggle()
                                        } label: {
                                            Image(systemName: rottenTools.flagedGamespot ? "\(flag)" : "\(flag).fill")
                                        }
                                        Button {
                                            rottenTools.updateGamespot
                                                .toggle()
                                        } label: {
                                            Image(systemName: rottenTools.updateGamespot ? "\(update)" : "\(update).fill")
                                        }
                                        Link("GameSpot Review", destination: URL(string: ReviewData.GameSpotLink)!)
                                    } else {
                                        ReviewList(statusName: "IGN", value: ReviewData.IGN/10, color: backgroundColor)
                                        Button {
                                            rottenTools.flagedIGN.toggle()
                                        } label: {
                                            Image(systemName: rottenTools.flagedIGN ? "\(flag)" : "\(flag).fill")
                                        }
                                        Button {
                                            rottenTools.updateIGN
                                                .toggle()
                                        } label: {
                                            Image(systemName: rottenTools.updateIGN ? "\(update)" : "\(update).fill")
                                        }
                                        Link("IGN Review", destination: URL(string: ReviewData.IGNLink)!)
                                    }
                                }
                                ForEach(0..<2) { i in
                                    if ( i == 0) {
                                        ReviewList(statusName: "Metacritic", value: ReviewData.Metacritic/10, color: backgroundColor)
                                        Button {
                                            rottenTools.flagedMetacritic.toggle()
                                        } label: {
                                            Image(systemName: rottenTools.flagedMetacritic ? "\(flag)" : "\(flag).fill")
                                        }
                                        Button {
                                            rottenTools.updateMetacritic
                                                .toggle()
                                        } label: {
                                            Image(systemName: rottenTools.updateMetacritic ? "\(update)" : "\(update).fill")
                                        }
                                        Link("Metacritic Review", destination: URL(string: ReviewData.MetacriticLink)!)
                                    } else {
                                        ReviewList(statusName: "PCGamer", value: ReviewData.PCGamer/10, color: backgroundColor)
                                        Button {
                                            rottenTools.flagedPCGamer.toggle()
                                        } label: {
                                            Image(systemName: rottenTools.flagedPCGamer ? "\(flag)" : "\(flag).fill")
                                        }
                                        Button {
                                            rottenTools.updatePCGamer
                                                .toggle()
                                        } label: {
                                            Image(systemName: rottenTools.updatePCGamer ? "\(update)" : "\(update).fill")
                                        }
                                        Link("PCGamer Review", destination: URL(string: ReviewData.PCGamerLink)!)
                                    }
                                }
                                Slider(value: $rottenTools.microReview, in: 1...10, step: 1)
                                    
                                Text("\(rottenTools.microReview)")
                            }
                        }
                    }

                    Spacer()

            }
                
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white)
                .edgesIgnoringSafeArea(.bottom)


            }
            
        }
        }
            .navigationTitle(ReviewData.id.capitalized)
            .navigationBarHidden(true)
        }
    }

}

struct MeterBar: View {
    @Binding var value: Float
    @Binding var color: Color
    var body: some View {
        GeometryReader {geometry in
            ZStack(alignment: .leading) {
                Rectangle().frame(width: geometry.size.width, height: geometry.size.height)
                    .opacity(0.3)
                    .foregroundColor(Color(.systemGray))
                Rectangle().frame(width: min(CGFloat(self.value)*geometry.size.width, geometry.size.width), height: geometry.size.height)
                    .foregroundColor(color)
                    .animation(.linear)
                    .cornerRadius(45)
            }
            .cornerRadius(45)
        }
    }
}

struct ReviewList: View {
    @State var statusName: String
    @State var value: Float
    @State var color: Color
    var body: some View {
        HStack {
            Text(statusName.uppercased())
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(Color.gray)
                .padding(.horizontal, 20)
            Text(String(Int(value*100)))
            MeterBar(value: $value, color: $color).frame(height: 10)
                .padding(.trailing, 20)
        }
        .padding(.horizontal, 10)
    }
}

