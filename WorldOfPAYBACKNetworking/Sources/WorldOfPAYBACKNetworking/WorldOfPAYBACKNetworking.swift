
import Foundation
import Combine

public protocol HTTPClientProtocol {
    var baseURL: String { get }
    func get<T: Decodable>(endpoint: ServiceEndpointsProtocol) -> AnyPublisher<T, APIError>
}

public final class URLSessionHTTPClient: HTTPClientProtocol {
    private let session: URLSession
    public let baseURL: String
    
    public init(baseURL: String = ProcessInfo.processInfo.environment["base-url"] ?? "",
                session: URLSession = .shared) {
        self.session = session
        self.baseURL = baseURL
    }
    
    public func get<T: Decodable>(endpoint: ServiceEndpointsProtocol) -> AnyPublisher<T, APIError> {
        guard let url = URL(string: "\(baseURL)")?.appendingPathComponent(endpoint.path) else {
            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
        }
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        for (key, value) in endpoint.headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        return session.dataTaskPublisher(for: request)
            .tryMap { output in
                if let httpResponse = output.response as? HTTPURLResponse,
                   (200..<300).contains(httpResponse.statusCode) {
                    return output.data
                } else {
                    let statusCode = (output.response as? HTTPURLResponse)?.statusCode ?? -1
                    throw APIError.requestFailed("Request failed with status code: \(statusCode)")
                }
            }
            .decode(type: T.self, decoder: Decoders.mainDecoder)
            .mapError { error -> APIError in
                if error is DecodingError {
                    return APIError.decodingFailed
                } else if let apiError = error as? APIError {
                    return apiError
                } else {
                    return APIError.requestFailed("An unknown error occurred.")
                }
            }
            .eraseToAnyPublisher()
    }
}
