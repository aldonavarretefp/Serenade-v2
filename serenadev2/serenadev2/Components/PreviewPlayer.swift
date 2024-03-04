//
//  PreviewPlayer.swift
//  serenadev2
//
//  Created by Alejandro Oliva Ochoa on 29/02/24.
//

import SwiftUI
import AVFoundation

struct PreviewPlayer: View {
    
    var player: AVPlayer!
    
    init(mainColor: Color, audioURL: URL, fontColor: Color, secondaryColor: Color, seconds: Double = 15.0) {
        self.mainColor = mainColor
        self.audioURL = audioURL
        self.fontColor = fontColor
        self.secondaryColor = secondaryColor
        self.endTime = calculateEndTime(tiempo: seconds)
        
        // Player created with the passed url (each song preview url)
        self.player = AVPlayer(url: audioURL)
        
        // Adjust the volume 50% less
        self.player.volume = 0.5
        // This audio session configuration must be done before starting audio playback
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Error setting up audio session: \(error.localizedDescription)")
        }
    }
    
    //Variable to track playback status
    @State private var isPlaying = false
    var mainColor: Color
    var audioURL: URL
    var fontColor: Color
    var secondaryColor: Color
    @State private var miliseconds: Double = 0
    
    @State private var timer: Timer? = nil
    
    // Initial time of the song
    var initialTime: CMTime = CMTime(seconds: 0, preferredTimescale: 1)
    
    // When the song ends (max 30 seconds)
    var endTime: CMTime = CMTime(seconds: 15, preferredTimescale: 1)
    
    // Variable to store the current playback position
    @State private var currentPlaybackTime: CMTime = .zero
    
    var body: some View {
        // Button to play/pause audio
        VStack(spacing: 5){
            
            Text(isPlaying ? LocalizedStringKey("TapToPausePreview") :LocalizedStringKey("TapToPlayPreview"))
                .font(.caption)
                .foregroundStyle(.white.opacity(0.7))
            
            ZStack{
                // Image to show the lines at the device width
                Image("player-lines-full")
                
                ZStack{
                    // Image to show the middle lines
                    Image("player-lines-middle")
                        .background(
                            ZStack(alignment: .leading){
                                // Rectangle used as background
                                secondaryColor
                                    .opacity(0.1)
                                
                                // Fill the rectanble background depending on the time of the song
                                secondaryColor.adjustedForContrast()
                                    .frame(width: CGFloat(miliseconds) / CGFloat(endTime.seconds) * 20)
                                
                            }
                        )
                        .shadow(color: .black.opacity(0.13), radius: 25, x: 0, y: 8)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    // Play / pause icon
                    Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .font(.largeTitle)
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(secondaryColor.adjustedForContrast(), .white)
                }
                .onTapGesture {
                    if self.isPlaying {
                        self.player.pause()
                        
                    } else {
                        self.startTimer()
                        self.player.play()
                        
                    }
                    withAnimation{
                        self.isPlaying.toggle()
                    }
                }
            }
        }
        // Detecta cambios en scenePhase
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
            // Almacenar la posición de reproducción actual
            self.currentPlaybackTime = self.player.currentTime()
            self.isPlaying = false
            self.player.pause()
            self.stopTimer()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
            // Reanudar la reproducción desde la posición almacenada
            self.player.seek(to: self.currentPlaybackTime)
            self.startTimer()
            self.player.play()
            self.isPlaying = true
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
                    if self.miliseconds < (endTime.seconds * 10) {
                        // increase seconds with animation
                        withAnimation{
                            self.miliseconds += 1
                        }
                    } else {
                        // Restart playback from the beginning
                        player.seek(to: CMTime.zero)
                        self.isPlaying = false
                        self.stopTimer()
                        self.player.pause()
                        withAnimation{
                            miliseconds = 0
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
    PreviewPlayer(mainColor: Color(hex: 0x202020), audioURL: URL(string: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview115/v4/38/be/54/38be54d8-7411-fe31-e15f-c85e7d8515e8/mzaf_15200620892322734212.plus.aac.p.m4a")!, fontColor: Color(hex: 0x000000), secondaryColor: Color(hex: 0x111111), seconds: 5)
}
