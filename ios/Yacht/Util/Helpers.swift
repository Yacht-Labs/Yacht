//
//  Helpers.swift
//  YachtWallet
//
//  Created by Henry Minden on 4/5/22.
//

import Foundation
import UIKit

func download(url: URL, toFile file: URL, completion: @escaping (Error?) -> Void) {
    // Download the remote URL to a file
    let task = URLSession.shared.downloadTask(with: url) {
        (tempURL, _, error) in
        // Early exit on error
        guard let tempURL = tempURL else {
            completion(error)
            return
        }

        do {
            // Remove any existing document at file
            if FileManager.default.fileExists(atPath: file.path) {
                try FileManager.default.removeItem(at: file)
            }

            // Copy the tempURL to file
            try FileManager.default.copyItem(
                at: tempURL,
                to: file
            )
            completion(nil)
        }

        // Handle potential file system errors
        catch let fileError {
            completion(fileError)
        }
    }

    // Start the download
    task.resume()
}

func loadData(url: URL, completion: @escaping (Data?, Error?, URL) -> Void) {
    // Compute a path to the URL in the cache
    let fileCachePath = FileManager.default.temporaryDirectory
        .appendingPathComponent(
            url.lastPathComponent,
            isDirectory: false
        )
    
    // If the image exists in the cache,
    // load the image from the cache and exit
    
//    do {
//        if let data = try Data(contentsOf: fileCachePath) as Data? {
//            completion(data, nil)
//            return
//        }
//    } catch {
//        completion(nil, error)
//    }

    let offset = DispatchTimeInterval.seconds(Int.random(in: 1..<5))
    DispatchQueue.main.asyncAfter(deadline: .now() + offset) {
        download(url: url, toFile: fileCachePath) { (error) in
            do {
                let data = try Data(contentsOf: fileCachePath)
                completion(data, error, url)
            } catch {
                completion(nil, error, url)
            }
        }
    }
    
    // If the image does not exist in the cache,
    // download the image to the cache

}

