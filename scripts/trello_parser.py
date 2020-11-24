import os
import sys
import csv
import json
from pprint import pprint

G_LISTS = {}
G_CHECKLISTS = {}
G_CARDS = {}


# ==============================================================================
# UTILS
# ==============================================================================
def load_export(fname):
    with open(fname) as fp:
        body = fp.read()
    return json.loads(body)

def find_list(l):
    for k, v in G_LISTS.items():
        if k == l:
            return v

def find_checklists(checklists):
    res = []
    for c in checklists:
        for k, v in G_CHECKLISTS.items():
            if k == c:
                res.append(v)
    return res

def filter_by_list(l):
    return [v for k,v in G_CARDS.items() if v['list'] == l]

# ==============================================================================
# PARSERS
# ==============================================================================
def parse_lists(j):
    lists = j['lists']
    for l in lists:
        G_LISTS[l['id']] = l['name'].encode('utf-8')
    print("[*] Parsing lists: {} found".format(len(lists)))

def parse_checklists(j):
    checklists = j['checklists']
    for c in checklists:
        items = []
        for i in c['checkItems']:
            items.append({
                'name': i['name'].encode('utf-8'),
                'state': i['state']
            })
        G_CHECKLISTS[c['id']] = {
            'name': c['name'].encode('utf-8'),
            'items': items
        }
    print("[*] Parsing checklists: {} found".format(len(checklists)))

def parse_cards(j):
    cards = j['cards']
    for c in cards:
        labels = []
        for l in c['labels']:
            labels.append(l['name'])
        G_CARDS[c['id']] = {
            'name': c['name'].encode('utf-8'),
            'desc': c['desc'].encode('utf-8'),
            'labels': labels,
            'list': c['idList'],
            'checklists': find_checklists(c['idChecklists'])
        }
    print("[*] Parsing cards: {} found".format(len(cards)))

def parse(j):
    parse_lists(j)
    parse_checklists(j)
    parse_cards(j)


# ==============================================================================
# OUTPUT
# ==============================================================================
def print_by_list():
    for k,v in sorted(G_LISTS.items()):
        cards = filter_by_list(k)
        print("[+] {}: {} cards".format(v, len(cards)))
        for c in cards:
            pre = u'\u25B6'.encode('utf-8')
            print("\t {} {}".format(pre, c['name']))
            for checklist in c['checklists']:
                print("\t\t {}".format(checklist['name']))
                for item in checklist['items']:
                    if item['state'] == 'complete':
                        pre = u'\u2705'.encode('utf-8')
                    else:
                        pre = '[ ]'
                    print("\t\t\t {} {}".format(pre, item['name']))

def print_to_file(fname):
    with open(fname, "wb") as fp:
        writer = csv.writer(fp)
        writer.writerow(['list', 'title', 'description', 'labels', 'checklist'])
        for k, c in G_CARDS.items():
            temp = ""
            for checklist in c['checklists']:
                for item in checklist['items']:
                    if item['state'] == 'complete':
                        pre = u'\u2705'.encode('utf-8')
                    else:
                        pre = '[ ]'
                    temp += os.linesep + "{} {}".format(pre, item['name'])

            row = [find_list(c['list']), c['name'], c['desc'], c['labels'], temp]
            writer.writerow(row)


# ==============================================================================
# MAIN
# ==============================================================================
def main():
    if len(sys.argv) != 3:
        print("[!] Usage: {} <path to json file> <output csv>".format(sys.argv[0]))
        exit(0)

    j = load_export(sys.argv[1])
    parse(j)

    print_by_list()
    print_to_file(sys.argv[2])

if __name__ == '__main__':
    main()
