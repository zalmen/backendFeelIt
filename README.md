# FeelIt

FeelIt is an app supporting kids under 10 who have experienced bullying or social harassment.

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

These principles guide all product decisions for FeelIt.

### 1. Minimal Personal Information

**Do not collect personal details beyond what is strictly necessary.**

- The most private detail permitted is the user's **resident city**
- Avoid collecting names, schools, ages, photos of the user, or other identifying information unless absolutely required
- Design features to work with minimal user data

### 2. Safe Place / Anti-Harassment

**Prevent features from being abused to bully other members.**

This tenet has specific implications for how users can communicate:

**Prohibited:**
- Free text that one user can send to another user (direct messages, comments on others' posts)
- Free text broadcast publicly as directed interpersonal communication (replies, mentions, callouts)

**Permitted:**
- Free text about oneself for private self-expression (journaling, personal reflections for the user's own use)
- Structured responses (survey-style choices, badges, predefined reactions)

**Clarification:** The free-text restriction specifically prevents harassment within the app between users. It does not ban all text input—users can still write freely when the content is for themselves or when the interaction model prevents targeting other users.

---

## Screens

### Welcome Screen

**Trigger:** First app open of the day

**Purpose:** Let kids express how they're feeling and what happened using a creative, sticker-based "Silent Story"—no free text required.

**Format: Silent Story (3 sticker panels)**

Kids place stickers on three panels to form a short non-verbal story:

1. **How I feel** — Emotion stickers beyond basic happy/sad (e.g. brave, lonely, proud, shaky, hopeful, quiet, angry-but-safe)
2. **What happened** — Curated moment stickers from a kid's world (left out at recess, someone laughed, a friend sat with me, teacher noticed me, shared snack, alone at lunch, stood up for myself). Depictions are gentle and abstract—never graphic bullying imagery.
3. **What I need / hope** — Stickers like hug, friend, quiet space, feel brave, tell a safe grown-up

**Rules:**
- Stickers/emojis only—no free text on the Welcome screen
- Child can place a small number of stickers per panel; the order forms their story
- Optional: A soft "weather around me" indicator (sunny/cloudy/storm) may enhance mood expression

![Welcome Screen](mocks/welcome-screen.png)

### Community Feed (Closed Questions / Surveys)

**Purpose:** Let users ask the community (or communities) closed questions in a structured, safe format.

**How it works:**
1. A user creates a post with a question
2. The user can attach **up to 4 images** as options
3. The user defines **possible responses** (survey-style choices)
4. Other users respond by selecting from the predefined choices

**Example:**
> "What should I wear to this event?"
> - [Image 1: Blue dress]
> - [Image 2: Red shirt]
> - [Image 3: Green sweater]
> - [Image 4: Yellow jacket]

**Safety note:** Responses are **structured choices only**—no open free-text replies to the poster. This prevents the feature from being used to send hurtful messages.

![Community Feed](mocks/community-feed.png)

### Anonymous Safe-Place Stories (Unpleasant Events)

**Purpose:** Provide a safe place for users to tell stories about unpleasant events that happened to them.

**Privacy by design:**
- The story author's identity is **NOT stored in the backend**
- It must be **impossible to associate a story with a user**
- This is a core architectural requirement, not just a UI choice

**Features on this screen:**
1. **View other users' stories** — read anonymous experiences from the community
2. **Engage via badges** — react to stories using badges (not free-text comments)
3. **See similar stories** — after publishing a story, show the user other similar stories from other users

**Design intent:** Help users feel less alone by seeing that others have had similar experiences, while protecting everyone's identity.

![Anonymous Safe-Place Stories](mocks/anonymous-stories.png)

---

## Open Questions

See [`OPEN-QUESTIONS.md`](OPEN-QUESTIONS.md) for decisions still to be made.
