import SpriteKit

extension CanvasScene {
    @objc func twoFingerPan(recognizer: UIPanGestureRecognizer) {
        guard let camera = scene?.camera else {
              return
            }
        
        if recognizer.state == .began {
          previousCameraPoint = camera.position
        }
   
        let translation = recognizer.translation(in: self.view)
        let newPosition = CGPoint(
          x: previousCameraPoint.x + translation.x * -1 * previousCameraScale,
          y: previousCameraPoint.y + translation.y * previousCameraScale
        )
        camera.position = newPosition
        cameraPoint = newPosition
        cameraOffset = CGPoint(
            x: newPosition.x - originalCameraPoint.x,
            y: newPosition.y - originalCameraPoint.y
        )
    }
}

