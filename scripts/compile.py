from jinja2 import Environment, FileSystemLoader, Template
from pprint import pprint

import yaml
import sys

templates_dir = sys.argv[1]
input_filename = sys.argv[2]
output_filename = sys.argv[3]

with open(input_filename, 'r') as f:
    data = yaml.safe_load(f)

env = Environment(
    loader=FileSystemLoader(templates_dir),
    line_statement_prefix='#',
    variable_start_string='<',
    variable_end_string='>',
)
template = env.get_template('segment.tex')

if not data['tags']:
    data['tags'] = []
data['longest'] = max(data['tags'], key=len) if data['tags'] else ""

# difficult to work into jinja; {{ }} messes things up
data['tags'] = map(lambda s: '\\rectangled{{{}}}'.format(s), data['tags'])

with open(output_filename, 'w+') as f:
    f.write(template.render(data))