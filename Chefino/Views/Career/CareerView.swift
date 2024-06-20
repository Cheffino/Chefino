//
//  CareerView.swift
//  Chefino
//
//  Created by Mehmet Akkavak on 15.06.2024.
import SwiftUI

struct CareerView: View {
    let buttonData = [
        (title: "Button 1", imageName: "image1", url: URL(string: "https://careers.fourseasons.com/us/en/search-results?keywords=culinary")!),
        (title: "Button 2", imageName: "image2", url: URL(string: "https://jobs.marriott.com/marriott/jobs?lang=en-us&page=1&brand=The%20Ritz-Carlton&src=JB-13042&utm_medium=jobboard&utm_source=MarriottCareersWebsite&sortBy=relevance&keywords=chef")!),
        (title: "Button 3", imageName: "image3", url: URL(string: "https://jobs.marriott.com/marriott/jobs?lang=en-us&page=1&brand=Bulgari%20Hotels%20%26%20Resorts&src=JB-13261&utm_medium=jobboard&utm_source=MarriottCareersWebsite&categories=Food%20and%20Beverage%20%26%20Culinary")!),
        (title: "Button 4", imageName: "image4", url: URL(string: "https://kempinski.pinpointhq.com/?search=chef")!),
        (title: "Button 5", imageName: "image5", url: URL(string: "https://careers.rosewoodhotelgroup.com/en_US/careers/SearchJobs/chef?listFilterMode=1&folderRecordsPerPage=10&")!),
        (title: "Button 6", imageName: "image6", url: URL(string: "https://careers.accor.com/global/en/jobs?q=chef%20&options=&page=1")!)
    ]

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
                     ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(buttonData, id: \.title) { data in
                        NavigationLink(destination: WebView(url: data.url)) {
                            Image(data.imageName)
                                .resizable()
                                .scaledToFill()
                                .frame(width: UIScreen.main.bounds.width * 0.45, height: UIScreen.main.bounds.width * 0.45)
                                .clipped()
                                .cornerRadius(10)
                                .shadow(radius: 5)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Career")
        }
    }


struct CareerView_Previews: PreviewProvider {
    static var previews: some View {
        CareerView()
    }
}
