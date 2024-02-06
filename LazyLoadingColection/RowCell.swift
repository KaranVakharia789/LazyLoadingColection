//
//  RowCell.swift
//  LazyLoadingColection
//
//  Created by Karan V on 05/02/24.
//

import UIKit
import Kingfisher

class RowCell: UICollectionViewCell {
    @IBOutlet weak var lblText: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func configure(with item: Hits) {
        guard let imageURL = URL(string: item.largeImageURL) else {
            imgView.image = UIImage(named: "defaultImage")
            return
        }
        let downsamplingProcessor = DownsamplingImageProcessor(size: CGSize(width: 100, height: 100))
//        let cache = ImageCache.default
//        cache.memoryStorage.config.totalCostLimit = 50 * 1024 * 1024 // Adjust memory limit
//        cache.diskStorage.config.sizeLimit = 200 * 1024 * 1024 // Adjust disk storage limit
//
//        let prefetcher = ImagePrefetcher(urls: [imageURL])
//        prefetcher.start()
        
        self.imgView.kf.setImage(
            with: imageURL,
            options: [
                .processor(downsamplingProcessor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ]
        )
        

//        imgView.kf.setImage(with: imageURL, placeholder: UIImage(named: "placeholderImage"), options: [.transition(.fade(0.3))])
        lblText.text = "\(item.id ?? 0)"
    }
    
    func downsample(image: UIImage?, to size: CGSize) -> UIImage? {
        guard let image = image else { return nil }

        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { (context) in
            image.draw(in: CGRect(origin: .zero, size: size))
        }
    }

    
}
