//
//  MainViewController.swift
//  Pexels
//
//  Created by Firuza Raiymkul on 23.05.2023.
//

import UIKit

class MainViewController: UIViewController, UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let historyLayout                 = UICollectionViewFlowLayout()
    let contentLayout                 = UICollectionViewFlowLayout()
    var searchHistoryCollectionView   : UICollectionView!
    var contentCollectionView         : UICollectionView!
    let searchBar                     = UISearchBar()
    let identifier                    = "PhotoCollectionViewCell"
    let id                            = "SearchTextCollectionViewCell"
    
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
        
        // отображение содержимого contentCollectionView
        contentCollectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: identifier)
        contentCollectionView.dataSource = self
        contentCollectionView.delegate = self
        contentCollectionView.refreshControl = UIRefreshControl()
        contentCollectionView.refreshControl?.addTarget(self, action: #selector(search), for: .valueChanged)
        
        
        // SearchTextCollectionView отображение содержимого
        searchHistoryCollectionView.register(SearchTextCollectionViewCell.self, forCellWithReuseIdentifier: id)
        searchHistoryCollectionView.dataSource = self
        
        let flowLayout = searchHistoryCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
        flowLayout?.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
    }
    
    func generateSearchHistoryCollectionView() {
        
        print("Story CollectionView implemented")
        
        searchHistoryCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: historyLayout)

        historyLayout.scrollDirection = .horizontal
        searchHistoryCollectionView.showsHorizontalScrollIndicator = false
        searchHistoryCollectionView.contentInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        
        view.addSubview(searchHistoryCollectionView)
        
        searchHistoryCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate( [
        
            searchHistoryCollectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10),
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
        
        contentCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: contentLayout)

        contentLayout.scrollDirection = .vertical
        contentLayout.minimumInteritemSpacing = 4
        contentLayout.minimumLineSpacing = 4
        contentCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(contentCollectionView)

        
        NSLayoutConstraint.activate([
        
            contentCollectionView.topAnchor.constraint(equalTo: searchHistoryCollectionView.bottomAnchor, constant: 10),
            contentCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            contentCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            contentCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
        
        ])
        
    }
    @objc func search() {
        
        self.searchPhotosResponse = nil
        
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
            URLQueryItem(name: "per_page", value: "100")
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
        
        if contentCollectionView.refreshControl?.isRefreshing == false {
            contentCollectionView.refreshControl?.beginRefreshing()
        }
        
        let urlSession: URLSession = URLSession(configuration: .default)
        let dataTask: URLSessionDataTask = urlSession.dataTask(with: urlRequest, completionHandler: searchPhotosHandler(data: urlResponse: error:))
        
        dataTask.resume()
    }
    
    func searchPhotosHandler(data: Data?, urlResponse: URLResponse?, error: Error?) {
        print("Method searchPhotosHandler was called")
        
        DispatchQueue.main.async {
            if self.contentCollectionView.refreshControl?.isRefreshing == true {
                self.contentCollectionView.refreshControl?.endRefreshing()
            }
        }
        
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
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        // так как у меня две ячейки, я сделал проверку, чтобы на каждую ячейку отображалось именно ее содержимое:
        switch collectionView {
        case contentCollectionView:
            return photos.count
            
        case searchHistoryCollectionView:
            return 5
            
        default:
            return 0
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      
        switch collectionView {
        case contentCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as! PhotoCollectionViewCell
            cell.setup(photo: self.photos[indexPath.item])
            return cell
        case searchHistoryCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchTextCollectionViewCell.id, for: indexPath) as! SearchTextCollectionViewCell
            return cell
        default:
            return UICollectionViewCell()
    
        }
    }
}
        
// создаем ячейку с фото
class PhotoCollectionViewCell: UICollectionViewCell {
    
    static let identifier: String = "PhotoCollectionViewCell"
    
    var photo: Photo?
    
    let photoImageView = UIImageView()
    let originalImage = UIImage(named: "image_placeholder")
    let activityIndicatorView = UIActivityIndicatorView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(activityIndicatorView)
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.style = .medium
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        
            activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor)
            
        ])
        
        
        
        contentView.addSubview(photoImageView)
        
        photoImageView.contentMode = .scaleToFill
        
        
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
    
    func setup(photo: Photo) {
        
        self.photo = photo
        
        let mediumPhotoURLString: String = photo.src.medium
        guard let mediumPhotoURL = URL(string: mediumPhotoURLString) else {
            print("Couldn't create URL with given mediumPhotoURLString: \(mediumPhotoURLString)")
            return
        }
        
        self.activityIndicatorView.startAnimating()
        
        let dataTask = URLSession.shared.dataTask(with: mediumPhotoURL, completionHandler: imageLoadCompletionHandler(data:urlResponse:error:))
        dataTask.resume()
    }
    
    func imageLoadCompletionHandler(data: Data?, urlResponse: URLResponse?, error: Error? ) {
        
        if urlsAreSame(responseURL: urlResponse?.url?.absoluteString) {
            
            DispatchQueue.main.async {
                self.activityIndicatorView.stopAnimating()
            }
            
        }
        
        if let error = error {
            
            print("Error loading image - \(error.localizedDescription)")
            
        } else if let data = data {
            
            guard urlsAreSame(responseURL: urlResponse?.url?.absoluteString) else {
                return
            }
            
            DispatchQueue.main.async {
                self.photoImageView.image = UIImage(data: data)
            }
            
        }
        
    }
    
    func urlsAreSame(responseURL: String?) -> Bool {
        
        guard let currentPhotoURL = self.photo?.src.medium , let responseURL = responseURL else {
            print("Current photo url OR Response url are absent")
            return false
        }
        
        guard currentPhotoURL == responseURL else {
            print("ATTENTION! currentPhotoURL and responseURL are different!")
            return false
        }
        return true
    } 
}


// MARK: это подробнее изучить

extension MainViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let flowLayout: UICollectionViewFlowLayout? = collectionViewLayout as? UICollectionViewFlowLayout
        let horizontalSpacing: CGFloat = (flowLayout?.minimumInteritemSpacing ?? 0) + contentCollectionView.contentInset.left + contentCollectionView.contentInset.right
        let width: CGFloat = ( collectionView.frame.width - horizontalSpacing) / 2
        let height: CGFloat = width
        
        return CGSize(width: width, height: height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let photo = self.photos[indexPath.item]
        let url = photo.src.large2X
        
        let vc = ImageScrollViewController(imageURL: url)
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}
