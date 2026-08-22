import json
from platforms.onlinejobs import scrape_onlinejobs

def main():
    print("[*] Running local parse test...")
    jobs = scrape_onlinejobs()
    
    # Dump formatted JSON output for visual inspection
    print(f"[+] Scraped {len(jobs)} raw jobs:")
    print(json.dumps(jobs, indent=2))

if __name__ == "__main__":
    main()