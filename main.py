"""DailyMate - Main entry point.

Launches the DailyMate desktop application. All core features work offline.
"""

import sys
from app.paths import get_app_data_dir, get_db_path


def main():
    """Main entry point for DailyMate."""
    app_data_dir = get_app_data_dir()
    db_path = get_db_path()

    from app.application import Application
    from ui.main_window import MainWindow

    try:
        from Database.db_manager import DatabaseManager
        db = DatabaseManager(db_path)
    except Exception as e:
        print(f"Database initialization error: {e}")
        db = None

    app_core = Application(db) if db is not None else None
    window = MainWindow(app_core)
    window.mainloop()


if __name__ == "__main__":
    main()