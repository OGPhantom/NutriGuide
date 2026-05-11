import Foundation

enum APIConfiguration {
    static var openAIAPIKey: String {
        Bundle.main.object(forInfoDictionaryKey: "OPENAI_API_KEY") as? String ?? ""
    }
}
