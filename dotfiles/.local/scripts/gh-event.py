import requests
import subprocess
from urllib.parse import urlparse

origin = subprocess.run(
    ["git", "remote", "get-url", "origin"],
    check=True,
    stdout=subprocess.PIPE,
    text=True,
).stdout.strip()

cred = subprocess.run(
    ["git", "credential", "fill"],
    input=f"url={origin}",
    check=True,
    stdout=subprocess.PIPE,
    text=True,
).stdout

credentials = dict(line.split("=") for line in cred.splitlines())
token = credentials["password"]

data = { "event_type": "release" }

headers = {
    "Accept": "application/vnd.github.everest-preview+json",
    "Content-Type": "application/json",
    "Authorization": f"Bearer {token}",
}
path = urlparse(origin).path
url = f"https://api.github.com/repos{path}/dispatches"
r = requests.post(url, headers=headers, json=data)
