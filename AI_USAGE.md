# How I Used AI in This Project

I believe in being transparent about my workflow. Yes, I used AI tools while building this, and I want to explain exactly how.

**I used AI to be faster, not to be lazy.**

### What AI Did:
*   **Boilerplate:** I asked it to generate the initial `Post` model from the JSON structure. Writing `fromJson` manually is tedious and error-prone.
*   **Setup:** It helped me scaffold the initial folder structure for Clean Architecture so I didn't have to create 10 folders manually.
*   **Doc Drafts:** It helped me write the initial draft of the documentation, which I then edited to sound like me.

### What I Did (The Important Stuff):
*   **Architecture Decisions:** AI suggested a few patterns, but I specifically chose MVVM with Clean Architecture because I know it scales best for this kind of app.
*   **Logic & State:** I wrote the Provider logic to handle the specific "loading vs. cached vs. error" states because AI often messes up complex state flows.
*   **UI Polish:** AI gives generic UI. I went in and tweaked the padding, colors, and error widgets to make them actually look good and feel responsive.

In short: I used AI as a smart autocomplete, but I understand every single line of code in this repo.

