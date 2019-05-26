import std.stdio;
import deimos.mrss;
import std.string;
import std.range;
import std.array;
import std.conv;
import etc.c.curl: CURLcode;

string ZtoString(const char* c)
{
    if (c !is null)
      return to!string(fromStringz(c));
    else
      return null;
}

char* toZString(string s)
{
	char[] ret=cast(char[])s;
	if (ret[$-1]!='\0')
		ret~="\0";
	return ret.ptr;
}

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
	stderr.writefln("Usage:\n\t%s url_rss\n\nExample:\n\t%s http://ngvision.org/rss|file.rss\n\n",args[0],args[0]);
	  return 1;
	}

	auto url=args[1];
	if ((url[0..8]!="http://") &&(url[0..9]!="https://"))
		ret = mrss_parse_url_with_options_and_error(toZString(url), &data, null, &code);
	else
		ret = mrss_parse_file (toZString(url), &data);

	if (ret)
	{
		stderr.writefln("MRSS return error: %s", ret == mrss_error_t.MRSS_ERR_DOWNLOAD ? ZtoString(mrss_curl_strerror (code) ):
		   ZtoString(mrss_strerror (ret)));
		return 1;
	}

	writefln("\nGeneric:");
	writefln("\tfile: %s", data.file);
	writefln("\tencoding: %s", data.encoding);
	writefln("\tsize: %s", data.size);
/+
	writef("\tversion:");
	switch (data._version)
	{
		case mrss_version_t.MRSS_VERSION_0_91:
			writef(" 0.91\n");
			break;

		case mrss_version_t.MRSS_VERSION_0_92:
			writef(" 0.92\n");
			break;

		case mrss_version_t.MRSS_VERSION_1_0:
			writef(" 1.0\n");
			break;

		case mrss_version_t.MRSS_VERSION_2_0:
			writef(" 2.0\n");
			break;

		case mrss_version_t.MRSS_VERSION_ATOM_1_0:
			writef(" Atom 1.0\n");
			break;

		case mrss_version_t.MRSS_VERSION_ATOM_0_3:
			writef(" Atom 0.3\n");
			break;
		default:
			assert(0);
	}
+/
	writef("\nChannel:\n");
	writef("\ttitle: %s\n", data.title);
	writef("\tdescription: %s\n", data.description);
	writef("\tlink: %s\n", data.link);
	writef("\tlanguage: %s\n", data.language);
	writef("\trating: %s\n", data.rating);
	writef("\tcopyright: %s\n", data.copyright);
	writef("\tpubDate: %s\n", data.pubDate);
	writef("\tlastBuildDate: %s\n", data.lastBuildDate);
	writef("\tdocs: %s\n", data.docs);
	writef("\tmanagingeditor: %s\n", data.managingeditor);
	writef("\twebMaster: %s\n", data.webMaster);
	writef("\tgenerator: %s\n", data.generator);
	writef("\tttl: %d\n", data.ttl);
	writef("\tabout: %s\n", data.about);

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

	writef("\nCloud:\n");
	writef("\tcloud: %s\n", data.cloud);
	writef("\tcloud_domain: %s\n", data.cloud_domain);
	writef("\tcloud_port: %d\n", data.cloud_port);
	writef("\tcloud_registerProcedure: %s\n",
	   data.cloud_registerProcedure);
	writef("\tcloud_protocol: %s\n", data.cloud_protocol);

	writef("\nSkipHours:\n");
	hour = data.skipHours;
	while (hour)
	{
	  writef("\t%s\n", hour.hour);
	  hour = hour.next;
	}

	writef("\nSkipDays:\n");
	day = data.skipDays;
	while (day)
	{
	  writef("\t%s\n", day.day);
	  day = day.next;
	}

	writef("\nCategory:\n");
	category = data.category;
	while (category)
	{
	  writef("\tcategory: %s\n", category.category);
	  writef("\tcategory_domain: %s\n", category.domain);
	  category = category.next;
	}

	if (data.other_tags)
	print_tags (data.other_tags, 0);

	writef("\nItems:\n");
	item = data.item;
	while (item)
	{
		writef("\ttitle: %s\n", ZtoString(item.title));
		writef("\tlink: %s\n", ZtoString(item.link));
		writef("\tdescription: %s\n", ZtoString(item.description));
		writef("\tauthor: %s\n", ZtoString(item.author));
		writef("\tcomments: %s\n", ZtoString(item.comments));
		writef("\tpubDate: %s\n", ZtoString(item.pubDate));
		writef("\tguid: %s\n", ZtoString(item.guid));
		writef("\tguid_isPermaLink: %s\n", item.guid_isPermaLink);
		writef("\tsource: %s\n", ZtoString(item.source));
		writef("\tsource_url: %s\n", ZtoString(item.source_url));
		writef("\tenclosure: %s\n", ZtoString(item.enclosure));
		writef("\tenclosure_url: %s\n", ZtoString(item.enclosure_url));
		writef("\tenclosure_length: %s\n", item.enclosure_length);
		writef("\tenclosure_type: %s\n", ZtoString(item.enclosure_type));

		writef("\tCategory:\n");
		category = item.category;
		while (category)
		{
			writef("\t\tcategory: %s\n", category.category);
			writef("\t\tcategory_domain: %s\n", category.domain);
			category = category.next;
		}

		if (item.other_tags)
			print_tags (item.other_tags, 1);

		writef("\n");
		item = item.next;
	}
	mrss_free (data);
	return 0;
}

string repeatchar(char c,int i)
{
	return to!string(c.repeat(i));
}
void print_tags (mrss_tag_t * tag, int index)
{
	mrss_attribute_t *attribute;
	int i;
	writef('\t'.repeatchar(index));
	writef("Other Tags:\n");
	while (tag)
	{
		writef('\t'.repeatchar(index));
		writef("\ttag name: %s\n", ZtoString(tag.name));
		writef('\t'.repeatchar(index));
		writef("\ttag value: %s\n", ZtoString(tag.value));
		writef('\t'.repeatchar(index));
		writef("\ttag ns: %s\n", ZtoString(tag.ns));

		if (tag.children)
			print_tags(tag.children, index + 1);

		for(attribute = tag.attributes; attribute; attribute = attribute.next)
		{
			writef('\t'.repeatchar(index));
			writef("\tattribute name: %s\n", ZtoString(attribute.name));
			writef('\t'.repeatchar(index));
			writef("\tattribute value: %s\n", ZtoString(attribute.value));
			writef('\t'.repeatchar(index));
			writef("\tattribute ns: %s\n", ZtoString(attribute.ns));
		}
		tag = tag.next;
	}
}
