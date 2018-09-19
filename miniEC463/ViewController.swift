/// Copyright (c) 2017 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit
import Foundation
import SQLite3
import Firebase
import FirebaseAuth
import GoogleSignIn


class ViewController: UIViewController, GIDSignInUIDelegate {
    // Global Variables
    let fileName = "values.txt"
    let dbPath = "Users/andregonzaga/Desktop/miniProjectDB"
    let insertStatementString = "INSERT INTO User1 (Temperature, Humidity) VALUES (?, ?);"
    let queryStatementString = "SELECT * FROM Contact;"
    var itemsArray: Array<Substring> = ["1111", "2222"]
    var ind = 0
    
    struct GlobalVariables {
        static var itemsArray: Array<Substring> = ["1111", "2222"]
    }
    
    // Functions
    // Login
    fileprivate func setGoogleSignIn(){
        //google
        let googleSignIn = GIDSignInButton()
        googleSignIn.frame = CGRect(x: 16, y: 62, width: view.frame.width - 32, height: 50)
        view.addSubview(googleSignIn)
        
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGoogleSignIn()
    }ß
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func openDatabase() -> OpaquePointer? {
        var db: OpaquePointer? = nil
        if sqlite3_open(dbPath, &db) == SQLITE_OK {
            print("Successfully opened connection to database at \(dbPath)")
            return db
        } else {
            print("Unable to open database. Verify that you created the directory described")
            return db
        }
    }
    
    func createTable(db: OpaquePointer?, createTableString: String) {
        // 1
        var createTableStatement: OpaquePointer? = nil
        // 2
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK {
            // 3
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("Contact table created.")
            } else {
                print("Contact table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        // 4
        sqlite3_finalize(createTableStatement)
    }
    
    func insert(db: OpaquePointer?, temp: Int, humidity: Int ) {
        var insertStatement: OpaquePointer? = nil
        
        // 1
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            
            // 2
            sqlite3_bind_int(insertStatement, 1, Int32(temp))
            // 3
            sqlite3_bind_int(insertStatement, 2, Int32(humidity))
            
            // 4
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        // 5
        sqlite3_finalize(insertStatement)
    }
    
    func query(db: OpaquePointer?) {
        var queryStatement: OpaquePointer? = nil
        // 1
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            // 2
            if sqlite3_step(queryStatement) == SQLITE_ROW {
                // 3
                let id = sqlite3_column_int(queryStatement, 0)
                
                // 4
                let queryResultCol1 = sqlite3_column_text(queryStatement, 1)
                let name = String(cString: queryResultCol1!)
                
                // 5
                print("Query Result:")
                print("\(id) | \(name)")
                
            } else {
                print("Query returned no results")
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        
        // 6
        sqlite3_finalize(queryStatement)
    }
    
    
    
    // Buttons
    @IBAction func getValuesButton(_ sender: Any) {
        if let path = Bundle.main.path(forResource: fileName, ofType: nil) {
            do {
                let text = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
                let splitText = text.split(separator: "\n")
                GlobalVariables.itemsArray = splitText
                var db: OpaquePointer? = nil
                let createTableString = """
                    CREATE TABLE User1(
                    Temperature INT PRIMARY KEY NOT NULL,
                    Humidity INT NOT NULL);
                    """
                
                db = openDatabase()
                createTable(db: db, createTableString: createTableString)
                for item in splitText {
                    let secondSplit = item.split(separator: " ")
                    let temp = Int(secondSplit[0])
                    let humidity = Int(secondSplit[1])
                    insert(db: db, temp: temp!, humidity: humidity!)
                }
            } catch {
                print("Failed to read text from \(fileName)")
            }
        } else {
            print("Failed to load file from app bundle \(fileName)")
        }
    }
    
    
    @IBAction func activateSensorButton(_ sender: Any) {
        // Cloud
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let localFile = URL(string: "Users/andregonzaga/Desktop/values.txt")!
        let dbRef = storageRef.child("database")
        let spaceRef = storageRef.child("database/values.txt")
    
        // Upload the file to the path "images/rivers.jpg"
        let uploadTask = spaceRef.putFile(from: localFile, metadata: nil) { metadata, error in
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                return
            }
            // Metadata contains file metadata such as size, content-type.
            let size = metadata.size
            // You can also access to download URL after upload.
            storageRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    // Uh-oh, an error occurred!
                    return
                }
            }
        }
        
        
        
        
    }
    
    
    
    
    
    // Text Fields
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var humLabel: UILabel!
    
    @IBAction func buttonPressed(sender: AnyObject) {
        let currentValues = GlobalVariables.itemsArray[ind].split(separator: " ")
        print(currentValues)
        tempLabel.text = String(currentValues[0])
        humLabel.text = String(currentValues[1])
        ind = ind + 1
        
    }
   
 

    
    
}

