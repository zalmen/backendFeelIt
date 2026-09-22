# FeelIt

FeelIt is an app supporting kids under 10 who have experienced bullying or social harassment.

**v1 language: Hebrew** — UI copy is gender-neutral Hebrew; brand name stays "FeelIt".

---

## Purpose

FeelIt is an app designed to support **kids under 10** who have suffered, or are still suffering, from **bullying or other social harassment**.

The primary audience is young children who need:

- A safe space to process difficult social experiences
- A way to connect with peers who understand what they're going through
- Tools for self-expression without risk of further harassment

Young children experiencing bullying often lack safe outlets to share their experiences. FeelIt aims to provide a supportive environment where kids can:

1. Express how they're feeling day-to-day
2. Share experiences anonymously without fear of identification
3. Engage with a community in structured, safe ways
4. See that they're not alone in their experiences

---

## Tenets

### Don'ts

1. **Don't store personal information** beyond city of residence, first name, and age.
2. **Don't let free text be tied to a specific other user** — free text must not be associated with information that directly identifies or points to a particular user (prevents harassment and outing).

### Do's

1. **Never leave a user hanging** — every user engagement must get a response (from other users or from the system) so no one feels abandoned.
2. **Show them they're not alone** — their problems are not unique; others feel this too.
3. **Give hope** — help the user believe things can change.
4. **Invite safe connection between kids** — host and encourage cross-user engagement that stays kind and safe.

---

## Screens

### Welcome Screen / פתיחה

**Trigger:** First app open of the day

**Purpose:** A 3-step flow that lets kids check in, see they're not alone, and send anonymous kindness—all without free text.

---

#### Step 1 — How I Feel

The child adjusts several **feeling levers** (1–5 scale each), each representing a different dimension of their day. Visual icons at each end matter as much as the number—designed to be bullying-aware without naming bullies on the screen.

| English | Hebrew |
|---------|--------|
| Sunshine inside | שמש בפנים |
| School weather | מזג אוויר בבית הספר |
| With others | עם אחרים |
| Steady body | רגועים בגוף |
| Hope light | אור של תקווה |

**Rules:**
- Levers only—no free text
- Each lever uses kid-friendly metaphors with gentle visual endpoints
- Sensitivity: framing avoids direct bullying language while capturing the child's emotional state

![Welcome Screen — Step 1: How I Feel](mocks/welcome-screen.png)

---

#### Step 2 — You're Not Alone / לא לבד כאן

After setting their levers, the child sees an **anonymous count** of other kids whose feelings look similar today.

- Example: "42 kids felt close to this today" / "42 ילדים הרגישו דומה היום"
- Display uses anonymous dots/avatars only—no names, no identifiable faces
- Supporting line: "Different schools. Same weather inside." / "בתי ספר שונים. אותו מזג אוויר בפנים."

**Design intent:** Reassure the child that others share similar feelings without exposing anyone's identity.

![Welcome Screen — Step 2: You're Not Alone](mocks/welcome-not-alone.png)

---

#### Step 3 — Send a Warm Gift / מתנה חמה

The child can pick one **structured kindness gift** to send to that anonymous group of similar-feeling kids.

**Gift options:**

| English | Hebrew |
|---------|--------|
| Brave star | כוכב אומץ |
| Hug cloud | ענן חיבוק |
| You-matter heart | מגיע לכם |
| Flashlight for a hard day | פנס ליום קשה |
| High-five | תנו חמש |

**How it works:**
- One tap sends the gift into a shared "kindness jar" that those kids can receive
- Recipients learn only that someone cared—**not who sent it**
- No free text, no DMs, no way to target individuals

**Design intent:** Empower kids to give support while respecting anti-harassment tenets. Builds connection without exposing identity.

![Welcome Screen — Step 3: Send a Warm Gift](mocks/welcome-gift.png)

### Help Me Choose / עזרו לי לבחור

**Purpose:** Let a young user engage with others safely by asking for help with everyday decisions.

**How it works:**
1. The asker writes a **free-text question** (e.g. "מה ללבוש למסיבה?" / "What should I wear to the party?")
2. The asker uploads **3–4 images** as answer options (e.g. outfit photos)
3. Other users see these asks in a feed and **choose exactly one image** to vote
4. No typed replies, no comments, no DMs on this surface

**Example:**
> "מה ללבוש למסיבה?" (What should I wear to the party?)
> - [Image א: שמלה / Dress]
> - [Image ב: קז'ואל / Casual]
> - [Image ג: צבעוני / Bright]
> - [Image ד: נוח / Cozy]

**Safety note:** Voters can only tap an image—no free-text responses to the asker. This keeps peer harassment risk low while still allowing the asker's own question text.

![Help Me Choose](mocks/help-me-choose.png)

### Happy Ending / סוף שמח

**Purpose:** Let kids share what happened to them and receive hopeful happy endings from others.

**How it works:**
1. A user writes a **free-text story** about something that happened to them
2. They tap "Share anonymously" / "שיתוף בעילום שם" to post it to the feed
3. In the **public feed**, stories appear **without author identity**
4. Other users can **suggest a happy ending** / "הצעת סוף" for any story
5. Other users can give **hugs** / **חיבוק** to a story if they relate (structured reaction)
6. The **author gets notified** when someone adds an ending (never left hanging)

**Privacy & safety:**
- Public feed: no author identity shown on stories or endings
- On their **My Plant** / **הצמח שלי** profile, each user can see their own stories (private to them)
- Hugs and endings are the safe engagement paths—no free-text DMs
- Notifications to the author are private system messages

**Design intent:** Give kids a way to process difficult experiences while receiving hope from peers who imagine a kinder outcome.

![Happy Ending](mocks/happy-ending.png)

### My Plant / הצמח שלי

**Purpose:** The user's profile, represented as a growing plant that visualizes their engagement and growth in the app.

**How it works:**
- Every **engagement by the user** in the app (check-ins, votes, hugs, endings) **waters** the plant
- Engagement **from other users toward this user** (hugs received, endings on their stories) also waters the plant
- The plant **grows and evolves visually** as total engagement increases
- The plant grows **unique fruits** — app-wide unique icons that only this user has grown
- Once a fruit has grown, the user can **gift it** to other users (e.g. on Happy Ending / סוף שמח, or randomly to someone who feels similarly today)

**Features on this screen:**
- Current growth stage indicator (e.g. "שלב צמיחה 3 · נבט בוגר")
- Visual plant that evolves over time
- "Water for today" progress bar showing engagement + hugs/endings received
- Collection of unique fruits grown, with gifting option

**Design intent:** Gamify positive engagement while giving kids a personal space that reflects their journey. Fruit gifting extends the kindness loop beyond anonymous gifts.

![My Plant](mocks/my-plant.png)

---

## Open Questions

See [`OPEN-QUESTIONS.md`](OPEN-QUESTIONS.md) for decisions still to be made.
