import AppKit

enum ImageEncoder {
    static let maxDimension: CGFloat = 1568

    static let imageExtensions: Set<String> = [
        "png", "jpg", "jpeg", "gif", "webp", "tiff", "tif", "heic", "bmp",
    ]

    // Some capture flows put only the file path string on the pasteboard;
    // a path-shaped string (absolute path + image extension) marks an image
    // paste whether or not the backing temp file still exists.
    static func isImagePathString(_ text: String) -> Bool {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.hasPrefix("/") else { return false }
        return imageExtensions.contains(URL(fileURLWithPath: trimmed).pathExtension.lowercased())
    }

    static func imageFileURL(fromPathString text: String) -> URL? {
        guard isImagePathString(text) else { return nil }
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard FileManager.default.fileExists(atPath: trimmed) else { return nil }
        return URL(fileURLWithPath: trimmed)
    }

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
