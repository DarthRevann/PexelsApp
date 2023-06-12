import UIKit


class OnboardingViewController: UIViewController {
    
    static let KEY = "UserDidSeeOnboarding"
    //collectionView
    let layout = UICollectionViewFlowLayout()
    var collectionView: UICollectionView!
    let cellIdentifier = "cell"
    
    //  buttons
    //    var skipButtonConfig = UIButton.Configuration.filled()
    //    var forwardButtonConfig = UIButton.Configuration.filled()
    
    let nextButton = UIButton()
    let skipButton = UIButton()
    

    // pageControl
    let pageControl = UIPageControl()
    
    
    var pages: [OnboardingModel] = [] {
        didSet {
            
            pageControl.numberOfPages = pages.count
            
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        generateOnboardingCollectionView()
        generatePages()
        generateSkipButton()
        generateNextButton()
        generatePageControl()
        
//                view.backgroundColor = .systemRed
    }
    
    
    // MARK: There are our functions used in the VC:
    
    
    // MARK: создаем CollectionView
    
    func generateOnboardingCollectionView() {
        
        // добавляем горизонтальный скролл
        layout.scrollDirection = .horizontal
//        layout.itemSize = CGSize(width: 390, height: 844)
        layout.minimumLineSpacing = 0
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        view.addSubview(collectionView)
        print("Salam")
//                collectionView.backgroundColor = .yellow
        
        collectionView.contentMode = .center
        collectionView.delaysContentTouches = true
        collectionView.canCancelContentTouches = true
        collectionView.isPrefetchingEnabled = true
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        // растягиваем наш collectionView на весь экран, сами добавляем констрейнты
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        
        collectionView.register(OnboardingCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        
    }
    
    
    
    
    
    // MARK: создаем кнопку "Пропустить"
    
    func generateSkipButton() {
        
        skipButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 39, bottom: 0, right: 20)
        skipButton.backgroundColor = .orange
        skipButton.layer.cornerRadius = 20
        skipButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        skipButton.setTitle("Пропустить", for: .normal)
        skipButton.tintColor = UIColor.white
        skipButton.layer.opacity = 0.6
        view.addSubview(skipButton)
        
        
        
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            skipButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            skipButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: -22),
            skipButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        
//        skipButton.configuration?.background.cornerRadius = 100
        // add target to action for our button
        skipButton.addTarget(self, action: #selector(skipButtonClicked), for: .touchUpInside)
    }
    
    
    
    
    
    // MARK: Создаем кнопку "Дальше"
    
    func generateNextButton() {
        
        nextButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 47)
        
        nextButton.backgroundColor = UIColor.orange
        nextButton.layer.cornerRadius = 20
        nextButton.setTitle("Дальше", for: .normal)
        nextButton.tintColor = UIColor.white
        nextButton.titleLabel?.font = .systemFont(ofSize: 21, weight: .bold)
        view.addSubview(nextButton)
        
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            nextButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 27),
            nextButton.heightAnchor.constraint(equalTo: skipButton.heightAnchor, multiplier: 1.1),
            nextButton.widthAnchor.constraint(equalTo: skipButton.widthAnchor, multiplier: 1.2)
        ])
        
        
        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
        
    }
    
    
    
    
    
    
    // MARK: добавляем PageControl
    
    func generatePageControl() {
        
        pageControl.numberOfPages                             = 3
        pageControl.currentPage                               = 0
        pageControl.pageIndicatorTintColor                    = .lightGray
        pageControl.currentPageIndicatorTintColor             = .systemOrange
        collectionView.addSubview(pageControl)
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -32),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
    }
    
    
    func generatePages() {
        pages = [
            
            OnboardingModel(imageName: "onboarding1", title: "Play Anywhere", subtitle: "The video call feature can be accessed from anywhere in your house to help you."),
            OnboardingModel(imageName: "onboarding2", title: "Don’t Feel Alone", subtitle: "Nobody likes to be alone and the built-in group video call feature helps you connect."),
            OnboardingModel(imageName: "onboarding3", title: "Happiness", subtitle: "While working the app reminds you to smile, laugh, walk and talk with those who matters.")
            
        ]
        
    }
    
    // создаем действие для кнопки Дальше
    
    @objc func nextButtonClicked(sender: UIButton!) {
        print("Next button clicked!")
        
        if pageControl.currentPage == pageControl.numberOfPages - 1 {
            
            start()
            
        } else {
            
            pageControl.currentPage += 1
            collectionView.scrollToItem(at: IndexPath(item: pageControl.currentPage, section: 0), at: .centeredHorizontally, animated: true)
            handlePageChanges()
        }
    }
    
    // создаем действие для кнопки Пропустить
    @objc func skipButtonClicked(sender: UIButton!) {
        print("Skip button clicked!")
        start()
    }
    
    func start() {
        
        print("Navigation View Controller implemented")
        
        UserDefaults.standard.set(true, forKey: OnboardingViewController.KEY)
        
        let mainVC = MainViewController()
        let navC = UINavigationController(rootViewController: mainVC)
        
        present(navC, animated: true)
        
//        navigationController?.pushViewController(navC, animated: true)
        
        
//        view.window?.rootViewController = navC
//        view.window?.makeKeyAndVisible()

        
    }
    
    
    
    // MARK: эта функция handlePageChanges() убирает кнопку "Пропустить" и изменяет текст в кнопке "Дальше" на "Начать"
    
    func handlePageChanges() {
        if pageControl.currentPage == pageControl.numberOfPages - 1 {
            
            // этот блок кода прячет кнопку плавно
            UIView.animate(withDuration: 0.5, animations:  {
                // Set the alpha to 0 to make the button transparent
                self.skipButton.alpha = 0.4
            }) { (finished) in
                // After the animation completes, hide the button by setting its `isHidden` property to true
                self.skipButton.isHidden = true
                self.nextButton.setTitle("Начать", for: .normal)

            }
            
        } else {
            
            skipButton.isHidden = false
            nextButton.setTitle("Дальше", for: .normal)
            
        }
    }
}



extension OnboardingViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return pages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! OnboardingCollectionViewCell
        
        let onboardingModel = pages[indexPath.item]
        cell.setup(onboardingModel: onboardingModel)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    
}


// MARK: Создаем нашу кастомную ячейку

class OnboardingCollectionViewCell: UICollectionViewCell {
    
    let humansImageView = UIImageView()
    let stackView       = UIStackView()
    let titleLabel      = UILabel()
    let subTitleLabel   = UILabel()
    let innerStackView  = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        // добавляем StackView в ячейку
        contentView.addSubview(stackView)
        stackView.axis                                      = .vertical
        stackView.alignment                                 = .center
        stackView.distribution                              = .fill
        stackView.spacing                                   = 32
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 60),
            stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
            
            
        ])
        
        // добавляем UIImageView в наш стэк
        stackView.addArrangedSubview(humansImageView)
        humansImageView.contentMode         = .scaleAspectFit

        
        humansImageView.autoresizesSubviews = true
        humansImageView.clipsToBounds       = true

        
        // добавляем innerStackView в основной StackView
        
        stackView.addArrangedSubview(innerStackView)
        print("Inner StackView implemented")
        
        innerStackView.distribution                              = .fill
        innerStackView.alignment                                 = .fill
        innerStackView.axis                                      = .vertical
        innerStackView.spacing                                   = 16
        innerStackView.contentMode                               = .scaleAspectFill
        innerStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([

            innerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 48),
            innerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -48)

        ])
        
        
        
        
        // добавляем основной label в labelStackView
        titleLabel.font          = UIFont.boldSystemFont(ofSize: 28)
        titleLabel.textColor     = .black
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        
        innerStackView.addArrangedSubview(titleLabel)


        // добавляем под label в innerStackView
        innerStackView.addArrangedSubview(subTitleLabel)
        subTitleLabel.font          = UIFont.systemFont(ofSize: 17)
        subTitleLabel.textColor     = .systemGray2
        subTitleLabel.numberOfLines = 0
        subTitleLabel.textAlignment = .center
        

        NSLayoutConstraint.activate([
        
            subTitleLabel.trailingAnchor.constraint(equalTo: innerStackView.trailingAnchor),
            subTitleLabel.leadingAnchor.constraint(equalTo: innerStackView.leadingAnchor)
        ])

        
    }
    
    
    func setup(onboardingModel: OnboardingModel) {
        humansImageView.image = UIImage(named: onboardingModel.imageName)
        titleLabel.text       = onboardingModel.title
        subTitleLabel.text    = onboardingModel.subtitle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension OnboardingViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("scrollViewDidEndDecelerating at offSet x: \(scrollView.contentOffset.x)")
        print("scrollView.frame.width x: \(scrollView.frame.width)")
        pageControl.currentPage = Int((scrollView.contentOffset.x / scrollView.frame.width ))
        print("pageControl.currentPage: \(pageControl.currentPage)")
        
        handlePageChanges()
    }
    
}


