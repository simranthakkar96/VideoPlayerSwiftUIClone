//
//  ContentView.swift
//  VideoPlayerSwiftUI
//
//  Created by Michael Gauthier on 2021-01-06.
//


import SwiftUI
import AVKit
import Alamofire
import SwiftyJSON

//View for the Video and Description in vertical stack
struct ContentView: View {
    //Variables intialized
    @State var player = AVPlayer(url:URL(string: "https://d140vvwqovffrf.cloudfront.net/media/5e852de33c8e4/hls/index.m3u8")!)
    
    @State var playing = false
    @State var showcontrols = false
    @ObservedObject var observed = values()
    
    var body: some View {
        VStack{
            // The controls are define in zstack as we need to mount the controls on video
            ZStack{
                VideoPlayer(player: $player)
                if self.showcontrols{
                    Controls(player: self.$player, playing: self.$playing, showcontrols: self.$showcontrols)
                }
            }
            .frame(height: UIScreen.main.bounds.height/3.5)
            .onTapGesture {
                self.showcontrols = true
            }
            
            //Gemorty reader is used to chanhge the size and alignment of the text
            GeometryReader{geometry in
                VStack(){
                    ScrollView(.vertical){
                        // called the data from json array using the observed instance
                        Text(observed.jsondata.description).foregroundColor(.white)
                            
                   
                    }.frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
            }
            }
            
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        //below at first its made false so the user will get pause at first run of the application
        .onAppear(){
            self.playing = false
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//Controls in the video are intiated and its functionalities are added
struct Controls : View{
    
    @Binding var player : AVPlayer
    @Binding var playing : Bool
    @Binding var showcontrols : Bool
    var body : some View{
        VStack{
            Spacer()
            HStack{
                Button(action: {
                    
                }){
                    Image(uiImage: UIImage(named: "previous")!).font(.title)
                        .foregroundColor(.white)
                        .padding(20)
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
                }){
                    Image(uiImage: UIImage(named: self.playing ? "pause": "play")!).font(.title)
                        .foregroundColor(.white)
                        .padding(20)
                }
                Spacer()
                Button(action: {
                    
                }){
                    Image(uiImage: UIImage(named: "next")!).font(.title)
                        .foregroundColor(.white)
                        .padding(20)
                }
            }
            Spacer()
            
        }.padding()
        .background(Color.black.opacity(0.4))
        .onTapGesture {
            self.showcontrols = false
        }
    }
}

//Video Player Controller
struct VideoPlayer : UIViewControllerRepresentable {
    
    @Binding var player : AVPlayer
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<VideoPlayer>) -> AVPlayerViewController {
        
        let controller = AVPlayerViewController()
        controller.player = player
        controller.showsPlaybackControls = false
        controller.videoGravity = .resize
        return controller
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: UIViewControllerRepresentableContext<VideoPlayer>) {
        
        
    }
}

// Connecting to the server using JSON Parsing and then appending the data to the initvalues struct created below
class values: ObservableObject{
    @Published var jsondata = [initvalues]()
    init(){
        Alamofire.request("http://localhost:4000/videos").responseData{
            (data) in
            let json = try! JSON(data:data.data!)
            for i in json{
                self.jsondata.append(initvalues(id: i.1["id"].intValue, title: i.1["title"].stringValue, description: i.1["description"].stringValue, hlsURL: i.1["hlsURL"].stringValue))
            }
        }
    }
}
struct initvalues: Identifiable, Decodable{
    var id: Int
    var title: String
    var description: String
    var hlsURL: String
}


