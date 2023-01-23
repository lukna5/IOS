//
//  FIlmCard.swift
//  ios-itmo-2022-assignment2
//
//  Created by mac on 22.01.2023.
//

import SwiftUI

struct FIlmCard: View {
    let film: String
    let director: String
    let rating: Int
    let imageName: String
    init(_ film: String, _ director: String, _ rating: Int, _ imageName: String) {
        self.film = film
        self.director = director
        self.rating = rating
        self.imageName = imageName
    }
    @State private var isSharePresented: Bool = false
    func emp(){
        print(77)
    }
    var body: some View {
        GeometryReader { info in
            ZStack{
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .edgesIgnoringSafeArea(.all)
                
                VStack{
                    HStack{
                        
                    }
                    .padding(.bottom, info.size.height / 1.3)
                    Text(film)
                        .font(.headline)
                        .foregroundColor(Color.white)
                        .padding(.bottom, 3.0)
                    Text(director)
                        .font(.footnote)
                        .fontWeight(.regular)
                        .foregroundColor(Color.gray)
                        .padding(.bottom, 7.0)
                    HStack{
                        Text(String(rating) + "/5")
                            .fontWeight(.semibold)
                            .foregroundColor(Color.white)
                        ForEach(0..<rating){_ in
                            Image("smallStar")

                        }
                    }
                }
                
                Button(action: {
                    self.isSharePresented = true
                }) {
                        Image("share")
                }
                .sheet(isPresented: $isSharePresented, onDismiss: {
                }, content: {
                    ActivityViewController(activityItems: [URL(string: "https://www.apple.com")!])
                })
                .frame(width: 30, height: 50)
                .offset(x: info.size.width / 2 - 30, y:  info.size.height / -2 + 20)

            }
        }
    }
}

struct ActivityViewController: UIViewControllerRepresentable {

    var activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil

    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityViewController>) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityViewController>) {}

}

struct FIlmCard_Previews: PreviewProvider {
    static var previews: some View {
        FIlmCard("Film", "director", 4, "AssaultRioBravo")
    }
}


