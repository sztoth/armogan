//
//  ForecastDetailViewController.swift
//  armogan
//
//  Created by Szabolcs Toth on 2016. 12. 03..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class ForecastDetailViewController: BaseViewController {
    fileprivate(set) var closeButton: UIButton!

    override func loadView() {
        super.loadView()

        view.backgroundColor = UIColor.white

        closeButton = UIButton(type: .system)
        closeButton.frame = CGRect(x: 50.0, y: 50.0, width: 60.0, height: 60.0)
        closeButton.setTitle("Close", for: .normal)
        view.addSubview(closeButton)

        closeButton.rx.tap
            .subscribe(onNext: {
                self.dismiss(animated: true, completion: nil)
            })
            .addDisposableTo(disposeBag)
    }
}

//extension ForecastDetailViewController: ExpandingCellTransitionPresentedDelegate {}
