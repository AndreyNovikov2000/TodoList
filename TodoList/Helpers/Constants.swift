//
//  Constants.swift
//  TodoList
//
//  Created by Andrey Novikov on 5/10/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit

struct Constants {
    static let storiesCollectionViewCircleCellSize: CGFloat = 58
    static let storiesCollectionViewFullCircleCellSize: CGFloat = Constants.storiesCollectionViewCircleCellSize + 15
    static let storiesCollectionViewInsetItem: UIEdgeInsets = .init(top: 0, left: 16, bottom: 0, right: 16)
    static let storiesCollectionViewMinimumLineSpacing: CGFloat = 20
    static let taskCellPadding = UIEdgeInsets(top: 20, left: 18, bottom: 20, right: 20)
    static let paddingBetweenTableViewAndScrollView = UIEdgeInsets(top: 25, left: 0, bottom: 15, right: 0)
}

struct AppConstrants {
    static let headerColorsForTaskTableViewHeader: [UIColor] = [UIColor(red: 0.1021237299, green: 0.597595036, blue: 0.8779979348, alpha: 1),
                                                                UIColor(red: 0, green: 0.3936163485, blue: 0.5803127289, alpha: 1),
                                                                UIColor(red: 0.8117647059, green: 0.8235294118, blue: 0.8039215686, alpha: 1),
                                                                UIColor(red: 0.8117647059, green: 0.8235294118, blue: 0.8039215686, alpha: 1)]
    
    static let titleForTaskTableView = ["Сегодня", "Завтра", "На неделе", "Потом"]
}



//struct My {
//    static var cellSnapshot: UIView?
//    static var cellAnimating: Bool = false
//    static var cellNeedToShow: Bool = false
//}
//
//struct Path {
//    static var initialIndexPath: IndexPath?
//}


//@objc private func headleLongPressGesture(gesture: UILongPressGestureRecognizer) {
//    let state = gesture.state
//    let location = gesture.location(in: tableView)
//    let indexPath = tableView.indexPathForRow(at: location)
//
//
//
//    switch state {
//    case .began:
//        if let indexPath = indexPath {
//            guard let cell = tableView.cellForRow(at: indexPath) as? TaskCell else { return }
//
//            var center = cell.center
//
//            My.cellSnapshot = snapshotOfCell(cell)
//
//            Path.initialIndexPath = indexPath
//            My.cellSnapshot = cell
//            My.cellSnapshot?.center = center
//            My.cellSnapshot?.alpha = 0
//
//            tableView.addSubview(My.cellSnapshot ?? UIView())
//
//            UIView.animate(withDuration: 0.25, animations: {
//                center.y = location.y
//                My.cellSnapshot?.center = center
//                My.cellSnapshot?.transform = CGAffineTransform(translationX: 1.05, y: 1.05)
//                My.cellSnapshot?.alpha = 0.98
//                cell.alpha = 0
//            }) { finished in
//
//                if finished {
//                    My.cellAnimating = false
//                }
//
//                if My.cellNeedToShow {
//                    UIView.animate(withDuration: 0.25) {
//                        cell.alpha = 1
//                    }
//                } else {
//                    cell.isHidden = true
//                }
//            }
//        }
//
//
//    case .changed:
//
//        if My.cellSnapshot != nil {
//            var center = My.cellSnapshot?.center
//            center?.y = location.y
//
//            My.cellSnapshot?.center = center ?? CGPoint.zero
//
//            guard let indexPath = indexPath, indexPath != Path.initialIndexPath, Path.initialIndexPath != nil else { return }
//
//            elements[indexPath.section].insert(elements[Path.initialIndexPath!.section].remove(at: Path.initialIndexPath!.row), at: indexPath.row)
//        }
//
//    default:
//        guard Path.initialIndexPath != nil, let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath) else { return }
//
//        if My.cellAnimating {
//            My.cellNeedToShow = true
//        } else {
//            cell.isHidden = true
//            cell.alpha = 0
//        }
//
//        UIView.animate(withDuration: 0.25, animations: {
//            My.cellSnapshot?.center = cell.center
//            My.cellSnapshot?.transform = CGAffineTransform.identity
//            My.cellSnapshot?.alpha = 0
//
//            cell.alpha = 1
//
//        }) { finished in
//
//            if finished {
//                My.cellSnapshot?.removeFromSuperview()
//                My.cellSnapshot = nil
//            }
//        }
//    }
//}
//
//
//
//func snapshotOfCell(_ inputView: UIView) -> UIView {
//    guard let contex = UIGraphicsGetCurrentContext(), let imageContex = UIGraphicsGetImageFromCurrentImageContext() else { return UIView() }
//    UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0.0)
//
//    inputView.layer.render(in: contex)
//
//    UIGraphicsEndImageContext()
//
//    let cellSnapShot: UIView = UIImageView(image: imageContex)
//
//    cellSnapShot.layer.masksToBounds = false
//    cellSnapShot.layer.cornerRadius = 0.0
//    cellSnapShot.layer.shadowOffset = CGSize(width: -5, height: 0)
//    cellSnapShot.layer.shadowOpacity = 0.5
//
//    return cellSnapShot
//}


