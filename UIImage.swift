import UIKit

public extension UIImage {
    var circularImage: UIImage? {
        guard let cgImage = cgImage else {
            return nil
        }

        // Find min image edge
        let minEdge = min(size.height, size.width)

        // Create square rect in the middle of image
        let croppingSize = CGSize(width: minEdge * scale, height: minEdge * scale)
        let croppingRectOrigin = CGPoint(x: ((size.width / 2 - minEdge / 2) * scale).rounded(.down), y: ((size.height / 2 - minEdge / 2) * scale).rounded(.down))
        let squareCroppingRect = CGRect(origin: croppingRectOrigin, size: croppingSize)

        // Crop image to square rect in the middle
        guard let croppedImage = cgImage.cropping(to: squareCroppingRect) else {
            return nil
        }

        // Prepare rendeder rect
        let rendererSize = CGSize(width: croppedImage.width, height: croppedImage.height)
        let drawingRect = CGRect(origin: .zero, size: rendererSize)
        let renderer = UIGraphicsImageRenderer(size: rendererSize)

        return renderer.image { _ in
            // Prepare circular path
            let path = UIBezierPath(ovalIn: drawingRect)
            path.addClip()
            UIImage(cgImage: croppedImage, scale: self.scale, orientation: self.imageOrientation).draw(in: drawingRect)
        }
    }
}
