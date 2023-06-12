//
//  ImageScrollViewController.swift
//  Pexels
//
//  Created by Firuza Raiymkul on 09.06.2023.
//

import UIKit

class ImageScrollViewController: UIViewController {

    let scrollView = UIScrollView()
    let imageView = UIImageView()
    let activityIndicatorView = UIActivityIndicatorView(style: .large)
    
    let imageURL: String
    
    init(imageURL: String) {
        self.imageURL = imageURL
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        scrollView.delegate = self
        setupScrollView()
        setupImageView()
        setupActivityIndicatorView()
        loadImage()
        
        
    }
    
    func setupScrollView() {
        
        view.addSubview(scrollView)
        scrollView.maximumZoomScale = 4.0
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        
        ])
    }
    
    func setupImageView() {
        
        scrollView.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        
            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 1),
            imageView.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 1)
        
        ])
        
    }
    
    func setupActivityIndicatorView() {
        
        view.addSubview(activityIndicatorView)
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        
            activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        
        ])

    }
    
    
    
    func loadImage() {
        
        guard let url = URL(string: imageURL) else {
            print("Couldn't create URL instance with image url: \(imageURL)")
            return
        }
        
        self.activityIndicatorView.startAnimating()
        let dataTask = URLSession.shared.dataTask(with: url, completionHandler: completionHandler(data:urlResponse:error:))
        dataTask.resume()
        
    }
    
    func completionHandler(data: Data?, urlResponse: URLResponse?, error: Error?) {
        
        DispatchQueue.main.async {
            self.activityIndicatorView.stopAnimating()
        }
        
        if let error = error {
            print("Image loading error: \(error.localizedDescription)")
        } else if let data = data {
            
            DispatchQueue.main.async {
                self.imageView.image = UIImage(data: data)
            }
            
        }
        
    }
}

extension ImageScrollViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
