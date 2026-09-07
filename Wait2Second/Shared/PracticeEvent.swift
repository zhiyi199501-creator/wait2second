import Foundation

struct PracticeEvent: Codable, Equatable, Identifiable {
    var id: UUID
    var date: Date

    init(id: UUID = UUID(), date: Date = Date()) {
        self.id = id
        self.date = date
    }

    init(from decoder: Decoder) throws {
        if let date = try? decoder.singleValueContainer().decode(Date.self) {
            self.id = UUID()
            self.date = date
            return
        }

        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        date = try container.decode(Date.self, forKey: .date)
    }
}
