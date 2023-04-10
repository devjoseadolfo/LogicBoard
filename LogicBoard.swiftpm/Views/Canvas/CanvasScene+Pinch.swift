import SpriteKit

extension CanvasScene {
    @objc func twoFingerPinch(recognizer: UIPinchGestureRecognizer) {
        guard let camera = self.camera else {
            return
        }
        if recognizer.state == .began {
            previousCameraScale = camera.xScale
        }
        let newScale = previousCameraScale * 1 / recognizer.scale
        guard newScale < 5, newScale > 0.5 else { return }
        camera.setScale(newScale)
        if recognizer.state == .ended {
            previousCameraScale = camera.xScale
        }
    }
}
