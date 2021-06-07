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
# difficult to work into jinja template; {{ }} messes things up
env.filters['rectangled'] = lambda s: '\\rectangled{{{}}}'.format(s)
template = env.get_template('segment.tex')
template_url = env.get_template('segment_url.tex')

if not data['tags']:
    data['tags'] = []
data['longest'] = max(data['tags'], key=len) if data['tags'] else ""

with open(output_filename, 'w+') as f:
    if 'url' in data:
        f.write(template_url.render(data))
    else:
        f.write(template.render(data))
