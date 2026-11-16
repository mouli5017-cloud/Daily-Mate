# DailyMate — Personal Notes & Task Reminders

A polished, **offline-first** Windows desktop application for managing reminders, tasks, notes, and recurring schedules. Built with Python, CustomTkinter, and SQLite. Your data never leaves your machine.

![Screenshot](docs/screenshot-placeholder.png)

> **Screenshots**: placeholders until real screenshots are captured.

## Features

- **Dashboard** — current date/time, pending/completed/overdue counts, next reminder with live countdown, quick-add, today's task list and completion progress.
- **My Tasks** — search, filter by category and priority, edit, delete, pause/resume reminders.
- **Add Reminder** — validated form: title, description, category (Health / Study / Work / Personal / Other, or a custom category), priority, start date-time, repeat schedule, end date, sound & voice toggles.
- **Quick Add** — natural-language parsing such as *“Drink water every 1 hour”*, *“Study Python at 7:00 PM”*, *“Take medicine every day at 8:00 AM”*, *“Finish my project tomorrow at 9:00 PM”*. When the text is ambiguous, the form opens pre-filled instead of guessing.
- **Recurrence** — one-time, hourly, daily, weekly (selected weekdays), and custom intervals (minutes / hours / days) with collapsed catch-up notifications after the PC wakes from sleep.
- **Animated pop-ups** — slide-in notifications with Done / Snooze / Open actions, always above other windows while active, stackable, with a configurable display duration and a reduced-motion mode.
- **Native Windows notifications** — via `plyer` with `win10toast` fallback; failures never crash the app.
- **Snooze** — 5 / 10 / 15 / 30 minute presets (configurable default), creates one delayed occurrence without touching the recurrence rule.
- **Floating mini widget** — draggable, always-on-top optional, shows time, next reminder, countdown and today's pending count; hideable without stopping the scheduler; remembers position and visibility.
- **Calendar** — real month navigation, today highlight, reminder markers, and a day detail panel.
- **History** — occurrence-level records (scheduled time, status, snooze count) filterable by date range, category, status and search text.
- **Statistics** — scheduled/completed/pending/overdue today, completion rate, weekly trend chart bars, most-used categories, and a transparent streak counter. All from real database records — no demo data.
- **Themes** — dark (default) and light themes, persisted across restarts.
- **Voice announcements** — offline TTS via `pyttsx3`. If unavailable, the app degrades to visual notifications gracefully. Reminder text is **never** sent to online speech services.
- **Windows startup** — per-user Startup-folder shortcut (no admin rights, no registry edits). Toggle it in Settings.
- **Export & Backup** — CSV export of reminders and history, JSON export of everything (UTF-8), plus a validated database backup/restore flow that saves a safety copy before overwriting.

## Technology stack

| Layer | Technology |
|---|---|
| Language | Python 3.11+ |
| GUI | CustomTkinter (Tkinter) |
| Persistence | SQLite (stdlib) |
| Notifications | plyer (primary), win10toast (fallback) |
| Voice | pyttsx3 (offline Windows TTS) |
| Testing | pytest |

## Quick start (single batch file)

Double-click `run_DailyMate.bat` — it creates a virtual environment, installs dependencies on first run, and launches the app. It can be run repeatedly.

## Installation

```bat
git clone <your-repo-url> DailyMate
cd DailyMate
py -3 -m venv .venv
.venv\Scripts\activate
py -3 -m pip install -r requirements.txt
```

## Running from source

```bat
py -3 main.py
```

## How to create reminders

1. Click **Add Reminder** (or press the `+ Add Reminder` button on the dashboard).
2. Fill in a title (required), optional description, and pick a category and priority.
3. Choose a **Start date & time** (`YYYY-MM-DD HH:MM`).
4. Choose a repeat rule:
   - **None** — fires once, then disables itself.
   - **Hourly / Custom** — repeats every N minutes/hours/days.
   - **Daily** — repeats at the same local time each day.
   - **Weekly** — select the weekdays and time; fires only on those days.
5. Optionally set an **End date**, and toggle sound/voice.
6. Save — the reminder's `next_fire_datetime` is persisted immediately and survives restarts.

**Quick Add** on the dashboard parses simple phrases; if parsing is ambiguous the form opens pre-filled for confirmation.

### Recurrence anchoring

Intervals **advance from the previous scheduled occurrence** (not from the time you snooze or acknowledge). Expired schedules are collapsed into a single catch-up notification. Snoozing never alters the recurrence rule.

## Notifications and voice

- **Sound** — short Windows alert via `winsound`. Can be toggled per reminder.
- **Voice** — “Reminder: <title>.” using offline pyttsx3. Enable in Settings, test with **Test Voice**.
- **Native toasts** — toggle in Settings → Notifications & Voice.
- **Display duration** — Settings → Appearance (2–30 seconds).
- **Reduced motion** — Settings → Appearance disables the slide-in animation.

## Windows startup

Settings → **Windows Startup** toggles a shortcut named `DailyMate.lnk` in the per-user Startup folder
(`%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup`).

- Enabled using the currently installed/frozen executable path (or `pythonw.exe main.py` when running from source).
- No administrator rights required; no system-wide changes.
- To disable: turn off the toggle, or delete the shortcut manually.

## Database and backup location

Per-user AppData directory (never the install directory):

```
%APPDATA%\.dailymate\DailyMate.db
```

Backups taken from Settings → Export & Backup are user-controlled; a safety copy (`.pre-restore-*.db`) is created automatically before any restore.

## Export instructions

Settings → **Export & Backup**:

- **Export Reminders (CSV)** — reminders only.
- **Export History (CSV)** — occurrence-level history.
- **Export All (JSON)** — reminders + occurrences + metadata.
- All exports use UTF-8 (CSV with BOM for Excel compatibility) and ISO 8601 timestamps.

## Running tests

```bat
py -3 -m pytest tests\ -v
```

## Building the Windows executable

```bat
scripts\build_windows.bat
```

or manually:

```bat
py -3 -m pip install pyinstaller
py -3 -m PyInstaller --noconfirm --onefile --windowed --name DailyMate main.py
```

Output: `dist\DailyMate.exe`. Test by running it, enabling/disabling startup in Settings, and triggering a reminder with a near future fire time.

## Troubleshooting

| Symptom | Fix |
|---|---|
| App won't start | Ensure Python 3.11+ is installed and `requirements.txt` is installed in the active venv. |
| Notifications never appear | Check Windows notification permissions for DailyMate/Python in Settings → System → Notifications. |
| Native notifications fail but pop-ups work | `plyer`/`win10toast` may be blocked; in-app pop-ups still work. Do not run the app as Administrator. |
| No sound | Your device may be muted or unavailable — the app continues silently. |
| Voice does not speak | `pyttsx3` is missing or the SAPI voice is not installed; visual notifications still work. |
| Reminders missed while PC was off | They are not all replayed — recurring reminders collapse into one catch-up notification; one-time reminders notify as overdue once. |
| Pop-ups stuck behind other windows | Pop-ups are topmost only while shown; they self-dismiss after the configured duration or when you click Done/Snooze/Open.

## Privacy and offline-first behavior

- All reminder data lives in the local SQLite database. **No telemetry, no analytics, no network calls.**
- The app never uploads reminder notes, schedules, or history.
- Exports and backups are explicitly user-initiated via a file dialog.
- Voice announcements use offline Windows TTS only.
- Deleting the app data folder removes all data permanently.

## Project structure

```
DailyMate/
├── main.py                     # Entry point
├── requirements.txt
├── README.md                   # This file
├── LICENSE
├── .gitignore
├── config/defaults.py          # Default constants
├── app/
│   ├── application.py          # Application core (db + scheduler wiring)
│   ├── paths.py                # Per-user AppData paths
│   └── startup_manager.py      # Per-user Startup shortcut
├── Database/
│   ├── db_manager.py           # SQLite access layer (parameterized SQL)
│   └── schema.sql              # Schema + indexes
├── models/                     # Reminder / Occurrence / Settings models
├── services/                   # scheduler, notifications, export, backup,
│                               # statistics, reminder parsing, sound, voice
├── ui/                         # CustomTkinter views & floating widget
├── utils/                      # datetime utilities, validators, logging
├── assets/                     # (optional) icons and sounds
├── tests/                      # pytest suite
└── scripts/build_windows.bat   # PyInstaller build helper
```

## Publishing to GitHub yourself

This repository is not published — here are the commands to publish it yourself:

```bat
cd D:\DailyMate
git init
git add .
git commit -m "Initial release: DailyMate v1.0.0"
git branch -M main
git remote add origin https://github.com/<you>/DailyMate.git
git push -u origin main
```

`.gitignore` already excludes databases, logs, exports and build artifacts.

## License

MIT — see [LICENSE](LICENSE).