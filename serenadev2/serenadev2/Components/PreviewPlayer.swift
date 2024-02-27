//
//  PreviewPlayer.swift
//  prueba
//
//  Created by Alejandro Oliva Ochoa on 21/02/24.
//

import SwiftUI
import AVKit

struct PreviewPlayer: View {
    
    // MARK: - Init
    init(mainColor: Color, audioURL: URL, seconds: Double = 15.0) {
        self.mainColor = mainColor
        self.audioURL = audioURL
        
        self.endTime = calculateEndTime(tiempo: seconds)
    }
    
    // MARK: - Properties
    // AVPlayer to play the audio
    let player = AVPlayer()
    
    //Variable to track playback status
    @State private var isPlaying = false
    var mainColor: Color
    var audioURL: URL
    @State private var seconds: Double = 0
    @State private var timer: Timer? = nil
    
    // Initial time of the song
    var initialTime: CMTime = CMTime(seconds: 0, preferredTimescale: 1)
    
    // When the song ends (max 30 seconds)
    var endTime: CMTime = CMTime(seconds: 15, preferredTimescale: 1)
    
    // MARK: - Body
    var body: some View {
        // Button to play/pause audio
        VStack{
            ZStack{
                
                // Image to show the lines at the device width
                Image("player-lines-full")
                
                ZStack{
                    // Image to show the middle lines
                    Image("player-lines-middle")
                        .background(
                            ZStack(alignment: .leading){
                                // Rectangle used as background
                                mainColor.adjustedForContrast()
                                    .opacity(0.2)
                                
                                // Fill the rectanble background depending on the time of the song
                                mainColor.adjustedForContrast()
                                    .frame(width: CGFloat(seconds) / CGFloat(endTime.seconds) * 20)
                                
                            }
                        )
                        .shadow(color: .black.opacity(0.13), radius: 25, x: 0, y: 8)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    // Play / pause icon
                    Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .font(.largeTitle)
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(mainColor.adjustedForContrast(), .white)
                }
                .onTapGesture {
                    if self.isPlaying {
                        self.player.pause()
                        
                    } else {
                        self.startTimer()
                        self.player.play()
                        
                    }
                    self.isPlaying.toggle()
                }
                
            }
            
        }
        .onAppear {
            
            // This audio session configuration must be done before starting audio playback
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                try AVAudioSession.sharedInstance().setActive(true)
            } catch {
                print("Error setting up audio session: \(error.localizedDescription)")
            }
            
            // Configure the AVPlayer with the audio URL
            let playerItem = AVPlayerItem(url: self.audioURL)
            playerItem.seek(to: initialTime, completionHandler: nil)
            playerItem.forwardPlaybackEndTime = endTime
            self.player.replaceCurrentItem(with: playerItem)
        }
        .onDisappear {
            // Reset the timer and the song when the view disappears
            player.pause()
            player.seek(to: CMTime.zero)
            stopTimer()
        }
    }
    
    // Function to start the timer
    func startTimer() {
        if timer == nil {
            self.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                if self.isPlaying {
                    if self.seconds < (endTime.seconds * 10) {
                        // increase seconds with animation
                        withAnimation{
                            self.seconds += 1
                        }
                    } else {
                        // Restart playback from the beginning
                        player.seek(to: self.initialTime, toleranceBefore: .zero, toleranceAfter: .zero) { _ in
                            seconds = 0
                            self.isPlaying = false
                            self.stopTimer()
                            self.player.pause()
                        }
                    }
                }
            }
        }
    }
    
    // Function to stop the timer
    func stopTimer() {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    // Function to return the miliseconds of the given seconds as parameter
    func calculateEndTime(tiempo: Double) -> CMTime {
        let endTime: CMTime = CMTime(seconds: tiempo, preferredTimescale: 1)
        return endTime
    }
}

#Preview {
    PreviewPlayer(mainColor: Color(hex: 0x202020), audioURL: URL(string: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview115/v4/38/be/54/38be54d8-7411-fe31-e15f-c85e7d8515e8/mzaf_15200620892322734212.plus.aac.p.m4a")!, seconds: 15.0)
}
