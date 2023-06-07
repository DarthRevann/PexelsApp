//
//  MainViewController.swift
//  Pexels
//
//  Created by Firuza Raiymkul on 23.05.2023.
//

import UIKit

class MainViewController: UIViewController, UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    let layout                  = UICollectionViewFlowLayout()
    var searchHistoryCollectionView     : UICollectionView!
    var contentCollectionView   : UICollectionView!
    let searchBar               = UISearchBar()
    let identifier = "PhotoCollectionViewCell"
    
    var searchPhotosResponse: SearchPhotosResponse? {
        didSet {
            DispatchQueue.main.async {
                self.contentCollectionView.reloadData()
            }
        }
    }
    
    var photos: [Photo] {
        return searchPhotosResponse?.photos ?? []
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        navigationItem.title = "Pexels"
        view.backgroundColor = .white
        generateSearchBar()
        generateSearchHistoryCollectionView()
        generateContentCollectionView()
        
        searchBar.delegate = self
        
        contentCollectionView.contentInset = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
        contentCollectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: identifier)
        contentCollectionView.dataSource = self
        contentCollectionView.delegate = self
    }
    
    func generateSearchHistoryCollectionView() {
        
        print("Story CollectionView implemented")
        
        searchHistoryCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        view.addSubview(searchHistoryCollectionView)
        layout.minimumInteritemSpacing = 4
        layout.minimumLineSpacing = 4
//        searchHistoryCollectionView.backgroundColor = .yellow
        
        searchHistoryCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate( [
        
            searchHistoryCollectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            searchHistoryCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchHistoryCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchHistoryCollectionView.heightAnchor.constraint(equalToConstant: 60)
            
        
        ])
        
    }
    
    func generateSearchBar() {
        print("SearchBar implemented")
        view.addSubview(searchBar)
        searchBar.backgroundColor = .systemGray
        searchBar.placeholder = "поиск изображений"
        searchBar.searchBarStyle = .prominent
        searchBar.searchTextField.autocorrectionType = .no
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        
        ])
        
        
    }
    
    
    func generateContentCollectionView() {
        
        print("Content Collection View implemented")
        
        contentCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
//        contentCollectionView.backgroundColor = .systemPink
        contentCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(contentCollectionView)

        
        NSLayoutConstraint.activate([
        
            contentCollectionView.topAnchor.constraint(equalTo: searchHistoryCollectionView.bottomAnchor),
            contentCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            contentCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        
        ])
        
    }
    func search() {
        guard let searchText = searchBar.text else {
            print("Search bar text is nil")
            return
        }
        guard !searchText.isEmpty else {
            print("Search bar text is empty")
            return
        }
        
        let endpoint =  "https://api.pexels.com/v1/search"
        guard var urlComponents = URLComponents(string: endpoint) else {
            print("Could not create instance of URLComponents from endpoint - \(endpoint)")
            return
        }
        
        
        let parameters = [
            URLQueryItem(name: "query", value: searchText),
            URLQueryItem(name: "per_page", value: "10")
        ]
        
        urlComponents.queryItems = parameters
        
        guard let url: URL = urlComponents.url else {
            print("URL is nil")
            return
        }
        
        var urlRequest: URLRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        let APIKey: String = "gtsRO3haMsH5ZTp5yvPjQol26jEvkecSMjiC6xlg0DlYj6pbdQdxNB1Y"
        urlRequest.addValue(APIKey, forHTTPHeaderField: "Authorization")
        
        let urlSession: URLSession = URLSession(configuration: .default)
        let dataTask: URLSessionDataTask = urlSession.dataTask(with: urlRequest, completionHandler: searchPhotosHandler(data: urlResponse: error:))
        
        dataTask.resume()
    }
    
    func searchPhotosHandler(data: Data?, urlResponse: URLResponse?, error: Error?) {
        print("Method searchPhotosHandler was called")
        
        if let error = error {
            print("Search Photos endpoint error - \(error.localizedDescription)")
        } else if let data = data {
           
            do {
                
//                let jsonObject = try JSONSerialization.jsonObject(with: data)
//                print("Search Photos endpoint jsonObject - \(jsonObject) ")
                let searchPhotosResponse = try JSONDecoder().decode(SearchPhotosResponse.self, from: data)
                print("Search Photos endpoint searchPhotosResponse - \(searchPhotosResponse)")
                self.searchPhotosResponse = searchPhotosResponse
                
            } catch let error {
                print("Search Photos endpoint serialization error - \(error.localizedDescription)")
                
            }
        }
        
        if let urlResponse = urlResponse, let httpResponse = urlResponse as? HTTPURLResponse {
            print("Search Photos endpoing http response status code - \(httpResponse.statusCode)")
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        print("Keyboard appear")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        print("Keyboard disappear")
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        print("Cancel button dissapear")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        search()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = contentCollectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! PhotoCollectionViewCell
        return cell
    }
}
        

class PhotoCollectionViewCell: UICollectionViewCell {
    
    static let identifier: String = "PhotoCollectionViewCell"
    
    let photoImageView = UIImageView()
    let originalImage = UIImage(named: "image_placeholder")
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(photoImageView)
        
        photoImageView.contentMode = .scaleAspectFill
        
        
        photoImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            photoImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            photoImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0)
        ])
        
        // поставили image в ImageView
        originalImage?.withRenderingMode(.alwaysTemplate)
        photoImageView.image = originalImage
        photoImageView.tintColor = .lightGray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: это подробнее изучить

extension MainViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let flowLayout: UICollectionViewFlowLayout? = collectionViewLayout as? UICollectionViewFlowLayout
        let horizontalSpacing: CGFloat = (flowLayout?.minimumInteritemSpacing ?? 0) + collectionView.contentInset.left + collectionView.contentInset.right
        let width: CGFloat = ( collectionView.frame.width - horizontalSpacing) / 2
        let height: CGFloat = width
        
        return CGSize(width: width, height: height)
        
    }
}
