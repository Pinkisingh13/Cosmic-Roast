# 🔮 Cosmic Roast

A fun app that generates savage, Gen-Z style roasts based on your birthdate using AI and numerology.

**Live Demo:** https://cosmo-roast.netlify.app

**Demo Video:**

<div style="position:relative; width:100%; height:0px; padding-bottom:55.781%"><iframe allow="fullscreen;autoplay" allowfullscreen height="100%" src="https://streamable.com/e/796nsz?autoplay=1&muted=1" width="100%" style="border:none; width:100%; height:100%; position:absolute; left:0px; top:0px; overflow:hidden;"></iframe></div>

[Download MP4](./cosmo-roast-demo%20video.mp4)

---

## How It Works

1. Enter your birthdate (DD/MM/YYYY)
2. App calculates your **Mulank** (numerology number from birth day)
3. AI generates a personalized roast based on your birth data
4. View your savage prediction for 2026!

---

## Tech Stack

| Component | Technology |
|-----------|------------|
| Frontend | Flutter (Web, iOS, Android) |
| Backend | Node.js + Express |
| AI | Groq API (Llama 3.1 8B) |
| Hosting | Netlify (Frontend) + Render (Backend) |

---

## Project Structure

```
Cosmic Roast/
├── frontend/                 # Flutter app
│   ├── lib/
│   │   ├── main.dart         # Home screen
│   │   ├── api_service.dart  # API calls
│   │   └── result.dart       # Result screen
│   ├── assets/
│   │   ├── web_bg.png        # Web background
│   │   └── vertical_bg.png   # Mobile background
│   └── README.md             # Frontend docs
│
├── backend/                  # Node.js API
│   ├── service.js            # Express server
│   ├── package.json          # Dependencies
│   └── README.md             # Backend docs
│
├── README.md                 # This file
└── cosmo-roast-demo video.mp4
```

---

## Quick Start

### Backend

```bash
cd backend
npm install
echo "GROQ_API_KEY=your_key" > .env
node service.js
```

Server runs at `http://localhost:8000`

### Frontend

```bash
cd frontend
flutter pub get
flutter run -d chrome
```

Update API URL in `frontend/lib/api_service.dart`:
```dart
static const String baseUrl = 'http://localhost:8000';
```

---

## Deployment

### Backend → Render

1. Push to GitHub
2. Create Web Service on [render.com](https://render.com)
3. Set Root Directory: `backend`
4. Build Command: `npm install`
5. Start Command: `node service.js`
6. Add Environment Variable: `GROQ_API_KEY`

### Frontend → Netlify

1. Build: `cd frontend && flutter build web`
2. Deploy `frontend/build/web` to [netlify.com](https://netlify.com)
3. Update `api_service.dart` with Render URL before building

---

## API Endpoint

**POST** `/roast-me`

Request:
```json
{
  "date": "15",
  "month": "08",
  "year": "1995"
}
```

Response:
```json
{
  "roast": "Your savage roast here...",
  "mulank": 6
}
```

---

## Environment Variables

### Backend (.env)
```
GROQ_API_KEY=gsk_xxxxxxxxxxxxx
PORT=8000
```

Get your Groq API key at [console.groq.com](https://console.groq.com)

---

## Features

- 🎨 Beautiful cosmic UI with blur effects
- 📱 Responsive (works on web, iOS, Android)
- ✅ Input validation with error messages
- 🔄 Auto-focus to next field
- 📜 Scrollable result for long roasts
- 🐛 Debug logs for development

---

## Screenshots

See the demo video for full walkthrough:
- [Streamable](https://streamable.com/796nsz)
- [Local MP4](./cosmo-roast-demo%20video.mp4)

---

## License

MIT - Feel free to use and modify!
