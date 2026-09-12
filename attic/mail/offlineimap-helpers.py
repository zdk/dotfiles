#!/usr/bin/python
import commands
import re

def get_keychain_pass(account=None, server=None):
  cmd = "sudo security -v find-internet-password -w -a warachet -s imap.gmail.com -g"
  (status, output) = commands.getstatusoutput(cmd)
  return output.splitlines()[-1]
