import requests
import subprocess
import os
import os.path as op
import time
import pandas as pd

# grab API Key
fd = open("API_KEY/githubKey.txt", 'r')
GITHUB_API = fd.read()
fd.close()

# github URL
SEARCH_API_URL = 'https://api.github.com/search/repositories'

#request headers
headers = {
    'Authorization': f'token {GITHUB_API}',
    'Accept': 'application/vnd.github.v3+json'
}

# Define the query parameters
licenses  = ['mit', 'apache-2.0', 'gpl-3.0']
languages = ['verilog', 'systemverilog']
archwords = ['"processor"', '"microprocessor"', '"computer architecture"']
isas      = ['RISC-V', 'ARM', 'x86-64', 'MIPS']

count = 0
total_repo_size = 0


for license_ in licenses:
    for language in languages:
        for arch in archwords:
            for isa in isas:
                params = {
                    'q': f'{isa} {arch} language:{language} license:{license_}',
                    'sort': 'stars',                      # Sort by stars (popularity)
                    'order': 'desc',                      # Descending order
                    'per_page': 100,                       # Number of results per page
                    'page': 1                             # Page number
                }

                # Send the request to GitHub's search API
                response = requests.get(SEARCH_API_URL, headers=headers, params=params)

                # Check if the response is successful
                prevcount = count
                if response.status_code == 200:
                    data = response.json()
                    repositories = data['items']
                    
                    # Print repository information
                    outfd = open("repo_info.txt", 'a', encoding='utf-8', errors="ignore")

                    for repo in repositories:
                        # fill dataframe
                        newStructure = {'URL' : [repo['html_url']]}
                        if not op.isfile("github_urls.csv"):
                            df = pd.DataFrame(newStructure)
                        else:
                            df = pd.read_csv("github_urls.csv")
                            df = pd.concat([df, pd.DataFrame(newStructure)], ignore_index=True)
                            # duplicate checking - prevent adding duplicates
                            dupes = df.duplicated()
                            if not (df[dupes].empty):
                                print(dupes.empty)
                                print(dupes)
                                continue
                        df.to_csv("github_urls.csv", index=False)


                        # write to doc file
                        outfd.write(f"Name: {repo['name']}\n")
                        outfd.write(f"Owner: {repo['owner']['login']}\n")
                        outfd.write(f"Size (KB): {repo['size']}\n")
                        outfd.write(f"URL: {repo['html_url']}\n")
                        outfd.write(f"Description: {repo['description']}\n")
                        count += 1
                        total_repo_size += repo['size']
                        outfd.write(f"Repo-Count: {count}\n\n")
                    # print(count)
                else:
                    print(f"Failed to fetch repositories: {response.status_code} - {response.text}")

                print(f'waiting on request: {params["q"]}... returned {count - prevcount} repos')
                time.sleep(2)
outfd.close()
print(f'Size of repos: {total_repo_size} KB')