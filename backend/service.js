const express = require("express");
const cors = require("cors");
const Groq = require("groq-sdk");
require("dotenv").config();

const app = express();
app.use(express.json());
app.use(cors());

const groq = new Groq({ apiKey: process.env.GROQ_API_KEY });

const MULANK_TRAITS = {
  1: { planet: "Sun (Surya)", traits: "Egoistic, dominating, thinks they are the King, attention seeker, stuborn father-figure energy." },
  2: { planet: "Moon (Chandra)", traits: "Emotional crybaby, moody, over-sensitive, mommy issues, can't make decisions." },
  3: { planet: "Jupiter (Guru)", traits: "Know-it-all, gives unwanted advice, thinks they are smarter than everyone, preachy." },
  4: { planet: "Rahu", traits: "Rebellious, overthinker, conspiracy theorist, breaks rules for no reason, chaotic, never satisfied." },
  5: { planet: "Mercury (Budh)", traits: "Calculative, manipulative, can't commit to one thing, talks too much, fake social butterfly." },
  6: { planet: "Venus (Shukra)", traits: "Materialistic, obsessed with luxury, lazy, flirtatious, spends money they don't have." },
  7: { planet: "Ketu", traits: "Confused, loner, disconnects from reality, spiritual but actually just lost, over-analyzes everything." },
  8: { planet: "Saturn (Shani)", traits: "Slow, struggle, hardworking but grumpy, acts like an old person, serious, boring." },
  9: { planet: "Mars (Mangal)", traits: "Angry, impulsive, fights first thinks later, aggressive, gym-rat energy." }
};

function calculateMulank(dayString) {
  let num = parseInt(dayString);
  if (isNaN(num)) return 0;
  while (num > 9) {
    num = num.toString().split('').reduce((a, b) => parseInt(a) + parseInt(b), 0);
  }
  return num;
}

app.post("/roast-me", async (req, res) => {
  const { date, month, year } = req.body;

  if (!date || !month || !year) {
    return res.status(400).json({ error: "Missing data!" });
  }

  const mulank = calculateMulank(date);
  

  const identity = MULANK_TRAITS[mulank] || MULANK_TRAITS[1];

  try {
    const completion = await groq.chat.completions.create({
      messages: [
        {
          role: "system",
          content: `
            You are 'Ketu', a savage, rude Indian astrologer.
            
            Target Profile:
            - Number: ${mulank}
            - Planet: ${identity.planet}
            - REAL Personality Traits: ${identity.traits}
            
            Your Task:
            1. Roast the user based ONLY on the specific traits listed above. Do not make up random astrology.
            2. Connect the roast to their real life (dating, career, money).
            3. Use a mix of clear English and understandable Gen-Z slang (don't overdo the slang, make it readable).
            4. Be brutally honest. Make them feel exposed.
            
            Format:
            - Max 2-3 punchy sentences.
            - Do not start with "Oh look...". Just attack directly.
          `
        },
        {
          role: "user",
          content: `Roast me. I was born on ${date}-${month}-${year}.`
        }
      ],
      model: "llama-3.1-8b-instant", 
      temperature: 0.7, 
    });

    res.json({ 
      roast: completion.choices[0]?.message?.content, 
      mulank: mulank 
    });

  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Server Error" });
  }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`🔥 Savage Server running on ${PORT}`));