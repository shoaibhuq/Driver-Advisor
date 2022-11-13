//
//  TrafficSignRecognitionViewController.swift
//  Road Sign Recognizer
//
//  Created by Jake Spann on 11/12/22.
//

import UIKit
import AVFoundation
import Vision
//import SwiftUI
import ARKit
import RealityKit

class TrafficSignRecognitionViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate, ARSessionDelegate {
    //weak var arView: ARView!
    var bufferSize: CGSize = .zero
    var rootLayer: CALayer! = nil
    //private let session = AVCaptureSession()
    private var previewLayer: AVCaptureVideoPreviewLayer! = nil
    private let videoDataOutput = AVCaptureVideoDataOutput()
    private let videoDataOutputQueue = DispatchQueue(label: "VideoDataOutput", qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem)
    private var requests = [VNRequest]()
    var detectedResults = ScannedResults()
    var speechController = SpeechManger()
    //let drowsyDetector = DrowsyDetector()
    var config = ARWorldTrackingConfiguration()
    let synthesizer = AVSpeechSynthesizer()
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // setupAVCapture()
       // startCaptureSession()
        setupVision()
       // drowsyDetector.beginTracking()
        
        /*let hudVC = UIHostingController(rootView: TrafficSignHUDView(scanResults: detectedResults))
        hudVC.view.translatesAutoresizingMaskIntoConstraints = false
        
        hudVC.view.backgroundColor = .clear
        
        self.addChild(hudVC)
        self.view.addSubview(hudVC.view)
        hudVC.view.frame = trafficSignHUDContainer.frame
        
        NSLayoutConstraint.activate([
            hudVC.view.leadingAnchor.constraint(equalTo: trafficSignHUDContainer.leadingAnchor, constant: 1),
            hudVC.view.trailingAnchor.constraint(equalTo: trafficSignHUDContainer.trailingAnchor, constant: 1),
            hudVC.view.topAnchor.constraint(equalTo: trafficSignHUDContainer.topAnchor, constant: 1),
            hudVC.view.bottomAnchor.constraint(equalTo: trafficSignHUDContainer.bottomAnchor, constant: 1)
            ])
        hudVC.didMove(toParent: self)*/
        
        config.userFaceTrackingEnabled = true
        let session = ARSession()
        print(ARWorldTrackingConfiguration.supportedVideoFormats)
        //config.videoFormat = ARConfiguration.supportedVideoFormats
       // arView.session.run(config)
       // arView.session.delegate = self

        // Do any additional setup after loading the view.
    }
    
    @discardableResult
    func setupVision() -> NSError? {
        // Setup Vision parts
        let error: NSError! = nil
        
        guard let modelURL = Bundle.main.url(forResource: "SignDetection3 1 Iteration 14220", withExtension: "mlmodelc") else {
            return NSError(domain: "VisionObjectRecognitionViewController", code: -1, userInfo: [NSLocalizedDescriptionKey: "Model file is missing"])
        }
        do {
            let visionModel = try VNCoreMLModel(for: MLModel(contentsOf: modelURL))
            let objectRecognition = VNCoreMLRequest(model: visionModel, completionHandler: { (request, error) in
                DispatchQueue.main.async(execute: {
                    // perform all the UI updates on the main queue
                    if let results = request.results {
                        self.drawVisionRequestResults(results)
                    }
                })
            })
            self.requests = [objectRecognition]
        } catch let error as NSError {
            print("Model loading went wrong: \(error)")
        }
        
        return error
    }
    
    func drawVisionRequestResults(_ results: [Any]) {
        //detectionOverlay.sublayers = nil // remove all the old recognized objects
        for observation in results where observation is VNRecognizedObjectObservation {
            guard let objectObservation = observation as? VNRecognizedObjectObservation else {
                continue
            }
            // Select only the label with the highest confidence.
            let topLabelObservation = objectObservation.labels[0]
            let objectBounds = VNImageRectForNormalizedRect(objectObservation.boundingBox, Int(bufferSize.width), Int(bufferSize.height))
            
            print(topLabelObservation.identifier)
            switch topLabelObservation.identifier {
            case "W11-2":
                if detectedResults.currentSign != .pedestrianCrossing {
                    detectedResults.currentSign = .pedestrianCrossing
                    speechController.speak(text: "Caution, pedestrian crossing ahead", urgency: .warning)
                }
            case "R1-1":
                if detectedResults.currentSign != .stopSign {
                    detectedResults.currentSign = .stopSign
                    speechController.speak(text: "Stop sign ahead", urgency: .warning)
                }
            case "R5-1":
                if detectedResults.currentSign != .doNotEnter {
                    detectedResults.currentSign = .doNotEnter
                    speechController.speak(text: "Do not enter", urgency: .informative)
                }
            case "R1-2":
                if detectedResults.currentSign != .yield {
                    detectedResults.currentSign = .yield
                    speechController.speak(text: "Caution, yield to oncoming traffic", urgency: .warning)
                }
            default:
                print(topLabelObservation.identifier)
            }
            /*if topLabelObservation.identifier == "W11-2" {
                print("FOUND SIgn!")
                detectedResults.signName = "Ped cross"
                detectedResults.currentSign = .pedestrianCrossing
                detectedResults.objectWillChange.send()
                print(detectedResults.signName)
            }*/
            
           // let shapeLayer = self.createRoundedRectLayerWithBounds(objectBounds)
            
          /*  let textLayer = self.createTextSubLayerInBounds(objectBounds,
                                                            identifier: topLabelObservation.identifier,
                                                            confidence: topLabelObservation.confidence)*/
           // shapeLayer.addSublayer(textLayer)
           // detectionOverlay.addSublayer(shapeLayer)
        }
        //self.updateLayerGeometry()
     //   CATransaction.commit()
    }
    
    func setupAVCapture() {
        /*
        var deviceInput: AVCaptureDeviceInput!
        
        // Select a video device, make an input
        let videoDevice = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .back).devices.first
        do {
            deviceInput = try AVCaptureDeviceInput(device: videoDevice!)
        } catch {
            print("Could not create video device input: \(error)")
            return
        }
        
        session.beginConfiguration()
        session.sessionPreset = .vga640x480 // Model image size is smaller.
        
        // Add a video input
        guard session.canAddInput(deviceInput) else {
            print("Could not add video device input to the session")
            session.commitConfiguration()
            return
        }
        session.addInput(deviceInput)
        if session.canAddOutput(videoDataOutput) {
            session.addOutput(videoDataOutput)
            // Add a video data output
            videoDataOutput.alwaysDiscardsLateVideoFrames = true
            videoDataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)]
            videoDataOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
        } else {
            print("Could not add video data output to the session")
            session.commitConfiguration()
            return
        }
        let captureConnection = videoDataOutput.connection(with: .video)
        // Always process the frames
        captureConnection?.isEnabled = true
        do {
            try  videoDevice!.lockForConfiguration()
            let dimensions = CMVideoFormatDescriptionGetDimensions((videoDevice?.activeFormat.formatDescription)!)
            bufferSize.width = CGFloat(dimensions.width)
            bufferSize.height = CGFloat(dimensions.height)
            videoDevice!.unlockForConfiguration()
        } catch {
            print(error)
        }
        session.commitConfiguration()
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        rootLayer = cameraFeedView.layer
        previewLayer.frame = rootLayer.bounds
        rootLayer.addSublayer(previewLayer)*/
    }
    
    func startCaptureSession() {
       // session.startRunning()
    }
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
       /* guard let pixelBuffer = frame.capturedImage else {
            return
        }*/
        //print("GOT FRAME")
        let exifOrientation = exifOrientationFromDeviceOrientation()
        
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: frame.capturedImage, orientation: exifOrientation, options: [:])
        do {
            try imageRequestHandler.perform(self.requests)
        } catch {
            print(error)
        }
        
        let requestHandler = VNImageRequestHandler(cvPixelBuffer: frame.capturedImage)

        // Create a new request to recognize text.
        let request = VNRecognizeTextRequest(completionHandler: recognizeTextHandler)
        request.recognitionLevel = .fast

        do {
            // Perform the text-recognition request.
         //   try requestHandler.perform([request])
        } catch {
            print("Unable to perform the requests: \(error).")
        }
    }
    
    func recognizeTextHandler(request: VNRequest, error: Error?) {
        guard let observations =
                request.results as? [VNRecognizedTextObservation] else {
            return
        }
        let recognizedStrings = observations.compactMap { observation in
            // Return the string of the top VNRecognizedText instance.
            return observation.topCandidates(1).first?.string
        }
        
        // Process the recognized strings.
        //processResults(recognizedStrings)
        print(recognizedStrings)
    }
    
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        for anchor in anchors {
            guard let faceAnchor = anchor as? ARFaceAnchor else { return }
            let left = faceAnchor.blendShapes[.eyeBlinkLeft]
            let right = faceAnchor.blendShapes[.eyeBlinkRight]
            //print(left?.doubleValue)
            //print(right?.doubleValue)
            if timer == nil && ((left?.doubleValue ?? 0.0 >= 0.8) || (right?.doubleValue ?? 0.0 >= 0.8)) {
                timer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false, block: {timer in
                    print("timer expired!!")
                    //self.makeWarning()
                    self.speechController.speak(text: "Drowsiness Detected", urgency: .hazard)
                    //session.pause()
                })
               // RunLoop.current.add(timer!, forMode: RunLoop.Mode.common)
            } else if (timer != nil) && (left?.doubleValue ?? 1.0 <= 0.8) && (right?.doubleValue ?? 1.0 <= 0.8) {
                timer?.invalidate()
                timer = nil
            }
            
        }
    }
    
    /*
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        
        let exifOrientation = exifOrientationFromDeviceOrientation()
        
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: exifOrientation, options: [:])
        do {
            try imageRequestHandler.perform(self.requests)
        } catch {
            print(error)
        }
    }
     */
    
    public func exifOrientationFromDeviceOrientation() -> CGImagePropertyOrientation {
        let curDeviceOrientation = UIDevice.current.orientation
        let exifOrientation: CGImagePropertyOrientation
        
        switch curDeviceOrientation {
        case UIDeviceOrientation.portraitUpsideDown:  // Device oriented vertically, home button on the top
            exifOrientation = .left
        case UIDeviceOrientation.landscapeLeft:       // Device oriented horizontally, home button on the right
            exifOrientation = .upMirrored
        case UIDeviceOrientation.landscapeRight:      // Device oriented horizontally, home button on the left
            exifOrientation = .down
        case UIDeviceOrientation.portrait:            // Device oriented vertically, home button on the bottom
            exifOrientation = .up
        default:
            exifOrientation = .up
        }
        return exifOrientation
    }
}

enum SignType: String {
    case pedestrianCrossing = "Pedestrian Crossing"
    case stopSign = "Stop Sign"
    case doNotEnter = "Do Not Enter"
    case yield = "Yield"
    case spdlmt40 = "Speed Limit 40"
    case speedLimit25 = "Speed Limit 25"
    case noUTurn = "No U-Turn"
    case oneWay = "One Way"
}

enum SignClass {
    case warning
}

class ScannedResults: ObservableObject, Equatable {
    static func == (lhs: ScannedResults, rhs: ScannedResults) -> Bool {
        return lhs.currentSign == rhs.currentSign
    }
    
    @Published var currentSign: SignType?
    @Published var signName: String?
    @Published var signGlass : SignClass?
}

