# Flutter HR Assignment

Hey! Thanks for reviewing my submission.

I really enjoyed working on this. I treated it like a proper production app rather than just a quick script because I wanted to show how I actually write code in a professional environment.

## What's Inside?
It's a Flutter app that fetches posts from an API, but the cool part is how it handles data. I built it to work **offline-first**. So if you load the list and then turn off your WiFi, the app still works perfectly using cached data.

## Why I Built It This Way
You'll see I used **Clean Architecture** (splitting things into Data, Domain, and Presentation layers).
Honestly, for a small app, this might seem like overkill. But I did it to show that I can build things that scale. If this app grew to 50 screens, this structure would keep it sane.

I also used **Provider** for state management because it's clean and reliable. No need to overcomplicate things with Redux or Bloc for this specific scope, though I'm comfortable with those too.

## Quick Start
You should be able to just clone and run:

```bash
flutter pub get
flutter run
```

That's it! I checked it on both iOS and Android simulators.

## A Note on AI
I used some AI tools (like Gemini/ChatGPT) to speed up the boring stuff—like generating the JSON models and boilerplate setup. But all the logic, architecture decisions, and error handling are mine. I firmly believe AI should be a co-pilot, not the pilot.

Cheers,
[Your Name]
