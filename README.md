# Evently

## Description
An iOS  application to display and search for sporting/live music events hosted by the SeatGeek API. 
I've taken this project on for practice purposes in order to hone my iOS chops :)
## Installation
1. Clone the repository
2. To get the SeatGeek API used inside of the app to work, you'll need to generate your own 
   client ID and client Secret. to do that, follow the instructions 
   [here](https://seatgeek.com/?next=%2Faccount%2Fdevelop#login). 
   P.S. You'll need to create an account with them. 
3. Once you have your own client ID and Secret, run the following terminal command 
   in the root of the project directory to set up the dependencies:
   ```
   pod install
   ```
4. You'll be prompted for your client ID and Secret. Enter them and the pod install command 
   should continue and finish up.
6. Next, just open the project using the latest version of XCode and you are good to go! :)


## Things I've Learned Because of This Project:

- Dependency Injection Via Class Constructors
	- Swift doesn't have Reflection, which means you don't have any good Mocking Libraries like Python or Java.
	  Therefore, you have to do manual, elbow grease dependency injection to test your classes! 
	  It took a long time but I figured out how to create interfaces for my different classes, and inject them
	  into each other via class inits/constructors so that when I test them, I can mock things given they conform
          to the proper interfaces/protocols. While I knew already why DI was useful from Robert C. Martin's "Clean
          Code" book, I hadn't REALLy had a chance to see why it was so useful until now! So glad I did :) 

- Asynchronous programming can be achieved with callbacks, OR delegation!
	- Since my only other exposure to asynchronous programming was in JavaScript with Ajax, I was confused initially by
	  the way that my Swift teacher, Angela Yu, used delegation in her networking lessons. In this project I decided to
	  do the same for my networking tasks. Turns out that delegation is a whole different way to do async work! Perhaps
          not neccessarily better, but different and perhaps more suited to the protocol based style that Apple prefers in it's
	  frameworks :)
	  
- Caching Images downloaded from the Internet
	- Since my table view for events was creating images pulled from the internet, I wanted to minimize the number of network
	  calls made for those images. So, I created an app wide image loader and UIImageView caching system so that requests would
	  only be made if absolutely necessary. Unfortunately, I think that that came at the cost of a growing memory usage for the app
	  that in a real production system (i.e., on a real iOS operating system on a user's phone) would have my app killed in the background. 
	  Next time something like this comes up I will probably just use a third party TableView Caching dependency that handles those 
	  memory spikes far better than I can :)

- Security is a constant battle :/
	- Since I'm using the SeatGeek API to populate my events, I also have my own personal clientID and ClientSecret. I couldn't
	  JUST have that out in the code willy nilly, right? So, I added a dependency to the project called CocaopodsKeys! Essentially,
          It allows you to keep your keys encrypted in the library, and add/update them via the command line so that the only things
          in the code are keys.ClientID, for example, instead of the actual string ID or secret. Unfortunately, one COULD just print
          to the console and see the strings at runtime, so the only other method to TRULY keep my secrets secure would be a Cloud
          solution where the environment had extra security features such as AWS permissions. Maybe on the next iteration of the
          project! :)
	  
- Modularity is Golden
	- Given the interfaces I created to implement dependency injection, I was forced to split up different functionalities into their own
	  modules. This had the awesome side effect of making things "Do One Thing Well", on top of DRY ("Don't Repeat Yourself"). After this
	  project I really do feel like I have a much more intuitive feel for encapsulation than I did previously :). It just made adding new
	  things really really easy as the project moved along!

