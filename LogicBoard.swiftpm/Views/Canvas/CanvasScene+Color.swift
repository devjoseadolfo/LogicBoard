import SpriteKit

// Derived from solutions found in https://stackoverflow.com/questions/35029672/getting-pixel-color-from-an-image-using-cgpoint

extension CGImage {
    func getPixelColor(point: CGPoint) -> CGColor? {
        
        guard let provider = self.dataProvider, let pixelData = provider.data else { return nil }
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
        let pixelInfo: Int = ((Int(self.width) * Int(point.y)) + Int(point.x)) * 4
        let r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
        let g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
        let b = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
        let a = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)
        
        return CGColor(red: r, green: g, blue: b, alpha: a)
    }
}

func lerp(a : CGFloat, b : CGFloat, fraction : CGFloat) -> CGFloat
{
    return (b-a) * fraction + a
}

// Custom color transition for SKShapeNode derived from solution by OwlOCR and Patrick Collin
// https://stackoverflow.com/questions/20872556/skshapenode-animate-color-change

struct ColorComponents {
    var red = CGFloat.zero
    var green = CGFloat.zero
    var blue = CGFloat.zero
    var alpha = CGFloat.zero
}

extension UIColor {
    func toComponents() -> ColorComponents {
        var components = ColorComponents()
        getRed(&components.red, green: &components.green, blue: &components.blue, alpha: &components.alpha)
        return components
    }
}
