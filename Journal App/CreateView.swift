//
//  CreateView.swift
//  Journal App
//
//  Created by Ghada Alsubaie on 25/04/1446 AH.
//

import SwiftUI

struct CreateView: View {
    
    @Environment(.\dismiss) var dismiss
    
    var body: some view {
        List {
            TextField("title", text: .constant(""))
            
        }
    }
