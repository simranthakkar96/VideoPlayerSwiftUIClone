//
//  ContentView.swift
//  VideoPlayerSwiftUI
//
//  Created by Michael Gauthier on 2021-01-06.
//

import SwiftUI
import AVKit
import Alamofire


class Host: UIHostingController<ContentView>
{
        override var preferredStatusBarStyle: UIStatusBarStyle
        {
            return .lightContent
        }
}

struct ContentView: View {
    
    // Initilization of the variable
    @State var player = AVPlayer(url: URL(string: "https://wolverine.raywenderlich.com/content/ios/tutorials/video_streaming/foxVillage.mp4")!)
    @State var Playing = false
    @State var showcontrols = false
     
    
    var body: some View {
        // using vertical stack to vertically align the components on screen
        VStack
        {
            // to set the controls on the video uding Z-axis
            ZStack
            {
                VideoPlayer(player: $player)
                if self.showcontrols
                {
                    VideoControls(player: self.$player, playing: self.$Playing, showcontrols: self.$showcontrols)
                }
            }
            .frame(height: UIScreen.main.bounds.height/3.5)
            .onTapGesture {
                self.showcontrols = true
            }
            
            // Using GemoetryReader to set the size of frame
            // Aliging of the frame can be done in center, topLeading, topTraling, bottomLeading, bottomTrailing
            GeometryReader{ geometry in
            VStack(spacing: 20)
            {
                ScrollView(.vertical) {
                    
                        Text("Hello").foregroundColor(.white)
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .topLeading)
            }
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
 
    }
}

// Structure for creating Controls on the video
struct VideoControls: View{
    // Setting datatypes of the variables
    @Binding var player: AVPlayer
    @Binding var playing: Bool
    @Binding var showcontrols: Bool
    
    var body: some View
    {
        VStack{
            Spacer()
            HStack{
                Button(action: {})
                    {
                    Image(systemName: "backward.fill")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .foregroundColor(.white)
                }
                
                Spacer()
                Button(action: {
                    if self.playing{
                        self.player.pause()
                        self.playing = false
                    }
                    else{
                        self.player.play()
                        self.playing = true
                    }
                })
                    {
                    Image(systemName: self.playing ? "pause.fill" : "play.fill")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .foregroundColor(.white)
                }
                
                Spacer()
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/)
                    {
                    Image(systemName: "forward.fill")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .foregroundColor(.white)
                }
            }
            Spacer( )
        }.padding()
        .onTapGesture {
            self.showcontrols = false
        }
    }
}

//Crating the AVPlayer instance and using it in the contentview
struct VideoPlayer : UIViewControllerRepresentable
{
    @Binding var player: AVPlayer
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<VideoPlayer>) -> AVPlayerViewController {
        
        let controller = AVPlayerViewController()
        controller.player = player
        controller.showsPlaybackControls = false
        controller.videoGravity = .resize
        return controller
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//class datas: ObservableObject
//{
//
//    @Published var jsonData = [dataType]()
//
//    init()
//    {
//        let session = URLSession(configuration: .default)
//
//        session.dataTask(with: URL(string: "http://localhost:4000/videos")!) { (data, _, _) in
//            do{
//                let fetch = try JSONDecoder().decode([dataType].self, from: data!)
//                DispatchQueue.main.async {
//                    self.jsonData = fetch
//                }
//            }
//            catch{
//                print(error.localizedDescription)
//            }
//        }.resume()
//    }
//
//
//}

//struct dataType: Identifiable,Decodable
//{
//    var id: Int
//    var title: String
//    var full_url: String
//    var description: String
//}


