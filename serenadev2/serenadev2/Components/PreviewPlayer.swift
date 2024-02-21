//
//  PreviewPlayer.swift
//  prueba
//
//  Created by Alejandro Oliva Ochoa on 21/02/24.
//

import SwiftUI
import AVKit

struct PreviewPlayer: View {
    
    init(mainColor: Color, audioURL: URL, seconds: Double = 15.0) {
        self.mainColor = mainColor
        self.audioURL = audioURL
        
        self.endTime = calculateEndTime(tiempo: seconds)
    }
    
    // Variable para rastrear el estado de reproducción
    @State private var isPlaying = false
    
    // AVPlayer para reproducir el audio
    let player = AVPlayer()
    
    // Cual es el main color del artwork
    var mainColor: Color
    
    // URL del audio
    var audioURL: URL
    
    // Cuando termina la cancion (max 30 segundos)
    var endTime: CMTime = CMTime(seconds: 15, preferredTimescale: 1)
    
    // Tiempo inicial y final de reproducción
    var initialTime: CMTime = CMTime(seconds: 0, preferredTimescale: 1)
    
    
    @State private var seconds: Double = 0
    @State private var timer: Timer? = nil
    
    var body: some View {
        // Botón para reproducir/pausar el audio
        VStack{
//            Text(isPlaying ? "Tap to pause preview" : "Tap to play preview")
//                .font(.footnote)
//                .fontWeight(.medium)
//                .foregroundStyle(.white.opacity(0.5))
            
            ZStack{
                
                Image("player-lines-full")
                
                Button{
                    
                    if self.isPlaying {
                        self.player.pause()
                        
                    } else {
                        self.startTimer()
                        self.player.play()
                        
                    }
                    self.isPlaying.toggle()
                    
                } label: {
                    
                    ZStack{
                        Image("player-lines-middle")
                            .background(
                                ZStack(alignment: .leading){
                                    mainColor.adjustedForContrast()
                                        .opacity(0.2)
                                    
                                    // Fill the background depending on the time of the song
                                    mainColor.adjustedForContrast()
                                        .frame(width: CGFloat(seconds) / CGFloat(endTime.seconds) * 20)
                                    
                                }
                            )
                            .shadow(color: .black.opacity(0.13), radius: 25, x: 0, y: 8)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                        Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                            .font(.largeTitle)
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(mainColor.adjustedForContrast(), .white)
                    }
                }
            }
            .buttonStyle(.plain)
        }
        .onAppear {
            
            // Esta configuración de la sesión de audio debe realizarse antes de iniciar la reproducción del audio.
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                try AVAudioSession.sharedInstance().setActive(true)
            } catch {
                print("Error al configurar la sesión de audio: \(error.localizedDescription)")
            }
            
            // Configurar el AVPlayer con la URL del audio
            let playerItem = AVPlayerItem(url: self.audioURL)
            playerItem.seek(to: initialTime, completionHandler: nil)
            playerItem.forwardPlaybackEndTime = endTime
            self.player.replaceCurrentItem(with: playerItem)
        }
    }
    
    func startTimer() {
        if timer == nil {
            self.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                if self.isPlaying {
                    if self.seconds < (endTime.seconds * 10) {
                        withAnimation{
                            self.seconds += 1
                        }
                    } else {
                        // Reiniciar la reproducción desde el inicio
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
    
    func stopTimer() {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    func calculateEndTime(tiempo: Double) -> CMTime {
        let endTime: CMTime = CMTime(seconds: tiempo, preferredTimescale: 1)
        return endTime
    }
}

#Preview {
    PreviewPlayer(mainColor: Color(hex: 0x202020), audioURL: URL(string: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview115/v4/38/be/54/38be54d8-7411-fe31-e15f-c85e7d8515e8/mzaf_15200620892322734212.plus.aac.p.m4a")!, seconds: 15.0)
}
