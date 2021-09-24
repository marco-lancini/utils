import requests

REPOS = [
    'marco-lancini/goscan',
    'marco-lancini/utils',
    'marco-lancini/cartography-queries',
    'marco-lancini/k8s-lab-plz',
]


# ==============================================================================
# UTILS
# ==============================================================================
def _get_count(repo, what):
    count = 0
    url = f'https://api.github.com/repos/{repo}/{what}?simple=yes&per_page=100&page=1'
    r = requests.get(url)
    count += len(r.json())
    while 'next' in r.links.keys():
        r = requests.get(r.links['next']['url'])
        count += len(r.json())
    return count


# ==============================================================================
# STATS
# ==============================================================================
def _stats_stars(repo):
    count = _get_count(repo, "stargazers")
    print(f"\tStars: {count}")


def _stats_forks(repo):
    count = _get_count(repo, "forks")
    print(f"\tForks: {count}")


def _stats_releases(repo):
    download_count = 0
    r = requests.get('https://api.github.com/repos/{}/releases'.format(repo))
    for rel in r.json():
        if 'assets' in rel:
            download_count += rel['assets'][0]['download_count']
    print(f"\tDownloads: {download_count}")


def stats(repo):
    print(f"\n[*] Stats for {repo}")
    _stats_stars(repo)
    _stats_forks(repo)
    _stats_releases(repo)


# ==============================================================================
# MAIN
# ==============================================================================
def main():
    print("[*] Github Stats")
    list(map(lambda x: stats(x), REPOS))


if __name__ == '__main__':
    main()
