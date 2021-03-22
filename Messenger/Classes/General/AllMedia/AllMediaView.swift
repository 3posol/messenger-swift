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
class AllMediaView: UIViewController {

	@IBOutlet private var collectionView: UICollectionView!

	private var chatId = ""
	private var dbmessages: [DBMessage] = []

	//-------------------------------------------------------------------------------------------------------------------------------------------
	init(chatId: String) {

		super.init(nibName: nil, bundle: nil)

		self.chatId = chatId
	}

	//-------------------------------------------------------------------------------------------------------------------------------------------
	required init?(coder aDecoder: NSCoder) {

		super.init(coder: aDecoder)
	}

	//-------------------------------------------------------------------------------------------------------------------------------------------
	override func viewDidLoad() {

		super.viewDidLoad()
		title = "All Media"

		collectionView.register(UINib(nibName: "AllMediaCell", bundle: nil), forCellWithReuseIdentifier: "AllMediaCell")

		loadMedia()
	}

	// MARK: - Load methods
	//-------------------------------------------------------------------------------------------------------------------------------------------
	func loadMedia() {

		for dbmessage in DBMessage.fetchAll(gqldb, "chatId = ? AND isDeleted = ?", [chatId, false], order: "createdAt") {
			if (dbmessage.type == MessageType.Photo) {
				if (Media.path(photoId: dbmessage.objectId) != nil) {
					dbmessages.append(dbmessage)
				}
			}
			if (dbmessage.type == MessageType.Video) {
				if (Media.path(videoId: dbmessage.objectId) != nil) {
					dbmessages.append(dbmessage)
				}
			}
		}

		collectionView.reloadData()
	}

	// MARK: - User actions
	//-------------------------------------------------------------------------------------------------------------------------------------------
	func actionPhoto(_ dbmessage: DBMessage) {

		if (Media.path(photoId: dbmessage.objectId) != nil) {
			let pictureView = PictureView(chatId: chatId, messageId: dbmessage.objectId)
			present(pictureView, animated: true)
		}
	}

	//-------------------------------------------------------------------------------------------------------------------------------------------
	func actionVideo(_ dbmessage: DBMessage) {

		if let path = Media.path(videoId: dbmessage.objectId) {
			let videoView = VideoView(path: path)
			present(videoView, animated: true)
		}
	}
}

// MARK: - UICollectionViewDataSource
//-----------------------------------------------------------------------------------------------------------------------------------------------
extension AllMediaView: UICollectionViewDataSource {

	//-------------------------------------------------------------------------------------------------------------------------------------------
	func numberOfSections(in collectionView: UICollectionView) -> Int {

		return 1
	}

	//-------------------------------------------------------------------------------------------------------------------------------------------
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

		return dbmessages.count
	}

	//-------------------------------------------------------------------------------------------------------------------------------------------
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AllMediaCell", for: indexPath) as! AllMediaCell

		let dbmessage = dbmessages[indexPath.item]
		cell.bindData(dbmessage)

		return cell
	}
}

// MARK: - UICollectionViewDelegateFlowLayout
//-----------------------------------------------------------------------------------------------------------------------------------------------
extension AllMediaView: UICollectionViewDelegateFlowLayout {

	//-------------------------------------------------------------------------------------------------------------------------------------------
	func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

		let screenWidth = UIScreen.main.bounds.size.width
		return CGSize(width: screenWidth/2, height: screenWidth/2)
	}
}

// MARK: - UICollectionViewDelegate
//-----------------------------------------------------------------------------------------------------------------------------------------------
extension AllMediaView: UICollectionViewDelegate {

	//-------------------------------------------------------------------------------------------------------------------------------------------
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

		collectionView.deselectItem(at: indexPath, animated: true)

		let dbmessage = dbmessages[indexPath.item]
		if (dbmessage.type == MessageType.Photo) {
			actionPhoto(dbmessage)
		}
		if (dbmessage.type == MessageType.Video) {
			actionVideo(dbmessage)
		}
	}
}
