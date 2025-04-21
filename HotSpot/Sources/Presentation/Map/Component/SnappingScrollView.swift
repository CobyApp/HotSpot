import SwiftUI
import UIKit

struct CarouselScrollViewRepresentable<Item: Identifiable, Content: View>: UIViewRepresentable {
    var items: [Item]
    var itemWidth: CGFloat
    var spacing: CGFloat
    var content: (Item) -> Content

    func makeCoordinator() -> Coordinator {
        Coordinator(items: items, itemWidth: itemWidth, spacing: spacing, content: content)
    }

    func makeUIView(context: Context) -> UICollectionView {
        return context.coordinator.collectionView
    }

    func updateUIView(_ uiView: UICollectionView, context: Context) {
        context.coordinator.update(items: items)
    }

    class Coordinator: NSObject, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIScrollViewDelegate {
        var items: [Item]
        let itemWidth: CGFloat
        let spacing: CGFloat
        let content: (Item) -> Content

        var collectionView: UICollectionView

        init(items: [Item], itemWidth: CGFloat, spacing: CGFloat, content: @escaping (Item) -> Content) {
            self.items = items
            self.itemWidth = itemWidth
            self.spacing = spacing
            self.content = content

            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = spacing
            layout.sectionInset = UIEdgeInsets(top: 0, left: (UIScreen.main.bounds.width - itemWidth) / 2, bottom: 0, right: (UIScreen.main.bounds.width - itemWidth) / 2)

            collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.decelerationRate = .fast
            collectionView.backgroundColor = .clear

            super.init()

            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.register(CarouselCell.self, forCellWithReuseIdentifier: "CarouselCell")
        }

        func update(items: [Item]) {
            self.items = items
            collectionView.reloadData()
        }

        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            items.count
        }

        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            CGSize(width: itemWidth, height: collectionView.frame.height)
        }

        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CarouselCell", for: indexPath) as? CarouselCell else {
                return UICollectionViewCell()
            }

            let hostingController = UIHostingController(rootView: content(items[indexPath.item]))
            hostingController.view.translatesAutoresizingMaskIntoConstraints = false
            hostingController.view.backgroundColor = .clear

            cell.hostingController = hostingController
            return cell
        }

        func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
            let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
            let cellWidthIncludingSpacing = itemWidth + spacing

            let offsetX = targetContentOffset.pointee.x
            let index = round((offsetX + scrollView.contentInset.left) / cellWidthIncludingSpacing)
            let newOffsetX = index * cellWidthIncludingSpacing - scrollView.contentInset.left

            targetContentOffset.pointee = CGPoint(x: newOffsetX, y: 0)
        }
    }

    class CarouselCell: UICollectionViewCell {
        var hostingController: UIHostingController<Content>? {
            didSet {
                if let oldVC = oldValue {
                    oldVC.view.removeFromSuperview()
                }

                if let vc = hostingController {
                    contentView.addSubview(vc.view)
                    NSLayoutConstraint.activate([
                        vc.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                        vc.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                        vc.view.topAnchor.constraint(equalTo: contentView.topAnchor),
                        vc.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
                    ])
                }
            }
        }
    }
}
