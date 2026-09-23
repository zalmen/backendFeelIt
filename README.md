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

### Welcome

Daily check-in flow (3 steps). No free text.

#### Step 1 — How I Feel

Five feeling levers (1–5 scale). Each lever has **negative pole on left**, **positive pole on right**:

| Lever | Left (1) | Right (5) |
|-------|----------|-----------|
| Sunshine inside me is shining | Low | High |
| School weather | Stormy | Bright |
| Fun with others | Alone | Belonging |
| Calm in body | Worries | Butterflies |
| Hope light | Weak | Strong |

![Welcome — Step 1](mocks/welcome-screen.png)

#### Step 2 — You're Not Alone

Shows an anonymous count of kids with similar feelings today. No names, no faces—just reassurance that "you're not alone here."

![Welcome — Step 2](mocks/welcome-not-alone.png)

#### Step 3 — Spread Love

Two currencies in the app:

1. **Hugs** — fungible balance users accumulate; can send hugs to everyone who feels similarly
2. **Unique icons** — non-fungible, app-wide unique icons (from My Plant fruits) that can be gifted

Gift options on this screen:

- Brave star
- Hug cloud
- You-matter heart
- Flashlight

Recipients learn only that someone cared—not who.

![Welcome — Step 3](mocks/welcome-gift.png)

---

### Help Me Choose

Safe peer engagement through image-based polls.

- Asker posts a question + 3–4 images
- Others vote by tapping one image
- No typed replies, no comments, no DMs

![Help Me Choose](mocks/help-me-choose.png)

---

### Happy Ending

Share what happened. Receive hopeful endings from others.

- User writes a story, posts anonymously
- Others suggest happy endings or send hugs
- Author gets notified—never left hanging
- Stories saved privately on the author's My Plant profile

![Happy Ending](mocks/happy-ending.png)

---

### My Plant

Profile as a growing plant.

**Plant visual:**
- Plant art blends into UI (no rectangular photo background)
- Plant starts relatively bare so growth/evolution is visible over time
- Every engagement waters it (yours and others' toward you)

**Profile stickers:** The pot holds stickers representing child attributes:
- City emblem (e.g. Kfar Saba)
- Favorite character
- Hobby (e.g. basketball)

**Hugs received:** Profile displays total hugs received count.

**Unique fruits (two inventories):**
1. **Grown by my plant** — marked as grown-by-me; can gift to others
2. **Received as gifts** — can also re-gift to others

![My Plant](mocks/my-plant.png)

---

## Open Questions

See [`OPEN-QUESTIONS.md`](OPEN-QUESTIONS.md) for decisions still to be made.
