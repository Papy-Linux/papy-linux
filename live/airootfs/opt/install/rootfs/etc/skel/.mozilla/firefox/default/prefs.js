// Remove prompt when quitting with CTRL+Q
user_pref("browser.warnOnQuitShortcut", false);

// Set homepage to Google
user_pref("browser.startup.homepage", "https://www.google.com");

// Allow userChrome.css
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);

// Remove first run things
user_pref("app.normandy.first_run", false);
user_pref("browser.aboutwelcome.enabled", false);
user_pref("trailhead.firstrun.didSeeAboutWelcome", true);

// Disable pages restore when Firefox crashed
user_pref("browser.sessionstore.resume_from_crash", false);

// Prevent sites from asking for permissions by default
user_pref("permissions.default.camera", 2);
user_pref("permissions.default.desktop-notification", 2);
user_pref("permissions.default.geo", 2);
user_pref("permissions.default.microphone", 2);
user_pref("permissions.default.xr", 2);
