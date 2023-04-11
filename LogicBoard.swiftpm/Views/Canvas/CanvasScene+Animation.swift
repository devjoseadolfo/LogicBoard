import SpriteKit

extension SKAction {
    static func strokeTransitionColor(of node: SKNode, toColor: UIColor, duration: CGFloat = 0.15) -> SKAction
    {
        return SKAction.customAction(withDuration: duration, actionBlock: { (node : SKNode!, elapsedTime : CGFloat) -> Void in
            guard let node = node as? SKShapeNode else { return }
            let fromColor = node.strokeColor
            let fraction = CGFloat(elapsedTime / duration)
            let startColorComponents = fromColor.toComponents()
            let endColorComponents = toColor.toComponents()
            let transColor = UIColor(red: lerp(a: startColorComponents.red, b: endColorComponents.red, fraction: fraction),
                                     green: lerp(a: startColorComponents.green, b: endColorComponents.green, fraction: fraction),
                                     blue: lerp(a: startColorComponents.blue, b: endColorComponents.blue, fraction: fraction),
                                     alpha: lerp(a: startColorComponents.alpha, b: endColorComponents.alpha, fraction: fraction))
            node.strokeColor = transColor
            }
        )
    }
    
    static func fillTransitionColor(of node: SKNode, toColor: UIColor, duration: CGFloat = 0.15) -> SKAction
    {
        return SKAction.customAction(withDuration: duration, actionBlock: { (node : SKNode!, elapsedTime : CGFloat) -> Void in
            guard let node = node as? SKShapeNode else { return }
            let fromColor = node.fillColor
            let fraction = CGFloat(elapsedTime / duration)
            let startColorComponents = fromColor.toComponents()
            let endColorComponents = toColor.toComponents()
            let transColor = UIColor(red: lerp(a: startColorComponents.red, b: endColorComponents.red, fraction: fraction),
                                     green: lerp(a: startColorComponents.green, b: endColorComponents.green, fraction: fraction),
                                     blue: lerp(a: startColorComponents.blue, b: endColorComponents.blue, fraction: fraction),
                                     alpha: lerp(a: startColorComponents.alpha, b: endColorComponents.alpha, fraction: fraction))
            node.fillColor = transColor
            }
        )
    }
}

extension SKNode {
    func strokeColorTransition(to color: UIColor, duration: CGFloat = 0.15) {
        self.run(SKAction.strokeTransitionColor(of: self, toColor: color, duration: duration))
    }
    
    func fillColorTransition(to color: UIColor, duration: CGFloat = 0.15) {
        self.run(SKAction.fillTransitionColor(of: self, toColor: color, duration: duration))
    }
    
    func spriteColorTransition(to color: UIColor, opacity: CGFloat) {
        self.run(SKAction.colorize(with: color, colorBlendFactor: opacity, duration: 0.15))
    }
    
    func opacityTransition(_ opacity: CGFloat) {
        self.run(SKAction.fadeAlpha(to: opacity, duration: 0.15))
    }
    
    func blueTint() {
        self.enumerateChildNodes(withName: ".//*") { node, _ in
            if node.name?.contains("PIN") ?? false { return }
            node.spriteColorTransition(to: .blue, opacity: 0.5)
            node.strokeColorTransition(to: .canvasBlue)
            node.fillColorTransition(to: (node.parent?.isOccupied() ?? false) ? .canvasBlue : .canvasLightBlue)
        }
    }
    
    func removeTint() {
        self.enumerateChildNodes(withName: ".//*") { node, _ in
            if node.name?.contains("PIN") ?? false { return }
            node.spriteColorTransition(to: .blue, opacity: 0)
            node.fillColorTransition(to: (node.parent?.isOccupied() ?? false) ? .darkGray : .gray)
            guard let scene = self.scene as? CanvasScene,
                  scene.state != .simulate else { return }
            node.strokeColorTransition(to: .darkGray)
            
        }
    }
    
    func colorOccupied(_ isOccupied: Bool) {
        self.enumerateChildNodes(withName: ".//*") { node, _ in
            node.fillColorTransition(to: isOccupied ? .darkGray : .gray)
        }
    }
}



