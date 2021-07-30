//
//  PlayListViewController.swift
//  PLMusic
//
//  Created by 連振甫 on 2021/7/30.
//

import UIKit

class PlayListViewController: UITableViewController {

    var musicData = [Music]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return musicData.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MusicCell", for: indexPath) as! MusicCell

        // Configure the cell...
        let music = musicData[indexPath.row]
        cell.artistImageView.setImage(by: music.artworkUrl100)
        cell.artistNameLabel.text = music.artistName
        cell.trackNameLabel.text = music.trackName
        

        return cell
    }
    
    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UIImageView {
    
    var cacheImage: NSCache<NSURL,UIImage>{
        return NSCache()
    }
    
    
    func setImage(by url:URL) {
        
        if let cacheImage = cacheImage.object(forKey: url as NSURL) {
            self.image = cacheImage
            return
        }
        URLSession.shared.dataTask(with: url, completionHandler: {[weak self] data,response,error in
            guard let self = self,let data = data, let image = UIImage(data: data) else {
                return
            }
            self.cacheImage.setObject(image, forKey: url as NSURL)
            DispatchQueue.main.async {
                self.image = image
            }
            
        }).resume()
    }
}
