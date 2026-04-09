"""
01_Time_Converter.py
Convert an integer number of minutes into a human-readable string.

Examples:
    130 -> "2 hrs 10 minutes"
    110 -> "1 hr 50 minutes"
    60  -> "1 hr 0 minutes"
    45  -> "0 hrs 45 minutes"
"""


def convert_minutes(total_minutes):
   
    if not isinstance(total_minutes, (int, float)) or total_minutes < 0:
        return 

    total_minutes = int(total_minutes)

    hours = total_minutes // 60        # Integer division gives full hours
    minutes = total_minutes % 60       # Modulo gives the remaining minutes

    # Use "hr" for 1 hour, "hrs" for everything else (including 0)
    hour_label = "hr" if hours == 1 else "hrs"

    return f"{hours} {hour_label} {minutes} minutes"


# ──────────────────────────────────────────────
# Test cases
# ──────────────────────────────────────────────
if __name__ == "__main__":
    test_cases = [130, 110, 60, 45, 0, 90, 125, 200, 1, 59]

    print("Minutes Converter\n" + "=" * 30)
    for mins in test_cases:
        print(f"  {mins:>4} minutes  ->  {convert_minutes(mins)}")
