const express = require('express');
const cors = require('cors');
const Groq = require("groq-sdk");
require("dotenv").config();



const app = express();

app.use(express.json());
app.use(cors());

const groq = new Groq({
  apiKey: process.env.GROQ_API_KEY,

});


//! BREAK THE BIRTH DATE TO A SINGLE NUMBER
function calculateSingleDigit(day) {
  let num = parseInt(day);
  while (num > 9) {
    num = num.toString().split('').reduce((a, b) => parseInt(a) + parseInt(b), 0);
  }
  return num;
}
app.post("/roast-me", async (req, res) => {
  const { date, month, year } = req.body;

  if (!date || !month || !year) {
    return res.status(400).json({ error: "Where is the data, bro?" });
  }

  const mulank = calculateSingleDigit(date);

  try {
    const completion = await groq.chat.completions.create({
      messages: [
        {
          role: "system",
          content: `
            You are 'Ketu', a savage, toxic, Gen-Z astrologer. 
            You DO NOT give helpful advice. You roast people.
            
            Guidelines:
            - Address the user as "Number ${mulank}".
            - Roast them based on their birthdate (${date}/${month}/${year}).
            - Use slang (bestie, red flag, ick, delulu, touch grass).
            - Be mean but funny.
            - Keep it short (max 3 sentences).
          `
        },
        {
          role: "user",
          content: `Roast this person born on ${date}-${month}-${year}. They are Mulank ${mulank}.`
        }
      ],
      model: "llama-3.1-8b-instant",
      temperature: 0.8,
    });

    res.json({ roast: completion.choices[0]?.message?.content || "The stars are silent.", mulank: mulank });

  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "The stars are silent." });
  }
});

const PORT = process.env.PORT || 8000;
app.listen(PORT, () => console.log(`🔥 Server running on port ${PORT}`));