//
//  ListCollectionView.swift
//  TodoList
//
//  Created by Andrey Novikov on 5/18/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit

class ListCollectionView: UICollectionView {
    
    // MARK: - Public properties
    var presentationClosure: ((Lists?) -> Void)?
    
    // MARK: - Private properties
    private let contex = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private let storageManager = StorageManager()
    private var lists = [Lists]()
    
    // MARK: - Init
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        super.init(frame: .zero, collectionViewLayout: layout)
       
        
        setupCollectionView()
        fetchData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public methods
    func update() {
        fetchData()
        reloadData()
    }
    
    // MARK: - Private methods
    private func setupCollectionView() {
        delegate = self
        dataSource = self
        register(ListCell.self, forCellWithReuseIdentifier: ListCell.reuseId)
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        contentInset = UIEdgeInsets(top: 0, left: Constants.collectionViewInsets.left, bottom: 0, right: Constants.collectionViewInsets.right)
    }
    
    
    private func fetchData() {
        do {
            try lists = storageManager.request(contex: contex, descriptors: nil)
        } catch {
            print("error - \(error.localizedDescription)")
        }
    }
}


// MARK: - UICollectionViewDataSource
extension ListCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return lists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCell.reuseId, for: indexPath) as! ListCell
        let list = lists[indexPath.row]
        
        cell.set(list: list)

        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension ListCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = lists[indexPath.row]
        
        presentationClosure?(selectedItem)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ListCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Constants.listCollectionViewContentSize.width, height: Constants.listCollectionViewContentSize.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.listCollectionViewMinimumLineSpacing
    }
}