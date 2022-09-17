//
//  ImageView.swift
//  shoppr
//
//  Created by Brandon Wong on 7/6/22.
//

import UIKit
import SwiftUI
import AVFoundation
import Vision

public protocol UIScanningViewControllerDelegate : AnyObject {
    func getPrice(_ price: String?)
}

struct ImageView: UIViewControllerRepresentable {
    @Binding var price: String
    @Environment(\.presentationMode) private var presentationMode
    
    func makeUIViewController(context: Context) -> UIViewController {
        let storyboard = UIStoryboard(name: "Scanner", bundle: nil)
        let controller = storyboard.instantiateViewController(identifier: "VisionViewController")
        if let vc = controller as? VisionViewController {
            vc.delegate = context.coordinator
        }
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIScanningViewControllerDelegate {
        var parent: ImageView

        init (_ imageView: ImageView) {
            parent = imageView
        }
        
        func getPrice(_ price: String?) {
            self.parent.presentationMode.wrappedValue.dismiss()
            if let unwrappedPrice = price {
                self.parent.price = unwrappedPrice
            }
        }
    }
}
