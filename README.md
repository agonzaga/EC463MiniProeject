# EC463MiniProject
#Andre Gonzaga
#Shivani Singh


The goal of the software project is to work in teams of 2 and create an application that
has an authentication login to access a database of humidity and temperature values and plot these
values, while making use of cloud services. 

Initially, the team of Andre Gonzaga and Shivani Singh decided to use the iOS platform to use 
Apple's authentication and iCloud service. However, upon research, learned that Apple's API is not 
available to the public. The team then decided to proceed with Google authentication and Google 
Storage for the sake of uniformity. 

The team used an iOS platform in conjunction of Firebase. Firebase is an app development platform 
provided by Google. Through Firebase, the team create an authentication login and made use of Google 
Storage, which is Google's cloud platform. The Firebase Documentation was an important resource in 
hitting each objective. The team used SQLite, a relational database management system, to create a database 
of the temperature and humidity numbers. 

Firebase stores the users' login credentials. There is a unique UID for each user, which can be accessed
through the Firebase Console. Once the user logs into the application, he/she can "click" a button to create 
the database of values and "click" another button to access and read the textfile of values. These values are 
stored in Google Storage. 

Andre Gonzaga worked on the database and cloud services components of the project; Shivani Singh
worked on the authentication component. Unfortunately, with Xcode and Swift, there isn't an 
automatic merging system for TWO SEPARATE PROJECTS. Both team members got together, and manually combined their 
respective components of the project to https://github.com/agonzaga/EC463MiniProject
Once the 2 projects were combined, version control was possible.
There is a video that captures the use of the application, which will be emailed to Professor Osama, 
because GitHub does not support video uploads. 


<b> How it Works</b>
The main page allows the users to interact with three buttons. One is a generic Google login button. After logging in, the user can create a table on the database with their unique user ID. The last button grabs values from a text file, which is used to simulate a sensor. This button also stores the data into the database. On the next page, the user can tap "Get Next" to receive the next values from the sensor. Lastly, this same buttons stores the text file in the Google cloud.

<b> Flaws </b>
The cloud system does not always work based on the URL indicating the path of the local file. It is pre-set to my directory, which works, but would have to be changed for other users.

The graphing option is also not fully functional yet. Although Swift provides a Charts library, it is not widely used and there are not many resources online past simple tutorials. 
