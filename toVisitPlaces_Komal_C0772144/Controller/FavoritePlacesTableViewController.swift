

import UIKit

class FavoritePlacesTableViewController: UITableViewController {
   
        
let defaults = UserDefaults.standard
var editPlace: FavoritePlace?
var favoritePlaces: [FavoritePlace]?
  override func viewDidLoad() {
         super.viewDidLoad()
}

        override func viewWillAppear(_ animated: Bool) {
            loadData()
            self.tableView.reloadData()
            
        }
    //function to load data
     func loadData(){
                 favoritePlaces = [FavoritePlace]()
                 
                 let filePath = getDataFilePath()
                 if FileManager.default.fileExists(atPath: filePath) {
                     
                     do{
                         let fileContent = try String(contentsOfFile: filePath)
                         let contentArray = fileContent.components(separatedBy: "\n")
                         for content in contentArray {
=                             let favoritePlaceContent = content.components(separatedBy: ",")
                             if favoritePlaceContent.count == 6 {
                                 let favoritePlace = FavoritePlace(lat: Double(favoritePlaceContent[0])!, long: Double(favoritePlaceContent[1])!, speed: Double(favoritePlaceContent[2])!, course: Double(favoritePlaceContent[3])!, altitude: Double(favoritePlaceContent[4])!, address: favoritePlaceContent[5])
                                 favoritePlaces?.append(favoritePlace)
                             }
                         }
                         
                     }catch {
                         print(error)
                     }
                 }
             }
    
    //function to get file path
     func getDataFilePath() -> String {
                let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
                
                let filePath = documentPath.appending("/Favorite-Place-Data.txt")
                return filePath
            }
           
          //function to delete data
        func deleteData(_ newArray: [FavoritePlace]){
            
            let filePath = getDataFilePath()
                       
                       var saveString = ""
                       
                       for favoritePlace in newArray {
                           saveString = "\(saveString)\(favoritePlace.lat),\(favoritePlace.long),\(favoritePlace.speed),\(favoritePlace.course),\(favoritePlace.altitude),\(favoritePlace.address)\n"
                       }
                       
                       do{
                           try saveString.write(toFile: filePath, atomically: true, encoding: .utf8)
                       } catch {
                           print(error)
                       }
                       
        }
        
       
        


        override func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }

        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return favoritePlaces?.count ?? 0
        }

        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
                    let favoritePlace = self.favoritePlaces![indexPath.row]
                    let cell = tableView.dequeueReusableCell(withIdentifier: "favoritePlaceCell")
                   
                   cell?.textLabel?.text =  favoritePlace.address
            cell?.detailTextLabel?.text = "Lat: " + String(favoritePlace.lat) + " Long: " + String(favoritePlace.long)
                   

                   return cell!
        }
        

        override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            
            var newArray = self.favoritePlaces!
            
            newArray.remove(at: indexPath.row)
            
            if editingStyle == .delete {
                let alert = UIAlertController(title: "Alert", message: "Are you sure?", preferredStyle: .alert)
                let addAction = UIAlertAction(title: "OK", style: .default) { (UIAlertAction) in
                   
                    self.favoritePlaces?.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                    
                    self.deleteData(newArray)
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            
                alert.addAction(addAction)
                alert.addAction(cancelAction)
                   present(alert, animated: true, completion: nil)
                
            } else if editingStyle == .insert {
              
            }
        }
        
       
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let favoritePlace = self.favoritePlaces![indexPath.row]
            self.editPlace = self.favoritePlaces![indexPath.row]
            
            defaults.set(favoritePlace.lat, forKey: "editLat")
            defaults.set(favoritePlace.long, forKey: "editLong")
            
            let editPlaceViewController = self.storyboard?.instantiateViewController(withIdentifier: "editPlaceViewController") as! EditPlaceViewController

            editPlaceViewController.editPlaceIndex = indexPath.row
            
            self.navigationController?.pushViewController(editPlaceViewController, animated: true)
        }


  

}
