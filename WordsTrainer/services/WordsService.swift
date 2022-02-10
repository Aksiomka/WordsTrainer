//
//  WordsService.swift
//  WordsTrainer
//
//  Created by Svetlana Gladysheva on 15.01.2022.
//

import Foundation

protocol WordsServiceProtocol {
    func getWordDescription(word: String) async throws -> [WordApiModel]
}

enum WordsServiceError: Error {
    case invalidEndpoint
    case invalidResponse
    case parsingError
}

class WordsService {
    private let urlString = "https://api.dictionaryapi.dev/api/v2/entries/en/"
    private let urlSession: URLSession
    
    init(urlSession: URLSession = URLSession.shared) {
      self.urlSession = urlSession
    }
}

extension WordsService: WordsServiceProtocol {
    func getWordDescription(word: String) async throws -> [WordApiModel] {
        guard
            let url = URL(string: "\(urlString)\(word)")
        else {
            throw WordsServiceError.invalidEndpoint
        }
        
        let (data, response) = try await urlSession.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
            throw WordsServiceError.invalidResponse
        }
        
        let jsonDecoder = JSONDecoder()
        do {
            return try jsonDecoder.decode([WordApiModel].self, from: data)
        } catch {
            throw WordsServiceError.parsingError
        }
    }
}
