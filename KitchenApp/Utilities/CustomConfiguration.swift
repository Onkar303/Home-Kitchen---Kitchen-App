//
//  CustomConfiguration.swift
//  KitchenApp
//
//  Created by Techlocker on 1/11/20.
//

import Foundation
import UIKit

extension UIImageView{
    
    
    
    func setRounded(){
        
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.width/2
        
    }
    
    
}
