//
//  PaletteListViewController.swift
//  Palette
//
//  Created by Annicha Hanwilai on 6/11/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import UIKit

class PaletteListViewController: UIViewController {

    //Source of  truth
    var photos:  [UnsplashPhoto] = []
    
    var buttons: [UIButton]{
        return [featureButton, randomButtonButton, doubleRainbowButton]
    }
    
    var safeArea: UILayoutGuide {
        return self.view.safeAreaLayoutGuide
    }
    
    override func loadView() {
        super.loadView()
        addAllSubviews()
        setUpStackView()
        paletteTableview.anchor(top: buttonStackView.bottomAnchor, bottom: safeArea.bottomAnchor, leading: safeArea.leadingAnchor, trailing: safeArea.trailingAnchor, paddingTop: 8, paddingBottom: 0, paddingLeading: 0, paddingTrailing: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureTableView()
        activateButtons()
        searchForCategory(.featured)
        selectButton(featureButton)
    }
    
    func addAllSubviews(){
        view.addSubview(featureButton)
        view.addSubview(randomButtonButton)
        view.addSubview(doubleRainbowButton)
        
        // now we don't have anything in the stack yet
        view.addSubview(buttonStackView)
        
        view.addSubview(paletteTableview)
    }
    
    func setUpStackView(){
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.addArrangedSubview(featureButton)
        buttonStackView.addArrangedSubview(randomButtonButton)
        buttonStackView.addArrangedSubview(doubleRainbowButton)
        
        buttonStackView.anchor(top: safeArea.topAnchor, bottom: nil, leading: safeArea.leadingAnchor, trailing: safeArea.trailingAnchor, paddingTop: 16, paddingBottom: 0, paddingLeading: 16, paddingTrailing: -16)
    }
    
    func configureTableView(){
        paletteTableview.dataSource = self
        paletteTableview.delegate = self
        paletteTableview.register(PaletteListTableViewCell.self, forCellReuseIdentifier: "colorCell")
        paletteTableview.allowsSelection = false
    }
    
    func searchForCategory(_ unsplashRoute: UnsplashRoute){
        UnsplashService.shared.fetchFromUnsplash(for: unsplashRoute) { (unsplashPhotos) in
            guard let unsplashPhotos = unsplashPhotos else {return}
            self.photos = unsplashPhotos
            DispatchQueue.main.async {
                self.paletteTableview.reloadData()
            }
        }
    }
    
    func activateButtons(){
        buttons.forEach{ $0.addTarget(self, action: #selector(searchButtonTapped(sender:)), for: .touchUpInside) }
    }
    
    func selectButton(_ button: UIButton){
        buttons.forEach{ $0.setTitleColor(.lightGray, for: .normal) }
        button.setTitleColor(UIColor(named: "devmountainBlue"), for: .normal)
    }
   
    
    //MARK: - Views
    let featureButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Featured", for: .normal)
        button.contentHorizontalAlignment = .center
        return button
    }()
    
    let randomButtonButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Random", for: .normal)
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
        return button
    }()
    
    let doubleRainbowButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Double Rainbow", for: .normal)
        button.contentHorizontalAlignment = .center
        return button
    }()
    
    let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalCentering
        return stackView
    }()
    
    let paletteTableview: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    @objc func searchButtonTapped(sender: UIButton){
        print("I was tapped")
        selectButton(sender)

        switch sender {
        case featureButton: selectButton(featureButton)
        case randomButtonButton: selectButton(randomButtonButton)
        case doubleRainbowButton: selectButton(doubleRainbowButton)
        default: print("How did you find a fourth button?")
        }
        
    }
}

extension PaletteListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let imageViewSpace: CGFloat = (view.frame.width - (2 * SpacingConstants.outerHorizontalPadding))
        let titleLabelSpace: CGFloat = SpacingConstants.oneLineElementHeight
        let colorPaletteViewSpace: CGFloat = SpacingConstants.twoLineElementHeight
        let verticalPadding: CGFloat = (3 * SpacingConstants.verticalObjectBuffer)
        let outerVerticalPadding: CGFloat = (2 * SpacingConstants.outerHorizontalPadding)
        
        return imageViewSpace + titleLabelSpace + colorPaletteViewSpace + verticalPadding + outerVerticalPadding
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // create a cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "colorCell", for: indexPath) as! PaletteListTableViewCell
        
        // select photo
        let unsplashPhoto = photos[indexPath.row]
        
        // assign photo to cell
        cell.unsplashPhoto = unsplashPhoto
        
        // return cell
        return cell
    }
}
