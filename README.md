libmrss D interface
====================
[mRss](http://www.autistici.org/bakunin/libmrss/doc/) is a C library for parsing, writing and creating RSS/ATOM files or streams.

This library supports:
 - RSS 0.91 - http://my.netscape.com/publish/formats/rss-spec-0.91.html
 - RSS 0.92 - http://backend.userland.com/rss092
 - RSS 1.0 - http://web.resource.org/rss/1.0/
 - RSS 2.0 - http://www.rssboard.org/rss-specification
 - ATOM 0.3 - http://www.mnot.net/drafts/draft-nottingham-atom-format-02.html
 - ATOM 1.0 - http://tools.ietf.org/html/rfc4287


# Author
Andrea Marchesini <bakunin@autistici.org> - Web Site: http://www.autistici.org/bakunin/

# Usage
```D
import deimos.mrss;
import core.sys.posix.sys.types;
import etc.c.curl;
```
