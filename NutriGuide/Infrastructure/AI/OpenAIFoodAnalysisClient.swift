import Foundation
import UIKit

enum OpenAIFoodAnalysisError: LocalizedError {
    case missingAPIKey
    case invalidImage
    case invalidResponse
    case apiError(String)
    case emptyOutput
    case noMealDetected

    var errorDescription: String? {
        switch self {
        case .missingAPIKey:
            "Missing OpenAI API key."
        case .invalidImage:
            "The selected image could not be prepared."
        case .invalidResponse:
            "OpenAI returned an invalid response."
        case .apiError(let message):
            message
        case .emptyOutput:
            "OpenAI returned no food analysis."
        case .noMealDetected:
            "No meal detected."
        }
    }
}

struct OpenAIFoodAnalysisClient {
    var apiKey: String
    var model: String = "gpt-4.1-mini"
    var session: URLSession = .shared

    init(apiKey: String = APIConfiguration.openAIAPIKey) {
        self.apiKey = apiKey
    }

    func analyzeFoodImage(_ imageData: Data) async throws -> FoodAnalysisDraft {
        guard !apiKey.isEmpty, !apiKey.contains("$(") else {
            throw OpenAIFoodAnalysisError.missingAPIKey
        }

        guard let optimizedImage = ImagePayloadOptimizer.optimizedJPEGData(from: imageData) else {
            throw OpenAIFoodAnalysisError.invalidImage
        }

        var request = URLRequest(url: URL(string: "https://api.openai.com/v1/responses")!)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody(base64Image: optimizedImage.base64EncodedString()))

        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw OpenAIFoodAnalysisError.invalidResponse
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            if let error = try? JSONDecoder().decode(OpenAIErrorEnvelope.self, from: data) {
                throw OpenAIFoodAnalysisError.apiError(error.error.message)
            }

            throw OpenAIFoodAnalysisError.apiError("OpenAI request failed with HTTP \(httpResponse.statusCode).")
        }

        let responseEnvelope = try JSONDecoder().decode(OpenAIResponsesEnvelope.self, from: data)
        guard let outputText = responseEnvelope.outputText else {
            throw OpenAIFoodAnalysisError.emptyOutput
        }

        if outputText.isNoMealDetectedResponse {
            throw OpenAIFoodAnalysisError.noMealDetected
        }

        let analysis = try JSONDecoder().decode(OpenAIFoodAnalysisResponse.self, from: Data(outputText.utf8))
        if analysis.isNoMealDetected {
            throw OpenAIFoodAnalysisError.noMealDetected
        }

        return analysis.draft
    }

    private func requestBody(base64Image: String) -> [String: Any] {
        [
            "model": model,
            "input": [
                [
                    "role": "user",
                    "content": [
                        [
                            "type": "input_text",
                            "text": """
                            Analyze this meal photo and estimate nutrition values.
                            Return only the structured result requested by the schema.
                            Use grams for ingredient portions when possible.
                            If there is no clearly visible meal or food, set name exactly to "no meal detected", set all nutrition values to 0, and return an empty ingredients array.
                            """
                        ],
                        [
                            "type": "input_image",
                            "image_url": "data:image/jpeg;base64,\(base64Image)",
                            "detail": "low"
                        ]
                    ]
                ]
            ],
            "text": [
                "format": [
                    "type": "json_schema",
                    "name": "food_analysis",
                    "strict": true,
                    "schema": foodAnalysisSchema
                ]
            ]
        ]
    }

    private var foodAnalysisSchema: [String: Any] {
        [
            "type": "object",
            "additionalProperties": false,
            "properties": [
                "name": ["type": "string"],
                "calories": ["type": "number"],
                "protein": ["type": "number"],
                "fat": ["type": "number"],
                "carbs": ["type": "number"],
                "ingredients": [
                    "type": "array",
                    "items": [
                        "type": "object",
                        "additionalProperties": false,
                        "properties": [
                            "name": ["type": "string"],
                            "amount": ["type": "number"],
                            "unit": ["type": "string"],
                            "calories": ["type": "number"]
                        ],
                        "required": ["name", "amount", "unit", "calories"]
                    ]
                ]
            ],
            "required": ["name", "calories", "protein", "fat", "carbs", "ingredients"]
        ]
    }
}

private enum ImagePayloadOptimizer {
    static func optimizedJPEGData(from data: Data) -> Data? {
        guard let image = UIImage(data: data) else { return nil }

        let maxDimension: CGFloat = 768
        let scale = min(maxDimension / image.size.width, maxDimension / image.size.height, 1)
        let targetSize = CGSize(width: image.size.width * scale, height: image.size.height * scale)
        let renderer = UIGraphicsImageRenderer(size: targetSize)

        let resized = renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: targetSize))
        }

        return resized.jpegData(compressionQuality: 0.72)
    }
}

private struct OpenAIErrorEnvelope: Decodable {
    let error: APIError

    struct APIError: Decodable {
        let message: String
    }
}

private struct OpenAIResponsesEnvelope: Decodable {
    let output: [OutputItem]

    var outputText: String? {
        output
            .flatMap(\.content)
            .first(where: { $0.type == "output_text" })?
            .text
    }

    struct OutputItem: Decodable {
        var content: [ContentItem]

        enum CodingKeys: String, CodingKey {
            case content
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            content = (try? container.decode([ContentItem].self, forKey: .content)) ?? []
        }
    }

    struct ContentItem: Decodable {
        let type: String
        let text: String?
    }
}

private struct OpenAIFoodAnalysisResponse: Decodable {
    let name: String
    let calories: Double
    let protein: Double
    let fat: Double
    let carbs: Double
    let ingredients: [IngredientResponse]

    var isNoMealDetected: Bool {
        name.isNoMealDetectedResponse
    }

    var draft: FoodAnalysisDraft {
        FoodAnalysisDraft(
            name: name,
            calories: calories,
            protein: protein,
            fat: fat,
            carbs: carbs,
            ingredients: ingredients.map(\.draft)
        )
    }

    struct IngredientResponse: Decodable {
        let name: String
        let amount: Double
        let unit: String
        let calories: Double

        var draft: IngredientDraft {
            IngredientDraft(name: name, amount: amount, unit: unit, calories: calories)
        }
    }
}

private extension String {
    var isNoMealDetectedResponse: Bool {
        trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
            .contains("no meal detected")
    }
}
