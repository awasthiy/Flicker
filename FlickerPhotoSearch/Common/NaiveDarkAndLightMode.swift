//
//  NaiveDarkAndLightMode.swift
//  FlickerPhotoSearch
//
//  Created by Yash Awasthi on 26/06/2020.
//  Copyright © 2020 Yash Awasthi. All rights reserved.
//

import UIKit


public let SelectedModeKey = Constants.kSelectedMode

enum Mode : Int {
    
    case Light
    case Dark
    
    var background : UIColor {
        switch self {
        case .Light     : return #colorLiteral(red: 0.9763647914, green: 0.9765316844, blue: 0.9763541818, alpha: 1)
        case .Dark      : return #colorLiteral(red: 0.2391854823, green: 0.2392330766, blue: 0.2391824722, alpha: 1)
        }
    }
    
    var darkGrey: UIColor {
        switch self {
        case .Light     : return #colorLiteral(red: 0.2666666667, green: 0.2666666667, blue: 0.2666666667, alpha: 1)
        case .Dark      : return #colorLiteral(red: 0.866572082, green: 0.8667211533, blue: 0.8665626645, alpha: 1)
        }
    }
    
    var grey: UIColor {
        switch self {
        case .Light     : return #colorLiteral(red: 0.4666131139, green: 0.4666974545, blue: 0.4666077495, alpha: 1)
        case .Dark      : return #colorLiteral(red: 0.866572082, green: 0.8667211533, blue: 0.8665626645, alpha: 1)
        }
    }
    
    var fillColor : UIColor {
        switch self {
        case .Light     : return #colorLiteral(red: 0.9998916984, green: 1, blue: 0.9998809695, alpha: 1)
        case .Dark      : return #colorLiteral(red: 0.1646832824, green: 0.1647188365, blue: 0.1646810472, alpha: 1)
        }
    }
    
    var shadow : UIColor {
        switch self {
        case .Light     : return #colorLiteral(red: 0.8196078431, green: 0.8196078431, blue: 0.8196078431, alpha: 1)
        case .Dark      : return #colorLiteral(red: 0.4950980392, green: 0.5, blue: 0.5, alpha: 1)
        }
    }
    
    var keyBoardAppearance : UIKeyboardAppearance {
        switch self {
        case .Light: return .light
        case .Dark: return .dark
        }
    }
    var barStyle : UIBarStyle {
        switch self {
        case .Light: return .default
        case .Dark: return .black
        }
    }
}


class NaiveDarkAndLightMode {
    
    static func current() -> Mode {
        if let storedMode = UserDefaults.standard.value(forKey: SelectedModeKey) as? Int {
            return Mode(rawValue: storedMode)!
        }else{
            return .Light
        }
    }
    
    static func applyMode(mode : Mode){
        UserDefaults.standard.set(mode.rawValue, forKey: SelectedModeKey)
        UITextField.appearance().keyboardAppearance = mode.keyBoardAppearance
        UINavigationBar.appearance().barTintColor = mode.fillColor
        UINavigationBar.appearance().tintColor = #colorLiteral(red: 0.07868818194, green: 0.6650877595, blue: 0.992734015, alpha: 1)
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : mode.darkGrey]
    }
}

