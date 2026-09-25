# FeelIt

**A safe space for kids under 10 who've experienced bullying.** FeelIt helps children express difficult feelings, see they're not alone, and receive kindness from peers—without the risks of open social interaction.

> v1 UI language is Hebrew. Mocks show the Hebrew interface. Hebrew UI may randomly use masculine or feminine address across screens (not only neutral phrasing).

---

## Tenets

### Don'ts
1. **Don't store personal information** beyond city, first name, and age.
2. **Don't let free text target another user** — prevents harassment and outing.

### Do's
1. **Never leave a user hanging** — every engagement gets a response.
2. **Show them they're not alone** — others feel this too.
3. **Give hope** — things can change.
4. **Invite safe connection** — cross-user engagement that stays kind.

---

## Screens

**App-wide navigation:** All screens share the same four-tab bottom navigation bar (RTL order: הצמח · סוף שמח · מה אומרים? · פתיחה). The active tab is highlighted based on the current screen. Welcome flow screens have פתיחה active.

### Welcome Flow · פתיחה

Daily check-in flow (3 steps). No free text—only structured inputs that are safe by design.

#### Step 1 — How I Feel

Kids express their emotional state through five feeling levers. Each lever uses a 1–5 scale with intuitive poles: negative on the left, positive on the right. Visual anchors (emoji icons) make abstract feelings tangible for young users.

![Welcome Step 1 — Feeling Levers](mocks/annotated/welcome-step1-annotated.png)

| Lever | Left (1) | Right (5) |
|-------|----------|-----------|
| Sunshine inside me | Low | High |
| School weather | Stormy | Bright |
| Fun with others | Alone | Belonging |
| Calm in body | Worries | Butterflies |
| Hope light | Weak | Strong |

**For engineering:**
- Persist lever values per user per day
- Calculate similarity score for Step 2 matching
- No text input fields on this screen

---

#### Step 2 — You're Not Alone

Immediate emotional validation: a real-time count of other kids feeling similarly. Around the count, a cluster of **stickers** (hobbies, interests, characters) sampled from similar-feeling peers—personalizing the connection without revealing identity. No names, no faces, no schools.

**Two anonymous actions** available directly from this screen:
- **Group Hug** — send a hug to everyone in the similar-feeling cohort at once
- **Random Gift** — send a unique gift to one random kid from the cohort

Both actions are anonymous; recipients never know who sent.

![Welcome Step 2 — Anonymous Peer Count](mocks/annotated/welcome-step2-annotated.png)

**For engineering:**
- Query users with similar lever profiles (threshold TBD in Open Questions)
- Display anonymized count + random sticker sample from matching cohort
- Minimum cohort size floor to protect small groups
- Group hug: broadcast to all matching users
- Random gift: select one random user from cohort, deliver gift anonymously

---

#### Step 3 — Spread Love

Two currencies enable kids to send kindness without DMs or direct contact:

1. **Hugs** — fungible balance; can send hugs to everyone in the similar-feeling cohort at once
2. **Unique Icons** — one-time collectible gifts grown from My Plant fruits

Recipients learn only that someone cared—not who sent it.

![Welcome Step 3 — Spread Love](mocks/annotated/welcome-step3-annotated.png)

**For engineering:**
- Deduct hugs from sender balance on send
- Broadcast to all users in matching cohort
- Unique icons are single-use; remove from sender inventory on gift

---

### What do they say? · מה אומרים?

Safe peer engagement through image-based polls. Kids ask questions with 3–4 photo options; others vote by tapping one image. No typed replies, no comments, no DMs—just visual choices.

![What do they say? — Image Polls](mocks/annotated/what-do-they-say-annotated.png)

**Top controls:**
- **New Question** — create an image-based poll
- **My Questions** — view your posted questions and incoming votes (accessed from main screen, no separate mock)

**For engineering:**
- Store question text + 3–4 image URLs per poll
- One vote per user per question
- Aggregate vote counts; no voter identity exposed

---

### Happy Ending · סוף שמח

Share what happened anonymously. Receive hopeful endings from peers. Stories get better here.

![Happy Ending — Anonymous Stories](mocks/annotated/happy-ending-annotated.png)

- **Anonymous sharing** — tell your story without revealing identity
- **Suggest happy endings** — contribute hope to someone else's story
- **Send hugs** — emotional support as reaction
- Stories saved privately on the author's My Plant profile

**For engineering:**
- Stories stored with author reference (not exposed in UI)
- Endings linked to parent story
- Hug count per story; notify author on new endings

---

### My Plant · הצמח שלי

Profile as a growing plant. Every engagement waters it—yours and others' kindness toward you.

![My Plant — Living Profile](mocks/annotated/my-plant-annotated.png)

**Plant visual:**
- Plant art blends into UI (no rectangular photo frame)
- Starts small so growth/evolution is visible over time
- Growth stage reflects cumulative engagement

**Identity stickers:** The pot holds stickers (city, character, hobby) that personalize without revealing who you are—same visual language as the peer stickers on Step 2.

**Hugs received:** Total count displayed prominently.

**Fruit inventories:**
1. **Grown by my plant** — unique items you cultivated; can gift to others
2. **Received as gifts** — can also re-gift to others

**For engineering:**
- Track growth points per user (actions TBD in Open Questions)
- Sticker selection stored per user
- Fruit ownership table with "grown" vs "received" flag

---

## Raw Mocks

Original phone screenshots (Hebrew UI) are available under `mocks/` for engineering reference:

| Screen | File |
|--------|------|
| Welcome Step 1 | `mocks/welcome-screen.png` |
| Welcome Step 2 | `mocks/welcome-not-alone.png` |
| Welcome Step 3 | `mocks/welcome-gift.png` |
| What do they say? | `mocks/what-do-they-say.png` |
| Happy Ending | `mocks/happy-ending.png` |
| My Plant | `mocks/my-plant.png` |

---

## Open Questions

See [`OPEN-QUESTIONS.md`](OPEN-QUESTIONS.md) for decisions still to be made.
