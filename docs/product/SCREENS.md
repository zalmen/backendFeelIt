# Screens

This document describes the screens and features defined so far for FeelIt.

---

## Daily Check-In

**Trigger:** First app open of the day

**Purpose:** Understand the user's overall mood and let them share good or bad experiences from that day.

**Format:**
- Prompt the user with **at most 3 basic questions**
- Questions should be simple and appropriate for children under 10

**Post-check-in:** Where the user lands after completing the daily check-in is **not yet decided**. See [OPEN-QUESTIONS.md](OPEN-QUESTIONS.md).

---

## Community Feed (Closed Questions / Surveys)

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

---

## Anonymous Safe-Place Stories (Unpleasant Events)

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
