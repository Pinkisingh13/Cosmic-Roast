# 🔮 Cosmic Roast - Backend API

A Node.js/Express backend that generates savage, Gen-Z style roasts based on numerology (Mulank) using Groq's Llama AI.

---

## 📋 Table of Contents

1. [Overview](#overview)
2. [Tech Stack](#tech-stack)
3. [Project Structure](#project-structure)
4. [How It Works](#how-it-works)
5. [API Documentation](#api-documentation)
6. [Environment Variables](#environment-variables)
7. [Local Development](#local-development)
8. [Deploy to Render](#deploy-to-render)
9. [Troubleshooting](#troubleshooting)

---

## 🎯 Overview

This backend powers the "Cosmic Roast" app - a fun application that:

1. Takes a user's birthdate (day, month, year)
2. Calculates their **Mulank** (numerology single digit from birthdate)
3. Uses AI to generate a savage, funny roast based on their birth data

The AI character "Ketu" is a toxic, Gen-Z astrologer who roasts users instead of giving helpful advice.

---

## 🛠 Tech Stack

| Technology | Version | Purpose |
|------------|---------|---------|
| **Node.js** | 18+ | Runtime environment |
| **Express.js** | 5.x | Web framework |
| **Groq SDK** | 0.37.x | AI/LLM API for generating roasts |
| **CORS** | 2.x | Cross-origin resource sharing |
| **dotenv** | 17.x | Environment variable management |

---

## 📁 Project Structure

\`\`\`
backend/
├── service.js          # Main server file (entry point)
├── package.json        # Dependencies and scripts
├── package-lock.json   # Locked dependency versions
├── .env               # Environment variables (NOT in git)
├── .gitignore         # Files to ignore in git
└── README.md          # This file
\`\`\`

---

## ⚙️ How It Works

### 1. Mulank Calculation

The **Mulank** (Root Number) is calculated by reducing the birth day to a single digit:

\`\`\`javascript
// Examples:
// Day 5  → Mulank 5
// Day 15 → 1+5 = 6 → Mulank 6  
// Day 28 → 2+8 = 10 → 1+0 = 1 → Mulank 1
\`\`\`

### 2. AI Roast Generation

Uses **Groq's Llama 3.1 8B** model with a custom prompt. The AI acts as "Ketu" - a savage Gen-Z astrologer who uses slang like "bestie", "red flag", "ick", "delulu", and "touch grass".

---

## 📡 API Documentation

### POST \`/roast-me\`

Generate a roast based on birthdate.

**Request:**
\`\`\`json
{
  "date": "15",
  "month": "08",
  "year": "1995"
}
\`\`\`

**Response (Success - 200):**
\`\`\`json
{
  "roast": "Number 6, your whole vibe is giving 'peaked in high school' energy...",
  "mulank": 6
}
\`\`\`

**Response (Error - 400):**
\`\`\`json
{
  "error": "Where is the data, bro?"
}
\`\`\`

---

## 🔐 Environment Variables

Create a \`.env\` file in the backend folder:

\`\`\`env
GROQ_API_KEY=gsk_xxxxxxxxxxxxxxxxxxxxxxxxxxxx
PORT=8000
\`\`\`

### How to get GROQ_API_KEY:
1. Go to [console.groq.com](https://console.groq.com)
2. Sign up / Log in
3. Go to "API Keys" section
4. Click "Create API Key"
5. Copy the key (starts with \`gsk_\`)

---

## 💻 Local Development

### 1. Install Dependencies
\`\`\`bash
cd backend
npm install
\`\`\`

### 2. Create .env file
\`\`\`bash
echo "GROQ_API_KEY=your_key_here" > .env
\`\`\`

### 3. Run the Server
\`\`\`bash
node service.js
\`\`\`

### 4. Test the API
\`\`\`bash
curl -X POST http://localhost:8000/roast-me \
  -H "Content-Type: application/json" \
  -d '{"date":"15","month":"08","year":"1995"}'
\`\`\`

---

## 🚀 Deploy to Render

### Step 1: Push to GitHub

Make sure your backend code is pushed to a GitHub repository.

### Step 2: Create Render Account

Go to [render.com](https://render.com) and sign up (free).

### Step 3: Create New Web Service

1. Click **"New +"** → **"Web Service"**
2. Connect your GitHub repository
3. Select the repository containing your backend

### Step 4: Configure the Service

| Setting | Value |
|---------|-------|
| **Name** | cosmic-roast-api (or any name) |
| **Region** | Choose closest to your users |
| **Branch** | main |
| **Root Directory** | backend |
| **Runtime** | Node |
| **Build Command** | \`npm install\` |
| **Start Command** | \`node service.js\` |

### Step 5: Add Environment Variables

1. Scroll to **"Environment Variables"**
2. Click **"Add Environment Variable"**
3. Add:
   - Key: \`GROQ_API_KEY\`
   - Value: \`gsk_your_actual_key_here\`

### Step 6: Deploy

1. Click **"Create Web Service"**
2. Wait for deployment (2-5 minutes)
3. Your API URL will be: \`https://your-app-name.onrender.com\`

### Step 7: Update Frontend

In your Flutter app, update the API URL:
\`\`\`dart
final url = Uri.parse('https://your-app-name.onrender.com/roast-me');
\`\`\`

---

## 🔧 Troubleshooting

### "The stars are silent" error

- Check if GROQ_API_KEY is set correctly
- Verify your Groq API key is valid
- Check Render logs for detailed error

### CORS errors

- The backend already has CORS enabled for all origins
- If issues persist, check browser console for details

### API not responding

- Check Render dashboard for deployment status
- View logs in Render dashboard
- Ensure service is not suspended

---

## 📝 Code Explanation

### service.js - Main Server File

\`\`\`javascript
// 1. Import dependencies
const express = require('express');
const cors = require('cors');
const Groq = require("groq-sdk");
require("dotenv").config();

// 2. Initialize Express app
const app = express();
app.use(express.json());  // Parse JSON bodies
app.use(cors());          // Allow cross-origin requests

// 3. Initialize Groq client with API key
const groq = new Groq({
  apiKey: process.env.GROQ_API_KEY,
});

// 4. Mulank calculation function
function calculateSingleDigit(day) {
  let num = parseInt(day);
  while (num > 9) {
    num = num.toString().split('').reduce((a, b) => parseInt(a) + parseInt(b), 0);
  }
  return num;
}

// 5. Main API endpoint
app.post("/roast-me", async (req, res) => {
  // Extract birthdate from request
  const { date, month, year } = req.body;
  
  // Validate input
  if (!date || !month || !year) {
    return res.status(400).json({ error: "Where is the data, bro?" });
  }
  
  // Calculate Mulank
  const mulank = calculateSingleDigit(date);
  
  // Generate roast using AI
  const completion = await groq.chat.completions.create({
    messages: [
      { role: "system", content: "You are Ketu, a savage Gen-Z astrologer..." },
      { role: "user", content: "Roast this person born on..." }
    ],
    model: "llama-3.1-8b-instant",
    temperature: 0.8,  // Higher = more creative
  });
  
  // Return roast and mulank
  res.json({ 
    roast: completion.choices[0]?.message?.content,
    mulank: mulank 
  });
});

// 6. Start server
const PORT = process.env.PORT || 8000;
app.listen(PORT, () => console.log(\`Server running on port \${PORT}\`));
\`\`\`

---

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Open a Pull Request
