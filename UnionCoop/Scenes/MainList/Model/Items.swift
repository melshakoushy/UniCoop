/* 
Copyright (c) 2021 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct Items : Codable {
	let tags : [String]?
	let owner : Owner?
	let is_answered : Bool?
	let view_count : Int?
	let answer_count : Int?
	let score : Int?
	let last_activity_date : Int?
	let creation_date : Int?
	let question_id : Int?
	let content_license : String?
	let link : String?
	let title : String?

	enum CodingKeys: String, CodingKey {

		case tags = "tags"
		case owner = "owner"
		case is_answered = "is_answered"
		case view_count = "view_count"
		case answer_count = "answer_count"
		case score = "score"
		case last_activity_date = "last_activity_date"
		case creation_date = "creation_date"
		case question_id = "question_id"
		case content_license = "content_license"
		case link = "link"
		case title = "title"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		tags = try values.decodeIfPresent([String].self, forKey: .tags)
		owner = try values.decodeIfPresent(Owner.self, forKey: .owner)
		is_answered = try values.decodeIfPresent(Bool.self, forKey: .is_answered)
		view_count = try values.decodeIfPresent(Int.self, forKey: .view_count)
		answer_count = try values.decodeIfPresent(Int.self, forKey: .answer_count)
		score = try values.decodeIfPresent(Int.self, forKey: .score)
		last_activity_date = try values.decodeIfPresent(Int.self, forKey: .last_activity_date)
		creation_date = try values.decodeIfPresent(Int.self, forKey: .creation_date)
		question_id = try values.decodeIfPresent(Int.self, forKey: .question_id)
		content_license = try values.decodeIfPresent(String.self, forKey: .content_license)
		link = try values.decodeIfPresent(String.self, forKey: .link)
		title = try values.decodeIfPresent(String.self, forKey: .title)
	}

}