//
//  ViewController.swift
//  LazyLoadingColection
//
//  Created by Karan V on 05/02/24.
//

import UIKit
//16403255ea2d172e078534555
//per_page
class ViewController: UIViewController {

    @IBOutlet weak var colView: UICollectionView!
    var arrHits = [Hits]()
//    var perPage = 12
    var pageCount = 1
    var isLoadingMore = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        colView.register(UINib(nibName: "RowCell", bundle: nil), forCellWithReuseIdentifier: "RowCell")
        getAPICalling()
    }
    func getAPICalling() {
//        pageCount = pageCount + 1
        isLoadingMore = true
        APIHelper.sharedInstance.getAPI(apiURL:Constant.API + "\(pageCount)", delegate: responseData)
        print("PAGINGGGGGGGGGGG APISSSS:- \(Constant.API + "\(pageCount)")")
    }
    func responseData(arrResponse: [String: AnyObject]) {
        let dictionary = arrResponse as NSDictionary
        let arrMainSticky = dictionary.value(forKey: "hits") as? NSArray ?? []
        for items in arrMainSticky {
            let dic = items as! NSDictionary
            let object = Hits()
            object.largeImageURL = dic.value(forKey: "largeImageURL") as? String ?? ""
            object.id = dic.value(forKey: "id") as? Int ?? 0
            arrHits.append(object)
        }
        DispatchQueue.main.async {
            self.colView.reloadData()
            self.isLoadingMore = false
        }
    }
    
}
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrHits.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RowCell", for: indexPath) as! RowCell
        let data = arrHits[indexPath.item]
        cell.configure(with: data)
        
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // Check if the last cell is about to be displayed and there is no ongoing data fetch
        if indexPath.item == arrHits.count - 1 && !isLoadingMore{
            print("Nextpage \(pageCount + 1)")
            pageCount = pageCount + 1
            getAPICalling()
        } else {
//            print("No pagination")
        }
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.bounds.width
        return CGSize(width: collectionViewWidth/2, height: collectionViewWidth/2)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }

    
}
