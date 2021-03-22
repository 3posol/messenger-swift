//
// Copyright (c) 2021 Related Code - https://relatedcode.com
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit

//-----------------------------------------------------------------------------------------------------------------------------------------------
class AllMediaCell: UICollectionViewCell {

	@IBOutlet private var imageItem: UIImageView!
	@IBOutlet private var imageVideo: UIImageView!

	//-------------------------------------------------------------------------------------------------------------------------------------------
	func bindData(_ dbmessage: DBMessage) {

		imageItem.image = nil

		if (dbmessage.type == MessageType.Photo) {
			bindPicture(dbmessage)
		}
		if (dbmessage.type == MessageType.Video) {
			bindVideo(dbmessage)
		}
	}

	//-------------------------------------------------------------------------------------------------------------------------------------------
	func bindPicture(_ dbmessage: DBMessage) {

		imageVideo.isHidden = true

		if let path = Media.path(photoId: dbmessage.objectId) {
			imageItem.image = UIImage.image(path, size: 160)
		}
	}

	//-------------------------------------------------------------------------------------------------------------------------------------------
	func bindVideo(_ dbmessage: DBMessage) {

		imageVideo.isHidden = false

		if let path = Media.path(videoId: dbmessage.objectId) {
			DispatchQueue(label: "bindVideo").async {
				let thumbnail = Video.thumbnail(path: path)
				DispatchQueue.main.async {
					self.imageItem.image = thumbnail.square(to: 160)
				}
			}
		}
	}
}
