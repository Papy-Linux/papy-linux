from selenium import webdriver
import json
import bottle

options = webdriver.ChromeOptions()

# Remove "restore pages" popups
with open("~/.config/chromium/Default/Preferences", "r+") as f:
    f.write(f.read().replace('"exited_cleanly":false', '"exited_cleanly":true').replace('"exit_type": "Crashed"', '"exit_type": "Normal"'))

# Start in full screen
options.add_argument("--app=https://www.google.com")

# Use default profile
options.add_argument("--profile-directory=Default")
options.add_argument("user-data-dir=/home/user/.config/chromium")

# Disable popups
options.add_experimental_option("excludeSwitches", ["disable-popup-blocking"])
driver = webdriver.Chrome(options=options)

@bottle.route("/home")
def home():
    driver.get("https://www.google.com")

@bottle.route("/close")
def close():
    driver.close()

bottle.run(host="localhost", port=8080)
