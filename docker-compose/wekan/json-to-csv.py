"""
    Wekan JSON -> CSV Converter

    Parse a JSON export of a Wekan board and produce a CSV file containing,
    for every card:
        * swimlane
        * list
        * title
        * description (with checklists)
        * labels
        * user
        * members
        * created_at
        * last_activity

    Usage: convert.py -i <input json file>
"""
import csv
import json
import os.path
from argparse import ArgumentParser


# ==============================================================================
# UTILS
# ==============================================================================
def is_valid_file(parser, arg):
    if not os.path.exists(arg):
        parser.error("The file %s does not exist!" % arg)
    else:
        return open(arg, 'r')  # return an open file handle


# ==============================================================================
# CONVERT
# ==============================================================================
def convert(args):
    # Load JSON
    body = args.filename.read()
    js = json.loads(body)

    # Parse Fields
    title           = js['title']
    users           = js['users']
    swimlanes       = js['swimlanes']
    lists           = js['lists']
    labels          = js['labels']
    checklists      = js['checklists']
    checklist_items = js['checklistItems']
    cards           = js['cards']

    # Open output file
    fname_output = "{}.csv".format(title)
    fp = csv.writer(open(fname_output, "w"))
    fp.writerow(["swimlane", "list", "title", "description", "labels", "user", "members", "created_at", "last_activity"])

    # Parse cards
    for c in cards:
        c_id                = c['_id']
        title               = c['title']
        description         = c.get('description', '')
        created_at          = c['createdAt']
        date_last_activity  = c['dateLastActivity']

        user                = next((item for item in users if item["_id"] == c['userId']), None)['username']
        swimlane_title      = next((item for item in swimlanes if item["_id"] == c['swimlaneId']), None)['title']
        list_title          = next((item for item in lists if item["_id"] == c['listId']), None)['title']

        members = []
        for m in c['members']:
            members.append(next((item for item in users if item["_id"] == m), None)['username'])
        members = ', '.join(members)

        label_names = ""
        for la in c['labelIds']:
            temp = next((item for item in labels if item["_id"] == la), None)
            if temp:
                label_names += "{} | ".format(temp['name'])
        label_names = label_names.rstrip(' | ')

        c_checklists = {}
        for cl in checklists:
            if cl['cardId'] == c_id:
                c_checklists[cl['_id']] = {'title': cl['title'], 'items': []}
        for ci in checklist_items:
            try:
                c_checklists[ci['checklistId']]['items'].append(ci['title'])
            except:
                pass

        for k, v in c_checklists.items():
            description = "{}\n\n{}:\n".format(description, v['title'])
            for it in v['items']:
                description = "{}* {}\n".format(description, it)

        fp.writerow([swimlane_title, list_title, title, description, label_names, user, members, created_at, date_last_activity])

    print("Results printed to file: {}".format(fname_output))


# ==============================================================================
# MAIN
# ==============================================================================
def main():
    parser = ArgumentParser(description="Wekan JSON -> CSV Converter")
    parser.add_argument("-i", dest="filename", help="Input JSON file",
                        required=True, metavar="FILE",
                        type=lambda x: is_valid_file(parser, x))
    args = parser.parse_args()
    convert(args)

if __name__ == '__main__':
    main()