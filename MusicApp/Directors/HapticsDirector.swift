//
//  HapticsDirector.swift
//  MusicApp
//
//  Created by muhammed dursun on 2.05.2024.
//

import UIKit

final class HapticsDirector{
    
    // MARK: - Properties
    
    static let shared = HapticsDirector()
    private init() {}
    
    // MARK: - Assistants
    
    public func vibrateForSelection(){
        
        DispatchQueue.main.async {
            let generator = UISelectionFeedbackGenerator()
            generator.prepare()
            generator.selectionChanged()
        }
    }
    
    public func vibrate(type: UINotificationFeedbackGenerator.FeedbackType){
        
        DispatchQueue.main.async {
            let generator = UINotificationFeedbackGenerator()
            generator.prepare()
            generator.notificationOccurred(type)
        }
    }
    
}
