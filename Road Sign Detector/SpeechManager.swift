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
    static let englishStrings: [String: [String: String]] = ["Please be sure to keep your attention on the road":["es-MX":"Por favor, aseg??rese de mantener su atenci??n en la carretera", "zh-CN":"?????????????????????"],
        "Caution, pedestrian crossing ahead":["es-MX":"Precauci??n, paso de peatones adelante", "zh-CN":"???????????????????????????"],
        "Do not enter": ["es-MX":"No entrar", "zh-CN":"????????????"],
        "Caution, yield to other traffic":["es-MX":"Precauci??n, ceder el paso al resto del tr??fico", "zh-CN":"???????????????????????????"],
        "Speed limit 25 miles per hour":["es-MX":"L??mite de velocidad 25 millas por hora", "zh-CN":"?????? 25 ??????/??????"],
        "Speed limit 40 miles per hour":["es-MX":"L??mite de velocidad 40 millas por hora", "zh-CN":"??????40??????/??????"],
        "No U-Turn ahead":["es-MX":"No hay vuelta en U por delante","zh-CN":"??????????????????"],
        "One Way road":["es-MX":"Calle de un ??nico sentido", "zh-CN":"???????????????"],
        "Traffic light ahead":["es-MX":"Sem??foro adelante", "zh-CN":"??????????????????"],
        "Stop sign ahead":["es-MX":"Se??al de alto m??s adelante", "zh-CN":"??????????????????"],
        "Stop sign":["es-MX":"se??al de stop", "zh-CN":"????????????"]
    ]
}
