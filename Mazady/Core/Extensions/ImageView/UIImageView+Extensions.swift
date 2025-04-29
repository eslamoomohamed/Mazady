//
//  UIImageView+Extensions.swift
//  Mazady
//
//  Created by eslam mohamed on 29/04/2025.
//

import UIKit

extension UIImageView {
    func downloadImage(from url: String, uuid: UUID) {
        ImageLoader.shared.downloadImage(from: url, uuid: uuid) { [weak self] result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self?.image = image
                }
            case .failure(let failure):
                print(failure)
            }
        }
    }

    func cancelDownload(for uuid: UUID) {
        ImageLoader.shared.cancelDownload(for: uuid)
    }
}


protocol IImageLoader {
    func downloadImage(from url: String, uuid: UUID, completion: @escaping (Result<UIImage, Error>) -> Void)
    func cancelDownload(for uuid: UUID)
}

class ImageLoader: IImageLoader {

    static let shared = ImageLoader()

    private var runningTasks: [UUID: URLSessionDataTask] = [:]

    private init() {}

    func downloadImage(from url: String, uuid: UUID, completion: @escaping (Result<UIImage, Error>) -> Void) {
        guard let url = URL(string: url) else { return }
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            defer { self?.runningTasks.removeValue(forKey: uuid) }
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data, let image = UIImage(data: data) else {
                let error = NSError(domain: "ImageLoader", code: 0)
                completion(.failure(error))
                return
            }
            completion(.success(image))
            return
        }
        runningTasks[uuid] = task
        print("downloadImage \(runningTasks)")
        task.resume()
    }
    
    func cancelDownload(for uuid: UUID) {
        if let task = runningTasks[uuid] {
            task.cancel()
            runningTasks.removeValue(forKey: uuid)
            print("cancelDownload\(runningTasks)")
        }
    }
    
    
}
