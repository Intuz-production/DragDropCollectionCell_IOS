//The MIT License (MIT)
//
//Copyright (c) 2020 INTUZ
//
//Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import Foundation
import UIKit

class DragCollectionFlowLayout : UICollectionViewFlowLayout {
  
  private var longPress: UILongPressGestureRecognizer!
  private var originalIndexPath: IndexPath?
  private var draggingIndexPath: IndexPath?
  private var draggingView: UIView?
  private var dragOffset: CGPoint?
  
  override func prepare() {
    super.prepare()
    installGestureRecognizer()
  }
  
  func installGestureRecognizer() {
    if longPress == nil {
      longPress = UILongPressGestureRecognizer(target: self, action: #selector(DragCollectionFlowLayout.handleLongPress(_:))
      )
      longPress.minimumPressDuration = 0.2
      collectionView?.addGestureRecognizer(longPress)
    }
  }
  
  @objc func handleLongPress(_ longPress: UILongPressGestureRecognizer) {
    let location = longPress.location(in: collectionView!)
    switch longPress.state {
    case .began: startDragAtLocation(location)
    case .changed: updateDragAtLocation(location)
    case .ended: endDragAtLocation(location)
    default:
      break
    }
  }
  
  func startDragAtLocation(_ location: CGPoint) {
    guard let cv = collectionView else { return }
    guard let indexPath = cv.indexPathForItem(at: location) else { return }
    guard cv.dataSource?.collectionView?(cv, canMoveItemAt: indexPath) == true else { return }
    guard let cell = cv.cellForItem(at: indexPath) else { return }
    
    originalIndexPath = indexPath
    draggingIndexPath = indexPath
    draggingView = cell.snapshotView(afterScreenUpdates: true)
    draggingView!.frame = cell.frame
    cv.addSubview(draggingView!)
    
    dragOffset = CGPoint(x: draggingView!.center.x - location.x, y: draggingView!.center.y - location.y)
    
    draggingView?.layer.shadowPath = UIBezierPath(rect: draggingView!.bounds).cgPath
    draggingView?.layer.shadowColor = UIColor.lightGray.cgColor
    draggingView?.layer.shadowOpacity = 0.3
    draggingView?.layer.shadowRadius = 2
    
    invalidateLayout()
    
    UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: [], animations: {
      self.draggingView?.alpha = 0.95
      self.draggingView?.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
    }, completion: nil)
  }
  
  func updateDragAtLocation(_ location: CGPoint) {
    guard let view = draggingView else { return }
    guard let cv = collectionView else { return }
    guard let dragOffset = self.dragOffset else { return }
    
    if self.scrollDirection == .vertical, location.y + dragOffset.y >= cv.height, let newIndexPath = cv.indexPathForItem(at: CGPoint(x: location.x, y: location.y + dragOffset.y)), let indexPath = draggingIndexPath, indexPath.section == newIndexPath.section {
      cv.scrollToItem(at: newIndexPath, at: .bottom, animated: true)
    }
    
    if self.scrollDirection == .vertical, let newIndexPath = cv.indexPathForItem(at: CGPoint(x: location.x, y: location.y + dragOffset.y)) {
      cv.scrollToItem(at: newIndexPath, at: .top, animated: true)
    }
    
    if self.scrollDirection == .horizontal, location.x + dragOffset.x >= (cv.width / 2), let newIndexPath = cv.indexPathForItem(at: CGPoint(x: location.x + dragOffset.x, y: location.y)), let indexPath = draggingIndexPath, indexPath.section == newIndexPath.section {
      cv.scrollToItem(at: newIndexPath, at: .left, animated: true)
    }
    
    view.center = CGPoint(x: location.x + dragOffset.x, y: location.y + dragOffset.y)
    
    if let newIndexPath = cv.indexPathForItem(at: location), let indexPath = draggingIndexPath, indexPath.section == newIndexPath.section {
      cv.moveItem(at: draggingIndexPath!, to: newIndexPath)
      draggingIndexPath = newIndexPath
      
      if indexPath.row == 0 {
        cv.setContentOffset(.zero, animated: false)
      }
    }
  }
  
  func endDragAtLocation(_ location: CGPoint) {
    guard let dragView = draggingView else { return }
    guard let indexPath = draggingIndexPath else { return }
    guard let cv = collectionView else { return }
    guard let datasource = cv.dataSource else { return }
    
    let targetCenter = datasource.collectionView(cv, cellForItemAt: indexPath).center
    
    let shadowFade = CABasicAnimation(keyPath: "shadowOpacity")
    shadowFade.fromValue = 0.8
    shadowFade.toValue = 0
    shadowFade.duration = 0.4
    dragView.layer.add(shadowFade, forKey: "shadowFade")
    
    UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: [], animations: {
      dragView.center = targetCenter
      dragView.transform = CGAffineTransform.identity
      
    }) { (completed) in
      if indexPath != self.originalIndexPath { //look into this condition
        datasource.collectionView?(cv, moveItemAt: self.originalIndexPath!, to: indexPath)
      }
      dragView.removeFromSuperview()
      self.draggingIndexPath = nil
      self.draggingView = nil
      self.invalidateLayout()
    }
  }
  
  
}
