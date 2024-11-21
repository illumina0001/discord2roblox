import discord
import requests

DISCORD_TOKEN = ""
GLITCH_URL = "https://(PROJECT NAME).glitch.me/execute"
ROLE_ID = 12345 # ID of the role in your discord server that you want people to have to be able to use the command


intents = discord.Intents.default()
intents.message_content = True
client = discord.Client(intents=intents)

def getid(username):
    try:
        response = requests.post("https://users.roblox.com/v1/usernames/users", json={"usernames": [username]})
        if response.status_code == 200:
            data = response.json()
            if "data" in data and len(data["data"]) > 0:
                return data["data"][0]["id"]
        else:
            print(f"Failed to get user ID for {username}: {response.status_code} - {response.text}")
    except Exception as e:
        print(f"Error fetching user ID: {e}")
    return None

@client.event
async def on_ready():
    print(f"Logged in as {client.user}!")

@client.event
async def on_message(message):
    if message.author.bot:
        return
    if all(role.id != ROLE_ID for role in message.author.roles):
        await message.channel.send("You do not have access to this command.")
        return
    if message.content.startswith("!run"):
        command = message.content[5:].strip()

        if command.startswith(":ban") or command.startswith(":unban"):
            parts = command.split(" ", 2)
            if len(parts) < 2:
                await message.channel.send("Please provide a username.")
                return

            username = parts[1]
            reason = parts[2] if len(parts) > 2 else None

            
            user_id = getid(username)
            if user_id:
                
                command = f"{parts[0]} {user_id}"
                if reason:
                    command += f" {reason}"
            else:
                await message.channel.send(f"Failed to find ID for username: {username}")
                return

        if not command:
            await message.channel.send("Please provide code to run.")
            return

        try:
            response = requests.post(GLITCH_URL, json={"command": command})
            if response.status_code == 200:
                result = response.json()
                if result.get("status") == "success":
                    await message.channel.send("Done")
                else:
                    await message.channel.send(f"Failed to execute command: {result.get('message', 'Unknown error')}")
            else:
                await message.channel.send("Error communicating with the Roblox server")
        except Exception as e:
            print(f"Error: {e}")
            await message.channel.send("An error occurred while sending the command")

client.run(DISCORD_TOKEN)
