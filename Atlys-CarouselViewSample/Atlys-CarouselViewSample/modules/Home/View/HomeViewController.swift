//
//  HomeViewController.swift
//  Atlys-CarouselViewSample
//
//  Created by Tushar Gupta on 22/09/24.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet private weak var carouselContainerView: UIView!
    
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
        carouselView = CarouselView(frame: carouselContainerView.bounds, images: images)
        carouselContainerView.addSubview(carouselView)
    }
}
