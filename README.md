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

**Purpose:** A 3-step flow that lets kids check in, see they're not alone, and send anonymous kindness—all without free text.

---

#### Step 1 — How I Feel

The child adjusts several **feeling levers** (1–5 scale each), each representing a different dimension of their day. Visual icons at each end matter as much as the number—designed to be bullying-aware without naming bullies on the screen.

1. **Sunshine inside** — How bright my heart feels today
2. **School weather** — How school felt (calm → stormy)
3. **With others** — How included I felt with kids around me
4. **Steady body** — Calm vs butterflies / shaky
5. **Hope light** — How tomorrow looks from here

**Rules:**
- Levers only—no free text
- Each lever uses kid-friendly metaphors with gentle visual endpoints
- Sensitivity: framing avoids direct bullying language while capturing the child's emotional state

![Welcome Screen — Step 1: How I Feel](mocks/welcome-screen.png)

---

#### Step 2 — You're Not Alone

After setting their levers, the child sees an **anonymous count** of other kids whose feelings look similar today.

- Example: "42 kids felt close to this today"
- Display uses anonymous dots/avatars only—no names, no identifiable faces
- Optional supporting line: "Different schools. Same weather inside."

**Design intent:** Reassure the child that others share similar feelings without exposing anyone's identity.

![Welcome Screen — Step 2: You're Not Alone](mocks/welcome-not-alone.png)

---

#### Step 3 — Send a Warm Gift

The child can pick one **structured kindness gift** to send to that anonymous group of similar-feeling kids.

**Gift options (examples):**
- Brave star
- Hug cloud
- You-matter heart
- Pocket flashlight
- High-five

**How it works:**
- One tap sends the gift into a shared "kindness jar" that those kids can receive
- Recipients learn only that someone cared—**not who sent it**
- No free text, no DMs, no way to target individuals

**Design intent:** Empower kids to give support while respecting anti-harassment tenets. Builds connection without exposing identity.

![Welcome Screen — Step 3: Send a Warm Gift](mocks/welcome-gift.png)

### Help Me Choose

**Purpose:** Let a young user engage with others safely by asking for help with everyday decisions.

**How it works:**
1. The asker writes a **free-text question** (e.g. "What should I wear to the party?")
2. The asker uploads **3–4 images** as answer options (e.g. outfit photos)
3. Other users see these asks in a feed and **choose exactly one image** to vote
4. No typed replies, no comments, no DMs on this surface

**Example:**
> "What should I wear to the party?"
> - [Image A: Dress]
> - [Image B: Casual]
> - [Image C: Bright]
> - [Image D: Cozy]

**Safety note:** Voters can only tap an image—no free-text responses to the asker. This keeps peer harassment risk low while still allowing the asker's own question text.

![Help Me Choose](mocks/help-me-choose.png)

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
