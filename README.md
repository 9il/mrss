libmrss D Wrapper
====================
Ported to the [D Programming language](https://dlang.org) by Laeeth Isharc 2015,2016,2017 with changes by Ilya Yaroshenko.

Generated documentation at [Kaleidic Open Source - MRSS](http://mrss.code.kaleidic.io)

[mRss](http://www.autistici.org/bakunin/libmrss/doc/) is a C library for parsing, writing and creating RSS/ATOM files or streams.

This library supports:
 - RSS 0.91 - http://my.netscape.com/publish/formats/rss-spec-0.91.html
 - RSS 0.92 - http://backend.userland.com/rss092
 - RSS 1.0 - http://web.resource.org/rss/1.0/
 - RSS 2.0 - http://www.rssboard.org/rss-specification
 - ATOM 0.3 - http://www.mnot.net/drafts/draft-nottingham-atom-format-02.html
 - ATOM 1.0 - http://tools.ietf.org/html/rfc4287

Original author Andrea Marchesini <bakunin@autistici.org> - Web Site: http://www.autistici.org/bakunin/



# Usage
```D
import deimos.mrss;
import etc.c.curl;
import std.string;
import std.stdio:writefln,writef,stderr;
import std.range:repeat;
import std.array:array;

bool isURL(string s)
{
  return ((s.startsWith("http://")) || (s.startsWith("https://")));
}
///
int main (string[] args)
{
  mrss_t *data;
  mrss_error_t ret;
  mrss_hour_t *hour;
  mrss_day_t *day;
  mrss_category_t *category;
  mrss_item_t *item;
  CURLcode code;

  if (args.length != 2)
  {
      stderr.writefln("Usage:\n\t%s url_rss\n\nExample:\n\t%s http://ngvision.org/rss|file.rss\n", args[0],args[0]);
      return 1;
    }

  if (args[1].isURL)
  {
    ret = mrss_parse_url_with_options_and_error (cast(char*) args[1].toStringz, &data, null, &code);
  }
  else
  {
    ret = mrss_parse_file (cast(char*) args[1].toStringz, &data);
  }

  if (ret)
  {
    stderr.writefln("MRSS return error: %s",
       (ret == mrss_error_t.MRSS_ERR_DOWNLOAD) ? mrss_curl_strerror (code) : mrss_strerror (ret));
    return 1;
  }

  writefln("\nGeneric:");
  writefln("\tfile: %s", data.file.fromStringz);
  writefln("\tencoding: %s", data.encoding);
  writefln("\tsize: %d", cast(int) data.size);
  writefln("\tversion: %s", data.version_);

  writefln("\nChannel:");
  writefln("\ttitle: %s", data.title);
  writefln("\tdescription: %s", data.description);
  writefln("\tlink: %s", data.link);
  writefln("\tlanguage: %s", data.language);
  writefln("\trating: %s", data.rating);
  writefln("\tcopyright: %s", data.copyright);
  writefln("\tpubDate: %s", data.pubDate);
  writefln("\tlastBuildDate: %s", data.lastBuildDate);
  writefln("\tdocs: %s", data.docs);
  writefln("\tmanagingeditor: %s", data.managingeditor);
  writefln("\twebMaster: %s", data.webMaster);
  writefln("\tgenerator: %s", data.generator);
  writefln("\tttl: %d", data.ttl);
  writefln("\tabout: %s", data.about);

  writef("\nImage:\n");
  writef("\timage_title: %s\n", data.image_title);
  writef("\timage_url: %s\n", data.image_url);
  writef("\timage_link: %s\n", data.image_link);
  writef("\timage_width: %d\n", data.image_width);
  writef("\timage_height: %d\n", data.image_height);
  writef("\timage_description: %s\n", data.image_description);

  writef("\nTextInput:\n");
  writef("\ttextinput_title: %s\n", data.textinput_title);
  writef("\ttextinput_description: %s\n",
	   data.textinput_description);
  writef("\ttextinput_name: %s\n", data.textinput_name);
  writef("\ttextinput_link: %s\n", data.textinput_link);

  writefln("\nCloud:");
  writefln("\tcloud: %s", data.cloud);
  writefln("\tcloud_domain: %s", data.cloud_domain);
  writefln("\tcloud_port: %d", data.cloud_port);
  writefln("\tcloud_registerProcedure: %s", data.cloud_registerProcedure);
  writefln("\tcloud_protocol: %s", data.cloud_protocol);

  writefln("\nSkipHours:");
  hour = data.skipHours;
  while (hour)
  {
      writefln("\t%s", hour.hour);
      hour = hour.next;
  }

  writef("\nSkipDays:\n");
  day = data.skipDays;
  while (day)
  {
      writefln("\t%s", day.day);
      day = day.next;
  }

  writefln("\nCategory:");
  category = data.category;
  while (category)
  {
    writefln("\tcategory: %s", category.category);
    writefln("\tcategory_domain: %s", category.domain);
    category = category.next;
  }

  if (data.other_tags)
    print_tags (data.other_tags, 0);

  writefln("\nItems:");
  item = data.item;
  while (item)
  {
    writef("\ttitle: %s\n", item.title);
    writef("\tlink: %s\n", item.link);
    writef("\tdescription: %s\n", item.description);
    writef("\tauthor: %s\n", item.author);
    writef("\tcomments: %s\n", item.comments);
    writef("\tpubDate: %s\n", item.pubDate);
    writef("\tguid: %s\n", item.guid);
    writef("\tguid_isPermaLink: %d\n", item.guid_isPermaLink);
    writef("\tsource: %s\n", item.source);
    writef("\tsource_url: %s\n", item.source_url);
    writef("\tenclosure: %s\n", item.enclosure);
    writef("\tenclosure_url: %s\n", item.enclosure_url);
    writef("\tenclosure_length: %d\n", item.enclosure_length);
    writef("\tenclosure_type: %s\n", item.enclosure_type);

    writef("\tCategory:\n");
    category = item.category;
    while (category)
  	{
  	  writef("\t\tcategory: %s\n", category.category);
  	  writef("\t\tcategory_domain: %s\n", category.domain);
  	  category = category.next;
  	}

    if (item.other_tags !is null)
      print_tags (item.other_tags, 1);

    writef("\n");
    item = item.next;
  }
  mrss_free(data);
  return 0;
}

string tabify(int i)
{
  return '\t'.repeat(i).array;
}

///
extern(C) static void
print_tags (mrss_tag_t * tag, int index)
{
  mrss_attribute_t *attribute;
  int i;

  writef(index.tabify);
  writefln("Other Tags:");
  while (tag)
  {
    writef(index.tabify);
    writefln("\ttag name: %s", tag.name);
    writef(index.tabify);
    writefln("\ttag value: %s", tag.value);
    writef(index.tabify);
    writefln("\ttag ns: %s", tag.ns);
    if (tag.children !is null)
      print_tags(tag.children, index + 1);
    for (attribute = tag.attributes; attribute; attribute = attribute.next)
    {
      writef(index.tabify);
      writefln("\tattribute name: %s", attribute.name);
      writef(index.tabify);
      writefln("\tattribute value: %s", attribute.value);
      writef(index.tabify);
  	  writefln("\tattribute ns: %s", attribute.ns);
	   }
    tag = tag.next;
  }
}

```
