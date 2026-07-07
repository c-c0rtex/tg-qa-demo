# tg-qa run report

**4/7 passed**

| spec | TC | role | status |
|---|---|---|---|
| tc-t1-start-shows-welcome-text-with-mini-app-button.yaml | TC-T1 | - | ❌ fail |
| tc-t2-help-explains-the-bot-and-offers-the-mini-app-button.yaml | TC-T2 | - | ✅ pass |
| tc-t3-arbitrary-plain-text-is-answered-with-app-launch-prompt.yaml | TC-T3 | - | ✅ pass |
| tc-t4-repeated-start-is-idempotent.yaml | TC-T4 | - | ❌ fail |
| tc-t5-unknown-command-falls-back-to-app-launch-prompt.yaml | TC-T5 | - | ✅ pass |
| tc-t6-button-on-an-old-start-message-remains-usable-after-new-acti.yaml | TC-T6 | - | ❌ fail |
| tc-t7-free-text-sent-right-after-help-still-gets-the-app-prompt.yaml | TC-T7 | - | ✅ pass |

## Failures

### tc-t1-start-shows-welcome-text-with-mini-app-button.yaml — TC-T1
```
step 1: no button containing '🦄 Open' on keyboard []
```
<details><summary>dialog</summary>

- **you:** /start
- **bot:** Welcome to the hotel booking bot! Hope you enjoy the application I have 🏨

</details>

### tc-t4-repeated-start-is-idempotent.yaml — TC-T4
```
step 1: no button containing '🦄 Open' on keyboard []
```
<details><summary>dialog</summary>

- **you:** /start
- **bot:** Welcome to the hotel booking bot! Hope you enjoy the application I have 🏨

</details>

### tc-t6-button-on-an-old-start-message-remains-usable-after-new-acti.yaml — TC-T6
```
step 1: no button containing '🦄 Open' on keyboard []
```
<details><summary>dialog</summary>

- **you:** /start
- **bot:** Welcome to the hotel booking bot! Hope you enjoy the application I have 🏨

</details>

