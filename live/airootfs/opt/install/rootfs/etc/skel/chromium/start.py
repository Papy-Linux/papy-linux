from selenium import webdriver
import json
import bottle

options = webdriver.ChromeOptions()
options.add_argument("--app=https://www.google.com")
driver = webdriver.Chrome(options=options)

@bottle.route("/home")
def home():
    driver.get("https://www.google.com")

@bottle.route("/close")
def close():
    driver.close()

bottle.run(host="localhost", port=8080)
