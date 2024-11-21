# discord2roblox
A simple program that uses Lua, Node and Python to allow you to run code on a roblox game remotely through a Discord bot


## Setup

**1. Preparation**

Think about how you're going to host the discord bot and API endpoint. I will show you how to use Glitch for the API endpoint since it's the easiest, but you can also use Glitch for the bot if you so prefer.

**2. Get Discord Info**
Turn on [developer mode](https://beebom.com/how-enable-disable-developer-mode-discord/) on your discord account if you haven't already. Then, find the ID of the role you would like to use for the people who can use the bot - you can do this by right clicking the role name and clicking "Copy Role ID".

Then, get your discord bot's token. If you don't have it, go to the [discord developer portal](https://discord.com/developers/applications), click on the bot in your desired server, go to the "Bot" tab, and click "Reset Token".
**3. Setup API**
As I mentioned earlier, I will be using Glitch here. The files provided in /apihost will work on any hosting provider though.

Go to [Glitch](https://glitch.com), log in/sign up for your account, then make a [new blank node project](https://glitch.com/edit/#!/remix/glitch-blank-node). Make or open a server.js file and paste the code in [apihost/server.js](https://github.com/illumina0001/discord2roblox/blob/main/apihost/server.js) into it (obviously clear it first if there's something there). Do the same for [package.json](https://github.com/illumina0001/discord2roblox/blob/main/apihost/package.json).

Once done, open the terminal and type "node server.js". This should start your server.

Then, get the name of your project (it will be in the URL bar at "glitch.com/edit/#!/(PROJECT NAME)/"). We will use this for our API calls.

**4. Set up Roblox script**
Make a new Script in ServerScriptService in your roblox game and paste the code from [roblox.lua](https://github.com/illumina0001/discord2roblox/blob/main/roblox.lua) into the script. Then, modify the "endpoint" variable with your Glitch project name or hosting URL.

**5. Set up Discord bot**
Download [https://github.com/illumina0001/discord2roblox/blob/main/bot.py](https://github.com/illumina0001/discord2roblox/blob/main/bot.py) onto whatever you'll use to host your bot. Then replace DISCORD_TOKEN with the discord token we got earlier, GLITCH_URL with the same URL you used in the Roblox script in the endpoint variable, and the ROLE_ID with the ID of the role of the people you want to have access to the command. Then, run your bot and enjoy!

## Usage
You can execute any code you want in your Roblox game with !run (code), but if you're going to use it to ban, use !run :ban (username) (reason).

Made with ❤️ by illumina
