import subprocess

from qutebrowser.config.configfiles import ConfigAPI  # noqa: F401
from qutebrowser.config.config import ConfigContainer  # noqa: F401
from qutebrowser.api import interceptor, message

# pylint: disable=C0111
config: ConfigAPI = config  # noqa: F821 pylint: disable=E0602,C0103
c: ConfigContainer = c  # noqa: F821 pylint: disable=E0602,C0103

config.load_autoconfig()

c.completion.shrink = True
c.colors.webpage.preferred_color_scheme = "dark"
c.colors.webpage.darkmode.enabled = True
c.scrolling.smooth = True


c.url.searchengines = {
    "DEFAULT": "https://duckduckgo.com/?q={}",
    "pkg": "https://pkg.go.dev/search?q={}",
    "pypi": "https://pypi.org/search/?q={}",
    "pub": "https://pub.dev/packages?q={}",
    "aw": "https://wiki.archlinux.org/index.php?search={}",
    "yt": "https://www.youtube.com/results?search_query={}",
    "gh": "https://github.com/search?q={}",
    "maps": "https://www.google.com/maps/search/{}",
}

config.bind(",v", "spawn mpv --wayland-app-id=mpv-pip {url}")
config.bind(",V", "hint links spawn mpv  {hint-url}")
config.bind(",d", "config-cycle colors.webpage.darkmode.enabled True False")
config.bind(",r", "config-source")
config.bind(",p", "spawn --userscript qute-bitwarden")


light_mode_whitelist = [
    "*://www.youtube.com/*",
    "*://web.whatsapp.com/*",
    "*://pub.dev/*",
    "*://*.google.com/*",
]

for site in light_mode_whitelist:
    config.set("colors.webpage.darkmode.enabled", False, site)


autoplay_blocklist = [
    "https://*.youtube.com/*",
]
for site in autoplay_blocklist:
    config.set("content.autoplay", False, site)
