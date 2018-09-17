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

import Foundation
import SQLite3
import PlaygroundSupport

destroyPart1Database()

/*:
 
 # Getting Started
 
 The first thing to do is set your playground to run manually rather than automatically. This will help ensure that your SQL commands run when you intend them to. At the bottom of the playground click and hold the Play button until the dropdown menu appears. Choose "Manually Run".
 
 You will also notice a `destroyPart1Database()` call at the top of this page. You can safely ignore this, the database file used is destroyed each time the playground is run to ensure all statements execute successfully as you iterate through the tutorial.
 
 Secondly, this Playground will need to write SQLite database files to your file system. Create the directory `~/Documents/Shared Playground Data/SQLiteTutorial` by running the following command in Terminal.
 
 `mkdir -p ~/Documents/Shared\ Playground\ Data/SQLiteTutorial`
 
 */

//: ## Open a Connection
let createTableString = """
CREATE TABLE User1(
Temperature INT PRIMARY KEY NOT NULL,
Humidity INT NOT NULL);
"""

let insertStatementString = "INSERT INTO Contact (Id, Name) VALUES (?, ?);"
let queryStatementString = "SELECT * FROM Contact;"




func openDatabase() -> OpaquePointer? {
    var db: OpaquePointer? = nil
    if sqlite3_open(part1DbPath, &db) == SQLITE_OK {
        print("Successfully opened connection to database at \(part1DbPath)")
        return db
    } else {
        print("Unable to open database. Verify that you created the directory described " +
            "in the Getting Started section.")
        PlaygroundPage.current.finishExecution()
    }
    
}


func createTable() {
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


func insert() {
    var insertStatement: OpaquePointer? = nil
    
    // 1
    if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
        let id: Int32 = 1
        let name: NSString = "Ray"
        
        // 2
        sqlite3_bind_int(insertStatement, 1, id)
        // 3
        sqlite3_bind_text(insertStatement, 2, name.utf8String, -1, nil)
        
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


func query() {
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

//: ## Create a Table
let db = openDatabase()

createTable()
insert()
query()
//: ## Insert a Contact

//: ## Querying

//: ## Update

//: ## Delete

//: ## Errors

//: ## Close the database connection

//: Continue to [Making It Swift](@next)

