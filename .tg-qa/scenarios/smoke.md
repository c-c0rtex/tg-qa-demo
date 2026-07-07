# Telebook demo bot — /start, /help and free-text smoke coverage

## TC-T1 — /start shows welcome text with Mini App button
**Type:** passive
**Steps:**
1. Send `/start`
**Expected:**
- Bot replies with the text “Welcome to the hotel booking bot! Hope you enjoy the application I have 🏨”
- The reply message has an inline keyboard with the button "🦄 Open {appName}" (web_app button)

## TC-T2 — /help explains the bot and offers the Mini App button
**Type:** passive
**Steps:**
1. Send `/help`
**Expected:**
- Bot replies with the text “Actually I'm just an example bot, so all I can do is to send you a link to the mini-app 🤖”
- The reply message has an inline keyboard with the button "🦄 Open {appName}" (web_app button)

## TC-T3 — Arbitrary plain text is answered with app launch prompt
**Type:** mutating
**Steps:**
1. Send `hello, can you book me a room?`
**Expected:**
- Bot sends a NEW message with the text “Click the button below to launch an app”
- The reply message has an inline keyboard with the button "🦄 Open {appName}" (web_app button)

## TC-T4 — Repeated /start is idempotent
**Type:** passive
**Steps:**
1. Send `/start`
2. Send `/start`
**Expected:**
- Each `/start` gets its own NEW reply “Welcome to the hotel booking bot! Hope you enjoy the application I have 🏨” (the previous welcome message is NOT edited or deleted)
- Both replies carry the inline keyboard with the button "🦄 Open {appName}"
- No error text appears in the dialog

## TC-T5 — Unknown command falls back to app launch prompt
**Type:** passive
**Steps:**
1. Send `/book`
**Expected:**
- Bot does not crash or stay silent: it replies with the fallback text “Click the button below to launch an app”
- The reply message has an inline keyboard with the button "🦄 Open {appName}" (web_app button)

## TC-T6 — Button on an old /start message remains usable after new activity
**Type:** passive
**Steps:**
1. Send `/start`
2. Send `/help`
3. Click "🦄 Open {appName}" on the FIRST (older) `/start` reply
**Expected:**
- The older `/start` message still shows the “Welcome to the hotel booking bot! Hope you enjoy the application I have 🏨” text with the "🦄 Open {appName}" button intact (message not edited or keyboard removed)
- Clicking the web_app button produces no error message in the dialog (button opens the Mini App; no “stale button” error reply is sent)

## TC-T7 — Free text sent right after /help still gets the app prompt
**Type:** mutating
**Steps:**
1. Send `/help`
2. Send `random text 12345 !@#`
**Expected:**
- Step 1 reply is “Actually I'm just an example bot, so all I can do is to send you a link to the mini-app 🤖” with the "🦄 Open {appName}" button
- Step 2 gets a NEW message “Click the button below to launch an app” with the "🦄 Open {appName}" button — the `/help` reply is NOT edited
