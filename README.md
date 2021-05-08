# Evently
## Description
An iOS  application to display and search for sporting/live music events hosted on SeatGeek with persistent heart/unheart functionality. I've taken this project on for practice purposes in order to hone my iOS chops :)
## Installation
(pending)

## Things I've Learned So Far:

- Dependency Injection Via Class Constructors
	- Swift doesn't have Reflection, which means you don't have any good Mocking Libraries like Python or Java.
	  Therefore, you have to do manual, elbow grease dependency injection to test your classes! 
	  It took a long time but I figured out how to create interfaces for my different classes, and inject them
	  into each othervia class inits/constructors so that when I test them, I can mock things given they conform
          to the proper interfaces/protocols. While I knew already why DI was useful from Robert C. Martin's "Clean
          Code" book, I hadn't REALLy had a chance to see why it was so useful until now! So glad I did :) 

- Asynchronous programming can be achieved with callbacks, OR delegation!
	- Since my only other exposure to asynchronous programming was in JavaScript with Ajax, I was confused initially by
	  the way that my Swift teacher, Angela Yu, used delegation in her networking lessons. In this project I decided to
	  do the same for my networking tasks. Turns out that delegation is a whole different way to do async work! Perhaps
          not neccessarily better, but different and perhaps more suited to the protocol based style that Apple prefers in it's
	  frameworks :)

- Security is a constant battle :/
	- Since I'm using the SeatGeek API to populate my events, I also have my own personal clientID and ClientSecret. I couldn't
	  JUST have that out in the code willy nilly, right? So, I added a dependency to the project called CocaopodsKeys! Essentially,
          It allows you to keep your keys encrypted in the library, and add/update them via the command line so that the only things
          in the code are keys.ClientID, for example, instead of the actual string ID or secret. Unfortunately, one COULD just print
          to the console and see the strings at runtime, so the only other method to TRULY keep my secrets secure would be a Cloud
          solution where the environment had extra security features such as AWS permissions. Maybe on the next iteration of the
          project! :)
