import requests

REPOS = [
    'marco-lancini/goscan',
]


def _stats_releases(repo):
    download_count = 0
    r = requests.get('https://api.github.com/repos/{}/releases'.format(repo))
    for rel in r.json():
        assets = rel['assets']
        if assets:
            download_count += assets[0]['download_count']
    print("[!] {} - downloads: {}".format(repo, download_count))


def _stats_stars(repo):
    stars_count = 0
    url = 'https://api.github.com/repos/{}/stargazers?simple=yes&per_page=100&page=1'.format(repo)
    r = requests.get(url)
    stars_count += len(r.json())
    while 'next' in r.links.keys():
        r = requests.get(r.links['next']['url'])
        stars_count += len(r.json())
    print("[!] {} - stars: {}".format(repo, stars_count))


def _stats_forks(repo):
    forks_count = 0
    url = 'https://api.github.com/repos/{}/forks?simple=yes&per_page=100&page=1'.format(repo)
    r = requests.get(url)
    forks_count += len(r.json())
    while 'next' in r.links.keys():
        r = requests.get(r.links['next']['url'])
        forks_count += len(r.json())
    print("[!] {} - forks: {}".format(repo, forks_count))


def stats(repo):
    _stats_releases(repo)
    _stats_stars(repo)
    _stats_forks(repo)


def main():
    print("[*] Github Stats")
    for r in REPOS:
        stats(r)


if __name__ == '__main__':
    main()
