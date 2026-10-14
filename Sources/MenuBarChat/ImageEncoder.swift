import AppKit

enum ImageEncoder {
    static let maxDimension: CGFloat = 1568

    static func jpegData(from image: NSImage) -> Data? {
        bitmapRep(from: image)?.representation(using: .jpeg, properties: [.compressionFactor: 0.7])
    }

    static func dataURL(fromJPEG data: Data) -> String {
        "data:image/jpeg;base64," + data.base64EncodedString()
    }

    private static func bitmapRep(from image: NSImage) -> NSBitmapImageRep? {
        guard let tiff = image.tiffRepresentation, let source = NSBitmapImageRep(data: tiff) else { return nil }
        let largest = max(source.pixelsWide, source.pixelsHigh)
        guard CGFloat(largest) > maxDimension else { return source }
        let scale = maxDimension / CGFloat(largest)
        let width = max(1, Int(CGFloat(source.pixelsWide) * scale))
        let height = max(1, Int(CGFloat(source.pixelsHigh) * scale))
        guard let rep = NSBitmapImageRep(
            bitmapDataPlanes: nil, pixelsWide: width, pixelsHigh: height,
            bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false,
            colorSpaceName: .deviceRGB, bytesPerRow: 0, bitsPerPixel: 0
        ) else { return nil }
        rep.size = NSSize(width: width, height: height)
        NSGraphicsContext.saveGraphicsState()
        NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: rep)
        NSGraphicsContext.current?.imageInterpolation = .high
        image.draw(in: NSRect(origin: .zero, size: NSSize(width: width, height: height)),
                   from: .zero, operation: .copy, fraction: 1)
        NSGraphicsContext.current = nil
        NSGraphicsContext.restoreGraphicsState()
        return rep
    }
}
