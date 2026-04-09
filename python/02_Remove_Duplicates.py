"""
02_Remove_Duplicates.py
Remove duplicate characters from a string using a loop,
preserving the original order of first appearances.

Example:
    "programming"  ->  "progamin"
    "hello world"  ->  "helo wrd"
    "aabbcc"       ->  "abc"
"""

def remove_duplicates(input_string):
   
    result = ""                         

    for char in input_string:
        if char not in result:           
            result += char

    return result


# ──────────────────────────────────────────────
# Test cases
# ──────────────────────────────────────────────
if __name__ == "__main__":
    test_cases = [
        "programming",
        "hello world",
        "aabbcc",
        "abcabc",
        "data analyst",
        "PlatinumRx",
        "",                   
        "aaaaaaa",            
        "abcdefg",            
    ]

    print("Remove Duplicate Characters\n" + "=" * 35)
    for s in test_cases:
        print(f"  Input:  '{s}'")
        print(f"  Output: '{remove_duplicates(s)}'")
        print()
