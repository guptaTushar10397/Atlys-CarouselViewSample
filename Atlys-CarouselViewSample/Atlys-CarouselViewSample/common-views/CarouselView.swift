//
//  CarouselView.swift
//  Atlys-CarouselViewSample
//
//  Created by Tushar Gupta on 22/09/24.
//

import UIKit

class CarouselView: UIView {
    private var images: [String] = []
    private var scrollView = UIScrollView()
    private var pageControl = UIPageControl()
    private var currentPageIndex: Int = 0
    
    init(frame: CGRect, images: [String]) {
        self.images = images
        super.init(frame: frame)
        setupPageControl()
        setupScrollView()
        setupContent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UIScrollViewDelegate
extension CarouselView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateCardScaling()
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if velocity.x > 0 {
            currentPageIndex = min(currentPageIndex + 1, images.count - 1)
        } else if velocity.x < 0 {
            currentPageIndex = max(currentPageIndex - 1, 0)
        }
        else {
            let centerX = scrollView.center.x + scrollView.contentOffset.x
            scrollView.subviews.forEach { cardView in
                let distanceFromCenter = centerX - cardView.center.x
                let thresholdDistance = cardSize / 2
                
                if abs(distanceFromCenter) <= thresholdDistance {
                    currentPageIndex = Int(floor(centerX / cardSize))
                }
            }
        }

        let newOffsetX = CGFloat(currentPageIndex) * cardSize - (frame.width - cardSize) / 2
        targetContentOffset.pointee = CGPoint(x: newOffsetX, y: targetContentOffset.pointee.y)
        pageControl.currentPage = currentPageIndex
    }
}

// MARK: - Private Methods
private extension CarouselView {
    
    var cardSize: CGFloat {
        return self.bounds.height - 70 // page pageControl + scaling effect
    }
    
    func setupScrollView() {
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = false
        scrollView.decelerationRate = .fast
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentInset = UIEdgeInsets(top: 0, left: cardSize, bottom: 0, right: cardSize)
        addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: pageControl.topAnchor)
        ])
    }
    
    func setupPageControl() {
        pageControl.numberOfPages = images.count
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .lightGray.withAlphaComponent(0.8)
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.hidesForSinglePage = true
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        addSubview(pageControl)
        
        NSLayoutConstraint.activate([
            pageControl.leadingAnchor.constraint(equalTo: leadingAnchor),
            pageControl.trailingAnchor.constraint(equalTo: trailingAnchor),
            pageControl.bottomAnchor.constraint(equalTo: bottomAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    func setInitialContentOffset() {
        let initialCardIndex = images.count / 2
        let initialOffset = CGFloat(initialCardIndex) * cardSize - (frame.width - cardSize) / 2
        scrollView.contentOffset = CGPoint(x: initialOffset, y: 0)
        currentPageIndex = initialCardIndex
        pageControl.currentPage = currentPageIndex
        updateCardScaling()
    }
    
    func createCardView(with imageName: String) -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: imageName)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        return imageView
    }
    
    func setupContent() {
        var lastView: UIImageView?
        
        images.forEach { imageName in
            let cardView = createCardView(with: imageName)
            scrollView.addSubview(cardView)
            
            cardView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                cardView.widthAnchor.constraint(equalToConstant: cardSize),
                cardView.heightAnchor.constraint(equalToConstant: cardSize),
                cardView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor)
            ])
            
            if let last = lastView {
                cardView.leadingAnchor.constraint(equalTo: last.trailingAnchor).isActive = true
            } else {
                cardView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
            }
            
            lastView = cardView
        }
        
        if let last = lastView {
            last.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        }
        
        scrollView.contentSize = CGSize(width: CGFloat(images.count) * cardSize, height: scrollView.bounds.height)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.setInitialContentOffset()
        }
    }
    
    func updateCardScaling() {
        let centerX = scrollView.center.x + scrollView.contentOffset.x
        scrollView.subviews.forEach { cardView in
            let distanceFromCenter = centerX - cardView.center.x
            let thresholdDistance = cardSize / 2
            
            if abs(distanceFromCenter) <= thresholdDistance {
                let normalizedDistance = abs(distanceFromCenter) / thresholdDistance
                let scale = 1 + (0.2 * (1 - normalizedDistance))
                cardView.transform = CGAffineTransform(scaleX: scale, y: scale)
            } else {
                cardView.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
            
            if abs(distanceFromCenter) < cardSize / 2 {
                scrollView.bringSubviewToFront(cardView)
            }
        }
    }
}

