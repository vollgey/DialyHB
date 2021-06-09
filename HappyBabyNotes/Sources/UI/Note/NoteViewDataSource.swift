//
// Created by BadApple on 2019-06-19.
// Copyright (c) 2019 Studio9. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class NoteViewDataSource: NSObject {
    private let flux: Flux
    private let disposeBag = DisposeBag()

    init(flux: Flux) {
        self.flux = flux
    }

    func configure(with collectionView: UICollectionView) {
        collectionView.dataSource = self
        collectionView.delegate = self

        collectionView.register(UINib(nibName: "NoteCell", bundle: nil),
                                forCellWithReuseIdentifier: "NoteCell")
    }
}

extension NoteViewDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        24
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NoteCell", for: indexPath) as! NoteCell
        //        self.flux.mainStore.getBabyID.subscribe { [unowned self] _ in
        //            print("reloadData")
        //            cell.configure(flux: self.flux, hour: indexPath.row)
        //        }.disposed(by: disposeBag)
        cell.configure(flux: flux, hour: indexPath.row)
        return cell
    }
}

extension NoteViewDataSource: UICollectionViewDelegate {

}
