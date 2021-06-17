//
//  DHash.swift
//  DHash
//
//  Created by Andreas Verhoeven on 13/05/2021.
//

import UIKit

extension UIImage {

	/// Compares two images using a dhash implementation.
	///
	/// - Parameters:
	///		- otherImage: the image to compare to
	///		- treshold: **optional** the number of bits in the dhash to use as a treshold
	/// Result: true if the images seem similar
	public func seemsSimilarTo(_ otherImage: UIImage, treshold: Int = 5) -> Bool {
		let size = CGSize(width: 9, height: 8) // we use 64bit hashes, so 8x8, but 1 pixel because we compare pixels with the adjacent pixel

		let selfDhash = self.dhashForSize(size)
		let otherDhash = otherImage.dhashForSize(size)

		let hammingDistance = (selfDhash ^ otherDhash).nonzeroBitCount
		return hammingDistance < treshold
	}

	private func dhashForSize(_ size: CGSize) -> UInt64 {
		guard let cgImage = cgImage else { return 0 }

		let width = Int(size.width)
		let height = Int(size.height)

		let bytesPerPixel = 4
		let bitsPerComponent = 8
		let bytesPerRow = bytesPerPixel * width
		let options = CGImageAlphaInfo.premultipliedLast.rawValue | CGImageByteOrderInfo.order32Big.rawValue
		guard let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: options) else { return 0 }

		context.draw(cgImage, in: CGRect(origin: .zero, size: size))
		guard let data = context.data else { return 0 }

		var hash: UInt64 = 0
		var bitIndex = 0
		var offset = 0

		for _ in 0..<height - 1 {
			for _ in 0..<width - 1 {
				let leftRed = data.load(fromByteOffset: offset, as: UInt8.self)
				let leftGreen = data.load(fromByteOffset: offset + 1, as: UInt8.self)
				let leftBlue = data.load(fromByteOffset: offset + 2, as: UInt8.self)
				// we skip alpha
				offset += bytesPerPixel

				let leftGrayScaled = (CGFloat(leftRed) + CGFloat(leftGreen) + CGFloat(leftBlue)) / 3.0

				let rightRed = data.load(fromByteOffset: offset, as: UInt8.self)
				let rightGreen = data.load(fromByteOffset: offset + 1, as: UInt8.self)
				let rightBlue = data.load(fromByteOffset: offset + 2, as: UInt8.self)
				// we skip alpha

				let rightGrayScaled = (CGFloat(rightRed) + CGFloat(rightGreen) + CGFloat(rightBlue)) / 3.0
				if leftGrayScaled > rightGrayScaled {
					hash |= (1 << bitIndex)
				}
				bitIndex += 1
			}
			offset += bytesPerPixel // skip last column
		}

		return hash
	}
}
