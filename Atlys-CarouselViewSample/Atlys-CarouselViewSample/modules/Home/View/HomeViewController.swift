//
//  HomeViewController.swift
//  CarouselViewSample
//
//  Created by Tushar Gupta on 22/09/24.
//

import UIKit

class HomeViewController: UIViewController {
    
    private let images: [String] = ["image1", "image2", "image3", "image4"]
    private var carouselView: CarouselView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCarouselView()
    }
}

// MARK: - Private Methods
private extension HomeViewController {
    
    func setupCarouselView() {
        carouselView = CarouselView(frame: CGRect.init(x: 0, y: 100, width: view.bounds.width, height: 250), images: images)
        view.addSubview(carouselView)
    }
}
