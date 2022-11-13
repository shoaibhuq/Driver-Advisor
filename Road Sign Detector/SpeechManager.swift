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
        var speakText = text
        
        var lang = "en-US"
        let langSetting = UserDefaults().string(forKey: "language")
        if langSetting == "Spanish" {
            lang = "es-MX"
        } else if langSetting == "Chinese" {
            lang = "zh-CN"
        }
        
         if let newText = (StringTable.englishStrings[text]?[lang]) {
            speakText = newText
        }
        
           do {
               try AVAudioSession.sharedInstance().setCategory(.playback,mode: .default)

           } catch let error {
               print("This error message from SpeechSynthesizer \(error.localizedDescription)")
           }
           
        if !synthesizer.isSpeaking {
            let utterance = AVSpeechUtterance(string: speakText)
            
            switch urgency {
            case .warning:
                utterance.rate = 0.54
            case .hazard:
                utterance.rate = 0.55
            default:
                break;
            }
            // utterance.rate = 0.57
            utterance.pitchMultiplier = 0.8
            utterance.postUtteranceDelay = 0.2
            utterance.volume = 0.8
            
            // Retrieve the US English voice.
            let voice = AVSpeechSynthesisVoice(language: lang)
            
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

struct StringTable {
    static let englishStrings: [String: [String: String]] = ["Please be sure to keep your attention on the road":["es-MX":"Por favor, asegúrese de mantener su atención en la carretera", "zh-CN":"请务必注意路上"],
        "Caution, pedestrian crossing ahead":["es-MX":"Precaución, paso de peatones adelante", "zh-CN":"小心，前方人行横道"],
        "Do not enter": ["es-MX":"No entrar", "zh-CN":"不许进入"],
        "Caution, yield to other traffic":["es-MX":"Precaución, ceder el paso al resto del tráfico", "zh-CN":"小心，让给其他流量"],
        "Speed limit 25 miles per hour":["es-MX":"Límite de velocidad 25 millas por hora", "zh-CN":"限速 25 英里/小时"],
        "Speed limit 40 miles per hour":["es-MX":"Límite de velocidad 40 millas por hora", "zh-CN":"限速40英里/小时"],
        "No U-Turn ahead":["es-MX":"No hay vuelta en U por delante","zh-CN":"前面不能掉头"],
        "One Way road":["es-MX":"Calle de un único sentido", "zh-CN":"《一条路》"],
        "Traffic light ahead":["es-MX":"Semáforo adelante", "zh-CN":"前方的红绿灯"],
        "Stop sign ahead":["es-MX":"Señal de alto más adelante", "zh-CN":"提前停止标志"],
        "Stop sign":["es-MX":"señal de stop", "zh-CN":"停止标志"]
    ]
}
