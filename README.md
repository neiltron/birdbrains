# BIRDBRAINS
A read-only, Twitter API clone implemented as a front-end to another service. I made this so I could use Twitter's iPhone client to view activity on another service. It requires database/filesystem access to said service, but could be modified to act as a proxy.

## I don't recommend you use this.
It works well for me and is totally awesome. Avatars work and you can display as many image assets in a post as you want! Kinda rad. The 140 character limit isn't enforced by the iPhone client's display code, so you can basically go wild with posts.

However, I guarantee you will have to manually hack on this to get it to work for you. It's opinionated. It's using Mongo, S3, and assumes that your user authentication is based on email addresses.

It's also not secure in any way. The OAuth endpoint is barely there, doesn't check for a password, and assigns the same access token to everyone. It's just enough to satisfy the Twitter client. You've been warned.

## Having said that…
If you feel like giving it a go:

- Drop in your own models for Posts, Users, Assets, and Avatars
- Edit your Mongo and S3 credentials (See .powenv for examples. These can be used as a template for your ENV vars on Heroku, etc)
- Alternatively, delete the Asset/Avatar code to go text only. Or Tear out Mongoid in favor of ActiveRecord. Or flat text files. Whatever you want to do, chief.

To add your account to the Twitter iPhone app (might work on other Android, etc. as well?):

- Add a new account
- In the Username field, enter your email address and replace the "@" with an "&". I.e., your@email.com becomes your&email.com. (This is because Twitter will die a horrible death trying to interpret the @'s in "@your@email.com").
- Tap the little settings icon in the bottom right
- In the API root field, enter your server's address. If you're using Pow, this will probably be "http://birdbrains.dev".

## License
glhf homie.