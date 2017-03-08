
# Sneaking some python as we snake our way down the gopher hole..

from fabric.api import env, local, run, cd, lcd, sudo, warn_only

def run():
	"""Runs local docs server"""
	local("jekyll serve -d ../_revel_docs .")
	
