//
//  Service.swift
//  CommitList
//
//  Created by Jing Zhao on 1/28/21.
//

import Foundation

class Service {
    static let shared = Service()
    
    func getResults(page: Int, completion: @escaping (Result<[CommitResult], ErrorMSG>) -> ()) {
        let parameter = "?page=\(page)&per_page=25"
        
        let urlString = "https://api.github.com/repos/0ldyellowbricks/commitsList/commits" + parameter
//        let urlString = "https://api.github.com/repos/SDWebImage/SDWebImage/commits" + parameter
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let _ = error {
                completion(.failure(.invalidData))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let results = try decoder.decode([CommitResult].self, from: data)
                completion(.success(results))
            } catch {
                completion(.failure(.invalidData))
            }
        }.resume()
    }
}
