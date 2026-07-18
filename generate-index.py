#!/usr/bin/env python3
import json, os, re, subprocess, urllib.request
from datetime import datetime
import zoneinfo

PKG_DIR = 'packages'
REPO_DIR = 'repo'

def parse_pkgbuild(path):
    data = {}
    with open(path) as f:
        text = f.read()
    for key in ('pkgname', 'pkgver', 'pkgrel', 'pkgdesc', 'url', 'license', 'arch'):
        m = re.search(rf'^{key}=[\'"]?(.+?)[\'"]?$', text, re.M)
        if m:
            val = m.group(1).strip("'\"")
            if key == 'arch':
                val = val.strip('()').replace("'", '').replace('"', '').strip()
            data[key] = val
    deps = re.search(r'^depends=\((.*?)\)', text, re.DOTALL | re.M)
    if deps:
        raw = deps.group(1)
        data['depends'] = [d.strip("'\" ") for d in raw.strip().split('\n') if d.strip()]
    return data

def fetch_aur_info(pkgname):
    url = f"https://aur.archlinux.org/rpc/?v=5&type=info&arg[]={pkgname}"
    try:
        with urllib.request.urlopen(url, timeout=10) as resp:
            data = json.load(resp)
            if data['resultcount'] > 0:
                return data['results'][0]
    except Exception:
        pass
    return None

def category_for(pkgname, keywords=None, description=None):
    if pkgname.startswith('calamares'):
        return 'installer'
    if pkgname.startswith('antergos-wallpaper') or pkgname.startswith('antergos-next-desktop'):
        return 'branding'
    if pkgname in ('antergos-live', 'antergos-release', 'antergos-next-keyring', 'antergos-next-mirrorlist'):
        return 'core'
    if pkgname in ('antergos-welcome', 'antergos-next-memes', 'antergos-grub-theme'):
        return 'desktop'
    if pkgname in ('hal', 'downgrade'):
        return 'tool'
    if keywords:
        kw_lower = {k.lower() for k in keywords if isinstance(k, str)}
        if kw_lower & {'icon-theme', 'wallpaper', 'branding', 'sddm', 'grub'}:
            return 'branding'
        if kw_lower & {'installer', 'calamares', 'live'}:
            return 'installer'
        if kw_lower & {'keyring', 'mirrorlist'}:
            return 'core'
        if kw_lower & {'kwin', 'plasma', 'plasmoid', 'widget', 'wayland'}:
            return 'desktop'
        if kw_lower & {'cli', 'terminal', 'aur', 'helper', 'wrapper', 'alpm', 'search'}:
            return 'tool'
    if description:
        d = description.lower()
        if any(w in d for w in ['icon theme', 'icon-theme', 'wallpaper', 'branding', 'sddm']):
            return 'branding'
        if any(w in d for w in ['installer', 'calamares']):
            return 'installer'
        if any(w in d for w in ['kwin', 'plasma', 'plasmoid', 'wayland compositor']):
            return 'desktop'
        if any(w in d for w in ['terminal', 'cli', 'aur helper', 'pacman wrapper',
                                 'package manager', 'prompt theme', 'shell prompt',
                                 'shell tool', 'utility', 'search tool']):
            return 'tool'
    return 'other'

cat_colors = {
    'installer': '#4A9EFF',
    'branding': '#9B59B6',
    'core': '#2ECC71',
    'desktop': '#F39C12',
    'tool': '#E74C3C',
    'other': '#7F8C8D',
}

pkgs = []

for f in sorted(os.listdir(REPO_DIR)):
    if not f.endswith('.pkg.tar.zst') or '-debug-' in f:
        continue
    fpath = os.path.join(REPO_DIR, f)
    size = os.path.getsize(fpath)
    mtime = os.path.getmtime(fpath)
    mtime_dt = datetime.fromtimestamp(mtime, tz=zoneinfo.ZoneInfo('Europe/Berlin'))

    # strip .pkg.tar.zst and arch to get base name
    base = re.sub(r'-[^-]+-x86_64\.pkg\.tar\.zst$', '', f)
    base = re.sub(r'-any\.pkg\.tar\.zst$', '', base)
    # remove version suffix to match directory
    dirname = re.sub(r'-\d+[\d.]*-\d+$', '', base)
    if dirname == 'calamares-branding-antergos-next':
        dirname = 'calamares-branding-antergos-next'

    pkgbuild_path = os.path.join(PKG_DIR, dirname, 'PKGBUILD')
    has_local = os.path.exists(pkgbuild_path)
    meta = parse_pkgbuild(pkgbuild_path) if has_local else {}

    # extract version from filename: name-ver-rel-arch.pkg.tar.zst
    ver_match = re.match(r'.+-(\d+[\d.]*)-(\d+)-(any|x86_64)\.pkg\.tar\.zst', f)
    pkgver = ver_match.group(1) if ver_match else (meta.get('pkgver', '?'))
    pkgrel = ver_match.group(2) if ver_match else (meta.get('pkgrel', '?'))
    arch = ver_match.group(3) if ver_match else (meta.get('arch', '?'))

    pkgname = meta.get('pkgname', dirname)
    aur_info = fetch_aur_info(pkgname) if not has_local else None
    keywords = aur_info.get('Keywords', []) if aur_info else []
    description = meta.get('pkgdesc', aur_info.get('Description', '') if aur_info else '')
    cat = category_for(pkgname, keywords, description)

    pkgs.append({
        'file': f,
        'name': pkgname,
        'version': f'{pkgver}-{pkgrel}',
        'arch': arch,
        'size': size,
        'mtime': mtime_dt.isoformat(),
        'mtime_display': mtime_dt.strftime('%Y-%m-%d %H:%M CET/CEST'),
        'category': cat,
        'cat_color': cat_colors.get(cat, '#7F8C8D'),
        'description': description,
        'url': meta.get('url', aur_info.get('URL', '') if aur_info else ''),
        'license': meta.get('license', ', '.join(aur_info.get('License', [])) if aur_info else ''),
        'depends': meta.get('depends', aur_info.get('Depends', []) if aur_info else []),
    })

pkgs.sort(key=lambda p: p['name'])

rows_json = json.dumps(pkgs)
total_size_mb = sum(p['size'] for p in pkgs) / 1024 / 1024
generated = datetime.now(tz=zoneinfo.ZoneInfo('Europe/Berlin')).strftime('%Y-%m-%d %H:%M CET/CEST')

html = f'''<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>⟁ antergos-pkgs</title>
  <script src="https://cdn.tailwindcss.com"></script>
  <script>
    tailwind.config = {{
      theme: {{
        extend: {{
          colors: {{
            abyss: '#06060f',
            surface: '#0b0b1a',
            card: '#0f0f24',
            border: '#1a1a35',
            muted: '#3a3a5a',
            dim: '#5a5a7a',
            base: '#c0c0d0',
            bright: '#e0e0f0',
            accent: '#4A9EFF',
            'accent-glow': '#6aBEFF',
          }}
        }}
      }}
    }}
  </script>
  <style>
    @import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap');
    * {{ margin: 0; padding: 0; box-sizing: border-box; }}
    body {{
      font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
      background: #06060f; color: #c0c0d0; min-height: 100vh;
    }}
    .glow {{ box-shadow: 0 0 40px -12px rgba(74, 158, 255, 0.15); }}
    .glow:hover {{ box-shadow: 0 0 60px -8px rgba(74, 158, 255, 0.25); }}
    th {{ cursor: pointer; user-select: none; position: sticky; top: 0; z-index: 10; }}
    th:hover {{ color: #4A9EFF !important; }}
    th .arrow {{ opacity: 0; display: inline-block; transition: all 0.2s; }}
    th:hover .arrow, th.asc .arrow, th.desc .arrow {{ opacity: 1; }}
    th.asc .arrow {{ transform: rotate(0deg); }}
    th.desc .arrow {{ transform: rotate(180deg); }}
    tr.row {{ transition: background 0.15s, transform 0.15s; }}
    tr.row:hover {{ background: rgba(74, 158, 255, 0.04); }}
    tr.row td:first-child {{ border-radius: 8px 0 0 8px; }}
    tr.row td:last-child {{ border-radius: 0 8px 8px 0; }}
    .badge {{ transition: all 0.2s; }}
    .badge:hover {{ filter: brightness(1.2); transform: translateY(-1px); }}
    .fade-in {{ animation: fadeIn 0.5s ease-out both; }}
    @keyframes fadeIn {{ from {{ opacity: 0; transform: translateY(12px); }} to {{ opacity: 1; transform: translateY(0); }} }}
    .pulse-dot {{
      display: inline-block; width: 8px; height: 8px; border-radius: 50%;
      background: #2ECC71; margin-right: 6px;
      animation: pulse 2s ease-in-out infinite;
    }}
    @keyframes pulse {{ 0%, 100% {{ opacity: 1; }} 50% {{ opacity: 0.3; }} }}
    input[type="text"]:focus {{ outline: none; border-color: #4A9EFF !important; box-shadow: 0 0 0 3px rgba(74, 158, 255, 0.1); }}
    ::-webkit-scrollbar {{ width: 6px; height: 6px; }}
    ::-webkit-scrollbar-track {{ background: #0b0b1a; }}
    ::-webkit-scrollbar-thumb {{ background: #1a1a35; border-radius: 3px; }}
    ::-webkit-scrollbar-thumb:hover {{ background: #3a3a5a; }}
    @media (max-width: 640px) {{ .hide-mobile {{ display: none; }} }}
  </style>
</head>
<body>
  <div class="max-w-6xl mx-auto px-4 sm:px-6 py-8">
    <!-- Header -->
    <div class="text-center mb-10 fade-in">
      <h1 class="text-5xl sm:text-6xl font-light tracking-tight text-bright">
        ⟁ <span class="font-normal text-accent">antergos</span><span class="text-dim font-light">-pkgs</span>
      </h1>
      <p class="text-dim text-sm mt-3 max-w-xl mx-auto leading-relaxed">
        Custom package repository for Antergos NeXT ISO builds.
        <br class="sm:hidden">Packages are built automatically via CI.
      </p>
    </div>

    <!-- Stats bar -->
    <div class="flex flex-wrap gap-4 justify-center mb-8 text-xs text-dim">
      <span class="bg-surface border border-border rounded-full px-4 py-2 flex items-center gap-2">
        <span class="pulse-dot"></span> {len(pkgs)} packages
      </span>
      <span class="bg-surface border border-border rounded-full px-4 py-2">{total_size_mb:.0f} MB total</span>
      <span class="bg-surface border border-border rounded-full px-4 py-2">updated {generated}</span>
    </div>

    <!-- Setup collapsible -->
    <details class="bg-card border border-border rounded-xl mb-6 glow transition-all duration-300 group">
      <summary class="px-5 py-4 text-accent cursor-pointer text-sm font-medium select-none
        list-none flex items-center gap-2 hover:text-accent-glow transition-colors">
        <svg class="w-4 h-4 transition-transform duration-200 group-open:rotate-90" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
        </svg>
        Setup — add this repository to your <code class="text-bright bg-abyss px-1.5 py-0.5 rounded text-xs">pacman.conf</code>
      </summary>
      <div class="px-5 pb-5">
        <pre class="bg-abyss border border-border rounded-lg p-4 text-sm overflow-x-auto font-['JetBrains_Mono'] text-dim leading-relaxed">
<span class="text-muted"># /etc/pacman.conf</span>
<span class="text-accent">[antergos-pkgs]</span>
SigLevel = <span class="text-[#6aaf6a]">Optional TrustAll</span>
Server = <span class="text-[#6aaf6a]">https://antergos-next.github.io/antergos-packages/</span><span class="text-[#e0e0f0]">$repo</span>/os/<span class="text-[#e0e0f0]">$arch</span></pre>
      </div>
    </details>

    <!-- Controls -->
    <div class="flex flex-wrap gap-3 items-center mb-5">
      <div class="relative flex-1 min-w-[200px]">
        <svg class="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-muted" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
        </svg>
        <input type="text" id="q" placeholder="Search packages..." autofocus
          class="w-full bg-card border border-border rounded-lg pl-10 pr-4 py-2.5 text-sm text-base placeholder:text-muted transition-all" />
      </div>
      <select id="catFilter"
        class="bg-card border border-border rounded-lg px-3 py-2.5 text-sm text-dim cursor-pointer hover:text-base transition-colors">
        <option value="all">All categories</option>
        <option value="installer">Installer</option>
        <option value="branding">Branding</option>
        <option value="core">Core</option>
        <option value="desktop">Desktop</option>
        <option value="tool">Tool</option>
        <option value="other">Other</option>
      </select>
      <span class="text-xs text-dim" id="count">{len(pkgs)} packages</span>
    </div>

    <!-- Table -->
    <div class="bg-card border border-border rounded-xl overflow-hidden glow">
      <div class="overflow-x-auto">
        <table class="w-full text-sm">
          <thead>
            <tr class="bg-abyss/50 text-muted text-xs uppercase tracking-wider">
              <th class="px-4 py-3.5 text-left font-semibold" data-col="name" onclick="sort('name')">
                Package <span class="arrow">▼</span>
              </th>
              <th class="px-4 py-3.5 text-left font-semibold hide-mobile" data-col="version" onclick="sort('version')">
                Version <span class="arrow">▼</span>
              </th>
              <th class="px-4 py-3.5 text-left font-semibold hide-mobile" data-col="arch" onclick="sort('arch')">
                Arch <span class="arrow">▼</span>
              </th>
              <th class="px-4 py-3.5 text-left font-semibold" data-col="category" onclick="sort('category')">
                Category <span class="arrow">▼</span>
              </th>
              <th class="px-4 py-3.5 text-right font-semibold hide-mobile" data-col="size" onclick="sort('size')">
                Size <span class="arrow">▼</span>
              </th>
              <th class="px-4 py-3.5 text-right font-semibold hide-mobile" data-col="mtime" onclick="sort('mtime')">
                Updated <span class="arrow">▼</span>
              </th>
            </tr>
          </thead>
          <tbody id="list"></tbody>
        </table>
      </div>
    </div>

    <!-- Footer -->
    <div class="text-center mt-10 text-xs text-muted">
      <a href="https://github.com/Antergos-NeXT/antergos-packages" class="hover:text-accent transition-colors">GitHub</a>
      <span class="mx-2">·</span>
      <a href="https://antergos-next.github.io/antergos-packages/" class="hover:text-accent transition-colors">antergos-next.github.io</a>
      <span class="mx-2">·</span>
      <a href="https://github.com/Antergos-NeXT/antergos-iso" class="hover:text-accent transition-colors">ISO repo</a>
    </div>
  </div>

  <script>
    const pkgs = {rows_json};
    let sortCol = 'name';
    let sortDir = 1;
    let filtered = pkgs;

    function formatSize(bytes) {{
      const mb = bytes / 1024 / 1024;
      return mb >= 1 ? mb.toFixed(1) + ' MB' : (bytes / 1024).toFixed(0) + ' KB';
    }}

    function escapeHtml(s) {{
      const d = document.createElement('div');
      d.textContent = s;
      return d.innerHTML;
    }}

    function render() {{
      const q = document.getElementById('q').value.toLowerCase();
      const cat = document.getElementById('catFilter').value;

      filtered = pkgs.filter(p => {{
        const matchSearch = p.name.toLowerCase().includes(q) || p.description.toLowerCase().includes(q);
        const matchCat = cat === 'all' || p.category === cat;
        return matchSearch && matchCat;
      }});

      // sort
      filtered.sort((a, b) => {{
        let va = a[sortCol], vb = b[sortCol];
        if (sortCol === 'size' || sortCol === 'mtime') {{ va = a[sortCol]; vb = b[sortCol]; return (va - vb) * sortDir; }}
        if (typeof va === 'string') va = va.toLowerCase();
        if (typeof vb === 'string') vb = vb.toLowerCase();
        if (va < vb) return -1 * sortDir;
        if (va > vb) return 1 * sortDir;
        return 0;
      }});

      const tbody = document.getElementById('list');
      tbody.innerHTML = filtered.map((p, i) => {{
        const catLabel = p.category.charAt(0).toUpperCase() + p.category.slice(1);
        return `<tr class="row" style="animation-delay: ${{i * 30}}ms">
          <td class="px-4 py-3">
            <div class="flex items-center gap-2.5">
              <a href="${{escapeHtml(p.file)}}" class="text-accent hover:text-accent-glow font-medium transition-colors truncate max-w-[200px] sm:max-w-none block">${{escapeHtml(p.name)}}</a>
            </div>
            <div class="text-dim text-xs mt-0.5 truncate max-w-[280px] sm:max-w-none">${{escapeHtml(p.description)}}</div>
          </td>
          <td class="px-4 py-3 text-dim hide-mobile font-mono text-xs">${{escapeHtml(p.version)}}</td>
          <td class="px-4 py-3 hide-mobile"><span class="text-xs bg-abyss border border-border rounded px-1.5 py-0.5 text-dim">${{escapeHtml(p.arch)}}</span></td>
          <td class="px-4 py-3">
            <span class="badge inline-block text-xs font-medium rounded-full px-2.5 py-0.5" style="background: ${{p.cat_color}}18; color: ${{p.cat_color}}; border: 1px solid ${{p.cat_color}}33">${{catLabel}}</span>
          </td>
          <td class="px-4 py-3 text-dim text-right hide-mobile font-mono text-xs">${{formatSize(p.size)}}</td>
          <td class="px-4 py-3 text-dim text-right hide-mobile text-xs">${{p.mtime_display}}</td>
        </tr>`;
      }}).join('');

      document.getElementById('count').textContent = filtered.length + ' / ' + pkgs.length + ' packages';
    }}

    function sort(col) {{
      if (sortCol === col) {{ sortDir *= -1; }} else {{ sortCol = col; sortDir = 1; }}
      document.querySelectorAll('th').forEach(th => th.classList.remove('asc', 'desc'));
      const el = document.querySelector(`th[data-col="${{col}}"]`);
      if (el) el.classList.add(sortDir === 1 ? 'asc' : 'desc');
      render();
    }}

    document.getElementById('q').addEventListener('input', render);
    document.getElementById('catFilter').addEventListener('change', render);

    // init: sort by name asc
    document.querySelector('th[data-col="name"]').classList.add('asc');
    render();
  </script>
</body>
</html>'''

with open(os.path.join(REPO_DIR, 'index.html'), 'w') as f:
    f.write(html)

with open(os.path.join(REPO_DIR, 'pkglist.json'), 'w') as f:
    json.dump([{
        'name': p['name'],
        'version': p['version'],
        'arch': p['arch'],
        'size': p['size'],
        'category': p['category'],
        'description': p['description'],
        'url': p['url'],
        'mtime': p['mtime'],
    } for p in pkgs], f, indent=2)
    f.write('\n')

print(f'OK — {len(pkgs)} packages, index.html + pkglist.json written to {REPO_DIR}/')
