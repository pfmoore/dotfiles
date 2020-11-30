# Keypirinha launcher (keypirinha.com)

import keypirinha as kp
import keypirinha_util as kpu

from collections import namedtuple
from html.parser import HTMLParser
import datetime
import os
from urllib.request import urlopen

def get(attrs, key):
    for k, v in attrs:
        if key == k:
            return v

class MyHTMLParser(HTMLParser):
    def __init__(self):
        super().__init__()
        self.in_numindex = 0
        self.PEPs = []
        self.row = []
        self.collecting = False
        self.coldata = ""

    def handle_starttag(self, tag, attrs):
        if tag == "div":
            if self.in_numindex > 0:
                self.in_numindex += 1
            elif get(attrs,"id") == "numerical-index":
                self.in_numindex = 1
        elif self.in_numindex <= 0:
            return
        elif tag == "tr" and self.in_numindex > 0:
            self.collecting = True
            self.col = 0
            self.row = []
        elif tag == "td":
            if self.collecting:
                self.col += 1
                self.coldata = ""

    def handle_endtag(self, tag):
        if tag == "div" and self.in_numindex > 0:
            self.in_numindex -= 1
        elif tag == "tr":
            if self.collecting:
                if self.row:
                    self.PEPs.append((int(self.row[0]), self.row[1]))
                self.row = []
                self.collecting = False
        elif tag == "td":
            if self.coldata:
                self.row.append(self.coldata)
                self.coldata = ""

    def handle_data(self, data):
        if self.collecting and self.col in (2,3):
            self.coldata += data

class PEPs(kp.Plugin):
    """Python PEP search plugin"""

    ITEMCAT_RESULT = kp.ItemCategory.USER_BASE + 1

    def __init__(self):
        super().__init__()
        self._debug = True

    def on_start(self):
        with urlopen("https://www.python.org/dev/peps/") as f:
            data = f.read().decode("utf-8")
        parser = MyHTMLParser()
        parser.feed(data)
        self.PEPs = parser.PEPs

        self.set_actions(self.ITEMCAT_RESULT, [
            self.create_action(
                name="open",
                label="Open",
                short_desc="Open the PEP in a browser"),
            self.create_action(
                name="copy",
                label="Copy URL",
                short_desc="Copy the URL of the PEP"),
            self.create_action(
                name="copy_md",
                label="Copy as Markdown",
                short_desc="Copy a Markdown link to the URL")])


    def on_catalog(self):
         self.set_catalog([
            self.create_item(
                category=self.ITEMCAT_RESULT,
                label="PEP {}: {}".format(num, desc),
                short_desc=desc,
                target="https://www.python.org/dev/peps/pep-{:04d}/".format(num),
                args_hint=kp.ItemArgsHint.FORBIDDEN,
                hit_hint=kp.ItemHitHint.KEEPALL,
            )
            for num, desc in self.PEPs
        ])

    def on_suggest(self, user_input, items_chain):
        if not items_chain or items_chain[-1].category() != kp.ItemCategory.KEYWORD:
            return

    def on_execute(self, item, action):
        self.dbg(action.name() if action else "No action")
        self.dbg(item.category() if item else "No item")
        if item and item.category() == self.ITEMCAT_RESULT:
            if action and action.name() == "copy":
                kpu.set_clipboard(item.target())
            elif action and action.name() == "copy_md":
                link = "[{}]({})".format(item.label().split(":", maxsplit=1)[0], item.target())
                kpu.set_clipboard(link)
            else:
                self.dbg("Launching", item.target())
                kpu.web_browser_command(url=item.target(), execute=True)
