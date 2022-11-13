//
//  SpeechManager.swift
//  Road Sign Recognizer
//
//  Created by Jake Spann on 11/13/22.
//

import Foundation
import AVFAudio

class SpeechManger {
    let synthesizer = AVSpeechSynthesizer()
    
    func speak(text: String, urgency: SpeechUrgency, language: String = "en-US") {
           do {
               try AVAudioSession.sharedInstance().setCategory(.playback,mode: .default)

           } catch let error {
               print("This error message from SpeechSynthesizer \(error.localizedDescription)")
           }
           
        if !synthesizer.isSpeaking {
            let utterance = AVSpeechUtterance(string: text)
            
            switch urgency {
            case .warning:
                utterance.rate = 0.55
            case .hazard:
                utterance.rate = 0.56
            default:
                break;
            }
            // utterance.rate = 0.57
            utterance.pitchMultiplier = 0.8
            utterance.postUtteranceDelay = 0.2
            utterance.volume = 0.8
            
            // Retrieve the US English voice.
            let voice = AVSpeechSynthesisVoice(language: language)
            
            // Assign the voice to the utterance.
            utterance.voice = voice
            
            // Tell the synthesizer to speak the utterance.
            synthesizer.speak(utterance)
        }
    }
    
    enum SpeechUrgency {
        case informative
        case warning
        case hazard
    }
}
