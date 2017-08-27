//
//  ViewController.swift
//  EstimoteIndoor
//
//  Created by peerapat atawatana on 1/31/2560 BE.
//  Copyright © 2560 socket9. All rights reserved.
//

import UIKit

class ViewController: UIViewController, EILIndoorLocationManagerDelegate {

    // MARK: Property
    
    let locationManager = EILIndoorLocationManager()
    var location: EILLocation!
    
    // MARK: IBOutlet
    
    @IBOutlet weak var locationView: EILIndoorLocationView!
    @IBOutlet weak var logLbl: UILabel!
    
    // MARK: IBAction
    
    @IBAction func didClickOnAction1() {
        
        let locationBuilder = EILLocationBuilder()
        locationBuilder.setLocationBoundaryPoints([
            EILPoint(x: 0, y: 0),
            EILPoint(x: 0, y: 5),
            EILPoint(x: 5, y: 5),
            EILPoint(x: 5, y: 0)
            ])
        locationBuilder.setLocationOrientation(0)
        locationBuilder.setLocationName("TestLocation")
        
        locationBuilder.addBeacon(withIdentifier: "47d6c03f3030ccefd0ee84f10a508b33",
                                  withPosition: EILOrientedPoint(x: 2.5, y: 0, orientation: 0),
                                  andColor: .sweetBeetroot)
        
        locationBuilder.addBeacon(withIdentifier: "0efbc36c95a647a59f6dc953d2c75d35",
                                  withPosition: EILOrientedPoint(x: 0, y: 2.5, orientation: 0),
                                  andColor: .lemonTart)
        
        locationBuilder.addBeacon(withIdentifier: "a000ea2f870a6a660b33fe03b320e029",
                                  withPosition: EILOrientedPoint(x: 2.5, y: 5, orientation: 0),
                                  andColor: .candyFloss)
        
        location = locationBuilder.build()
        print("Build Location: Success")
    }
    
    @IBAction func didClickOnAction2() {
        setupLocationManager()
        setupLocationView()
        drawLocation()
        print("Draw Location: Success")
        startUpdateLocation()
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: Private 
    
    private func setupLocationManager() {
        self.locationManager.delegate = self
        //locationManager.mode = .normal
        print("Current Mode = " + locationManager.mode.rawValue.description)
    }
    
    private func setupLocationView() {
        self.locationView.showTrace = true
        self.locationView.rotateOnPositionUpdate = true
        self.locationView.showWallLengthLabels = true
        self.locationView.traceThickness = 2
        self.locationView.wallLengthLabelsColor = .black
        self.locationView.locationBorderThickness = 4
        // Consult the full list of properties on:
        // http://estimote.github.io/iOS-Indoor-SDK/Classes/EILIndoorLocationView.html
    }
    
    private func drawLocation() {
        self.locationView.drawLocation(location)
    }

    private func startUpdateLocation() {
        self.locationManager.startPositionUpdates(for: self.location)
    }
    
    // MARK: EILIndoorLocationManagerDelegate
    
    func indoorLocationManager(_ manager: EILIndoorLocationManager, didFailToUpdatePositionWithError error: Error) {
        let logError = "failed to update position: \(error)"
        print(logError)
        logLbl.text = logError
    }
    
    func indoorLocationManager(_ manager: EILIndoorLocationManager, didUpdatePosition position: EILOrientedPoint, with positionAccuracy: EILPositionAccuracy, in location: EILLocation) {
        var accuracy: String!
        switch positionAccuracy {
        case .veryHigh: accuracy = "+/- 1.00m"
        case .high:     accuracy = "+/- 1.62m"
        case .medium:   accuracy = "+/- 2.62m"
        case .low:      accuracy = "+/- 4.24m"
        case .veryLow:  accuracy = "+/- ? :-("
        case .unknown:  accuracy = "unknown"
        }
        
        let logPosition = String(format: "x: %5.2f, y: %5.2f, orientation: %3.0f, accuracy: %@", position.x, position.y, position.orientation, accuracy)
        print(logPosition)
        
        logLbl.text = logPosition
        
        self.locationView.updatePosition(position)
    }
}

