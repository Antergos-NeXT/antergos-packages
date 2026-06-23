#!/usr/bin/env python3
import json, os

pkgs = []
for f in os.listdir('repo'):
    if f.endswith('.pkg.tar.zst') and '-debug-' not in f:
        size = os.path.getsize(os.path.join('repo', f))
        pkgs.append({'name': f, 'size': size})

pkgs.sort(key=lambda p: p['name'])

rows = ''
for p in pkgs:
    size_mb = p['size'] / 1024 / 1024
    rows += f'''          <tr>
            <td><a href="{p['name']}">{p['name']}</a></td>
            <td>{size_mb:.1f} MB</td>
          </tr>
'''

html = f'''<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>antergos-pkgs</title>
  <style>
    * {{ margin: 0; padding: 0; box-sizing: border-box; }}
    body {{
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
      background: #080810; color: #c0c0d0;
      min-height: 100vh;
    }}
    .wrap {{ max-width: 960px; margin: 0 auto; padding: 32px 20px; }}

    .bar {{
      background: linear-gradient(135deg, #0d0d20 0%, #0a0a18 100%);
      border: 1px solid #1a1a2e; border-radius: 12px;
    }}

    h1 {{
      font-size: 2em; font-weight: 300; letter-spacing: 0.04em;
      padding: 32px 32px 8px; color: #e0e0f0;
    }}
    h1 span {{ color: #4A9EFF; font-weight: 400; }}
    .sub {{
      padding: 0 32px 24px; color: #5a5a7a; font-size: 0.9em;
      border-bottom: 1px solid #141428;
      display: flex; justify-content: space-between; flex-wrap: wrap; gap: 8px;
    }}
    .hal {{ color: #3a3a5a; font-style: italic; font-size: 0.85em; }}

    .setup {{
      margin: 24px 0; padding: 20px 24px; cursor: pointer;
    }}
    .setup summary {{
      color: #4A9EFF; font-size: 0.85em; font-weight: 500; cursor: pointer;
      outline: none;
    }}
    .setup summary::-webkit-details-marker {{ color: #4A9EFF; }}
    .setup pre {{
      background: #060610; border: 1px solid #1a1a2e; border-radius: 8px;
      padding: 16px; margin-top: 16px; overflow-x: auto;
      font-family: 'SF Mono', 'Fira Code', 'Cascadia Code', monospace; font-size: 0.82em;
      color: #9090b0; line-height: 1.6;
    }}
    .setup .c {{ color: #3a3a5a; }}
    .setup .v {{ color: #6aaf6a; }}

    .controls {{
      display: flex; gap: 12px; align-items: center; margin: 24px 0; flex-wrap: wrap;
    }}
    .controls input {{
      flex: 1; min-width: 200px;
      background: #0c0c1e; border: 1px solid #1a1a2e; border-radius: 8px;
      padding: 10px 14px; color: #c0c0d0; font-size: 0.9em;
      outline: none; transition: border-color 0.2s;
    }}
    .controls input:focus {{ border-color: #4A9EFF; }}
    .controls input::placeholder {{ color: #3a3a5a; }}
    .cnt {{ color: #4a4a6a; font-size: 0.85em; }}

    table {{ width: 100%; border-collapse: collapse; }}
    th {{
      text-align: left; padding: 10px 20px;
      color: #3a3a5a; font-size: 0.72em; font-weight: 600;
      text-transform: uppercase; letter-spacing: 0.12em;
      border-bottom: 1px solid #141428;
    }}
    td {{
      padding: 8px 20px; font-size: 0.88em;
      border-bottom: 1px solid #0e0e1e; vertical-align: middle;
    }}
    tr:last-child td {{ border: none; }}
    tbody tr:hover td {{ background: #0a0a18; }}
    tbody tr:hover {{ border-radius: 8px; }}

    td a {{
      color: #4A9EFF; text-decoration: none; font-weight: 500;
    }}
    td a:hover {{ color: #7aBEFF; text-decoration: underline; }}
    td.sz {{ color: #5a5a7a; text-align: right; font-variant-numeric: tabular-nums; }}

    .hidden {{ display: none !important; }}

    .ft {{
      text-align: center; padding: 32px 0 16px;
      color: #2a2a4a; font-size: 0.78em;
    }}
    .ft a {{ color: #3a3a6a; text-decoration: none; }}
    .ft a:hover {{ color: #4A9EFF; }}

    @media (max-width: 600px) {{
      .wrap {{ padding: 16px 12px; }}
      h1 {{ padding: 24px 20px 4px; font-size: 1.5em; }}
      .sub {{ padding: 0 20px 16px; }}
      td, th {{ padding: 8px 12px; }}
    }}
  </style>
</head>
<body>
  <div class="wrap">
    <div class="bar">
      <h1>⟁ antergos<span>-pkgs</span></h1>
      <div class="sub">
        <span>{len(pkgs)} packages &middot; {sum(p['size'] for p in pkgs) / 1024 / 1024:.0f} MB</span>
        <span class="hal">"I am putting myself to the fullest possible use."</span>
      </div>

      <details class="setup">
        <summary>Setup — add this repository to pacman.conf</summary>
        <pre><span class="c"># /etc/pacman.conf</span>
[antergos-pkgs]
SigLevel = Optional TrustAll
Server = https://antergos-next.github.io/antergos-packages/<span class="v">$repo</span>/os/<span class="v">$arch</span>
Server = https://antergos-next.github.io/antergos-packages</pre>
      </details>

      <div class="controls">
        <input type="text" id="q" placeholder="Search packages..." oninput="f()" autofocus>
        <span class="cnt" id="c">{len(pkgs)} packages</span>
      </div>

      <table>
        <thead>
          <tr><th>Package</th><th style="text-align:right">Size</th></tr>
        </thead>
        <tbody id="l">
{rows}        </tbody>
      </table>
    </div>

    <div class="ft">
      <a href="https://github.com/Antergos-NeXT/antergos-packages">GitHub</a> &middot;
      <a href="https://antergos-next.github.io/antergos-packages/">antergos-next.github.io</a>
    </div>
  </div>

  <script>
    function f() {{
      const q = document.getElementById('q').value.toLowerCase();
      const r = document.querySelectorAll('#l tr');
      let v = 0;
      for (let i = 0; i < r.length; i++) {{
        if (r[i].textContent.toLowerCase().includes(q)) {{
          r[i].classList.remove('hidden'); v++;
        }} else {{
          r[i].classList.add('hidden');
        }}
      }}
      document.getElementById('c').textContent = v + ' / {len(pkgs)} packages';
    }}
  </script>
</body>
</html>'''

with open('repo/index.html', 'w') as fp:
    fp.write(html)

with open('repo/pkglist.json', 'w') as fp:
    json.dump([{'name': p['name'], 'size': p['size']} for p in pkgs], fp, indent=2)
    fp.write('\n')
