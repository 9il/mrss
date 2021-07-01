/* mRss - Copyright (C) 2005-2007 bakunin - Andrea Marchesini 
 *                                    <bakunin@autistici.org>
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 * 
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 */
/**
  [mRss](http://www.autistici.org/bakunin/libmrss/doc/) is a C library for parsing, writing and creating RSS/ATOM files or streams.

  Written 2014,2015,2016,2017 by Laeeth Isharc and Kaleidic Associates Advisory Limited
  
  Authors: Laeeth Isharc and Ilya Yaroshenko
*/
module deimos.mrss;

import core.sys.posix.sys.types;
import etc.c.curl;

extern(C):
@system nothrow @nogc:

///
enum LIBMRSS_VERSION_STRING = "0.19.2";

///
enum LIBMRSS_MAJOR_VERSION = 0;
///
enum LIBMRSS_MINOR_VERSION = 19;
///
enum LIBMRSS_MICRO_VERSION = 2;

///
alias void* mrss_generic_t;

/// This enum describes the error type of libmrss
enum mrss_error_t {
  /// No error
  MRSS_OK = 0,
  /// For the correct error, use errno
  MRSS_ERR_POSIX,
  /// Parser error
  MRSS_ERR_PARSER,		
  /// Download error
  MRSS_ERR_DOWNLOAD,
  /// The RSS has incompatible version
  MRSS_ERR_VERSION,
  /// The parameters are incorrect
  MRSS_ERR_DATA
}

///
enum mrss_version_t {
  /// 0.91 RSS version
  MRSS_VERSION_0_91,
  /// 0.92 RSS version
  MRSS_VERSION_0_92,
  /// 1.0 RSS version
  MRSS_VERSION_1_0,
  /// 2.0 RSS version
  MRSS_VERSION_2_0,
  /// 0.3 Atom version
  MRSS_VERSION_ATOM_0_3,
  /// 1.0 Atom version
  MRSS_VERSION_ATOM_1_0
}

/// Flag list for mrss_set and mrss_get functions
enum mrss_flag_t {
  /**
    Generic:
  */

  /** Set the version to a mrss_t element - the value is a mrss_version_t enum */
  MRSS_FLAG_VERSION = 1,

  /** Set the title to a mrss_t element - the value is a string */
  MRSS_FLAG_TITLE,
  /** Set the title type to a mrss_t element - the value is a string (ex: text, html, ...)*/
  MRSS_FLAG_TITLE_TYPE,
  /** Set the description to a mrss_t element - the value is a string */
  MRSS_FLAG_DESCRIPTION,
  /** Set the description type to a mrss_t element - the value is a string */
  MRSS_FLAG_DESCRIPTION_TYPE,
  /** Set the link to a mrss_t element - the value is a string */
  MRSS_FLAG_LINK,
  /** Set the id to a mrss_t element - the value is a string */
  MRSS_FLAG_ID,
  /** Set the language to a mrss_t element - the value is a string */
  MRSS_FLAG_LANGUAGE,
  /** Set the rating to a mrss_t element - the value is a string */
  MRSS_FLAG_RATING,
  /** Set the copyright to a mrss_t element - the value is a string */
  MRSS_FLAG_COPYRIGHT,
  /** Set the copyright type to a mrss_t element - the value is a string */
  MRSS_FLAG_COPYRIGHT_TYPE,
  /** Set the pubDate to a mrss_t element - the value is a string */
  MRSS_FLAG_PUBDATE,
  /** Set the lastBuildDate to a mrss_t element - the value is a string */
  MRSS_FLAG_LASTBUILDDATE,
  /** Set the docs to a mrss_t element - the value is a string */
  MRSS_FLAG_DOCS,
  /** Set the managingeditor to a mrss_t element - the value is a string */
  MRSS_FLAG_MANAGINGEDITOR,
  /** Set the managingeditor's email to a mrss_t element - the value is a string */
  MRSS_FLAG_MANAGINGEDITOR_EMAIL,
  /** Set the managingeditor's uri to a mrss_t element - the value is a string */
  MRSS_FLAG_MANAGINGEDITOR_URI,
  /** Set the webMaster to a mrss_t element - the value is a string */
  MRSS_FLAG_WEBMASTER,
  /** Set the generator to a mrss_t element - the value is a string */
  MRSS_FLAG_TTL,
  /** Set the about to a mrss_t element - the value is a string */
  MRSS_FLAG_ABOUT,

  /**
    Contributor:
  */

  /** Set the contributor to a mrss_t element - the value is a string */
  MRSS_FLAG_CONTRIBUTOR,
  /** Set the contributor's email to a mrss_t element - the value is a string */
  MRSS_FLAG_CONTRIBUTOR_EMAIL,
  /** Set the contributor's uri to a mrss_t element - the value is a string */
  MRSS_FLAG_CONTRIBUTOR_URI,

  /**
    Generator:
  */

  /** Set the generator to a mrss_t element - the value is a string */
  MRSS_FLAG_GENERATOR,
  /** Set the generator's email to a mrss_t element - the value is a string */
  MRSS_FLAG_GENERATOR_URI,
  /** Set the generator's uri to a mrss_t element - the value is a string */
  MRSS_FLAG_GENERATOR_VERSION,

  /**
    Image:
  */

  /** Set the image_title to a mrss_t element - the value is a string */
  MRSS_FLAG_IMAGE_TITLE,
  /** Set the image_url to a mrss_t element - the value is a string */
  MRSS_FLAG_IMAGE_URL,
  /** Set the image_logo to a mrss_t element - the value is a string */
  MRSS_FLAG_IMAGE_LOGO,
  /** Set the image_link to a mrss_t element - the value is a string */
  MRSS_FLAG_IMAGE_LINK,
  /** Set the image_width to a mrss_t element - the value is a integer */
  MRSS_FLAG_IMAGE_WIDTH,
  /** Set the image_height to a mrss_t element - the value is a integer */
  MRSS_FLAG_IMAGE_HEIGHT,
  /** Set the image_description to a mrss_t element - the value is a string */
  MRSS_FLAG_IMAGE_DESCRIPTION,

  /**
    TextInput:
  */

  /** Set the textinput_title to a mrss_t element - the value is a string */
  MRSS_FLAG_TEXTINPUT_TITLE,
  /** Set the textinput_description to a mrss_t element - the value is a string */
  MRSS_FLAG_TEXTINPUT_DESCRIPTION,
  /** Set the textinput_name to a mrss_t element - the value is a string */
  MRSS_FLAG_TEXTINPUT_NAME,
  /** Set the textinput_link to a mrss_t element - the value is a string */
  MRSS_FLAG_TEXTINPUT_LINK,


  /**
    Cloud:
  */

  /** Set the cloud to a mrss_t element - the value is a string */
  MRSS_FLAG_CLOUD,
  /** Set the cloud_domain to a mrss_t element - the value is a string */
  MRSS_FLAG_CLOUD_DOMAIN,
  /** Set the cloud_port to a mrss_t element - the value is a string */
  MRSS_FLAG_CLOUD_PORT,
  /** Set the cloud_path to a mrss_t element - the value is a integer */
  MRSS_FLAG_CLOUD_PATH,
  /** Set the cloud_registerProcedure to a mrss_t element - 
   * the value is a string */
  MRSS_FLAG_CLOUD_REGISTERPROCEDURE,
  /** Set the cloud_protocol to a mrss_t element - the value is a string */
  MRSS_FLAG_CLOUD_PROTOCOL,

  /* SkipHours */

  /** Set the hour to a mrss_hour_t element - the value is a string */
  MRSS_FLAG_HOUR,

  /* SkipDays */

  /** Set the day to a mrss_day_t element - the value is a string */
  MRSS_FLAG_DAY,

  /* Category or Item/Category */

  /** Set the category to a mrss_category_t element - the value is a string */
  MRSS_FLAG_CATEGORY,
  /** Set the domain to a mrss_category_t element - the value is a string */
  MRSS_FLAG_CATEGORY_DOMAIN,
  /** Set the label to a mrss_category_t element - the value is a string */
  MRSS_FLAG_CATEGORY_LABEL,

  /* Item */

  /** Set the title to a mrss_item_t element - the value is a string */
  MRSS_FLAG_ITEM_TITLE,
  /** Set the title type to a mrss_item_t element - the value is a string */
  MRSS_FLAG_ITEM_TITLE_TYPE,
  /** Set the link to a mrss_item_t element - the value is a string */
  MRSS_FLAG_ITEM_LINK,
  /** Set the description to a mrss_item_t element - the value is a string */
  MRSS_FLAG_ITEM_DESCRIPTION,
  /** Set the description type to a mrss_item_t element - the value is a string */
  MRSS_FLAG_ITEM_DESCRIPTION_TYPE,
  /** Set the copyright to a mrss_item_t element - the value is a string */
  MRSS_FLAG_ITEM_COPYRIGHT,
  /** Set the copyright type to a mrss_item_t element - the value is a string */
  MRSS_FLAG_ITEM_COPYRIGHT_TYPE,

  /** Set the author to a mrss_item_t element - the value is a string */
  MRSS_FLAG_ITEM_AUTHOR,
  /** Set the author's uri to a mrss_item_t element - the value is a string */
  MRSS_FLAG_ITEM_AUTHOR_URI,
  /** Set the author's email to a mrss_item_t element - the value is a string */
  MRSS_FLAG_ITEM_AUTHOR_EMAIL,

  /** Set the contributor to a mrss_item_t element - the value is a string */
  MRSS_FLAG_ITEM_CONTRIBUTOR,
  /** Set the contributor's uri to a mrss_item_t element - the value is a string */
  MRSS_FLAG_ITEM_CONTRIBUTOR_URI,
  /** Set the contributor's email to a mrss_item_t element - the value is a string */
  MRSS_FLAG_ITEM_CONTRIBUTOR_EMAIL,

  /** Set the comments to a mrss_item_t element - the value is a string */
  MRSS_FLAG_ITEM_COMMENTS,
  /** Set the pubDate to a mrss_item_t element - the value is a string */
  MRSS_FLAG_ITEM_PUBDATE,
  /** Set the guid to a mrss_item_t element - the value is a string */
  MRSS_FLAG_ITEM_GUID,
  /** Set the guid_isPermaLink to a mrss_item_t element - 
   * the value is a integer */
  MRSS_FLAG_ITEM_GUID_ISPERMALINK,
  /** Set the source to a mrss_item_t element - the value is a string */
  MRSS_FLAG_ITEM_SOURCE,
  /** Set the source_url to a mrss_item_t element - the value is a string */
  MRSS_FLAG_ITEM_SOURCE_URL,
  /** Set the enclosure to a mrss_item_t element - the value is a string */
  MRSS_FLAG_ITEM_ENCLOSURE,
  /** Set the enclosure_url to a mrss_item_t element - the value is a string */
  MRSS_FLAG_ITEM_ENCLOSURE_URL,
  /** Set the enclosure_length to a mrss_item_t element - 
   * the value is a integer */
  MRSS_FLAG_ITEM_ENCLOSURE_LENGTH,
  /** Set the enclosure_type to a mrss_item_t element - the value is a string */
  MRSS_FLAG_ITEM_ENCLOSURE_TYPE,

  /* Item */

  /** Set the name to a mrss_tag_t element - the value is a string */
  MRSS_FLAG_TAG_NAME,

  /** Set the value to a mrss_tag_t element - the value is a string */
  MRSS_FLAG_TAG_VALUE,

  /** Set the namespace to a mrss_tag_t element - the value is a string */
  MRSS_FLAG_TAG_NS,

  /** Set the name to a mrss_attribute_t element - the value is a string */
  MRSS_FLAG_ATTRIBUTE_NAME,

  /** Set the value to a mrss_attribute_t element - the value is a string */
  MRSS_FLAG_ATTRIBUTE_VALUE,

  /** Set the namespace to a mrss_attribute_t element - the value is a string */
  MRSS_FLAG_ATTRIBUTE_NS,

  /** Set the terminetor flag */
  MRSS_FLAG_END = 0

}

/**
Enum for the casting of the libmrss data struct
*/
enum mrss_element_t {
  /** The data struct is a mrss_t */
  MRSS_ELEMENT_CHANNEL,
  /** The data struct is a mrss_item_t */
  MRSS_ELEMENT_ITEM,
  /** The data struct is a mrss_hour_t */
  MRSS_ELEMENT_SKIPHOURS,
  /** The data struct is a mrss_day_t */
  MRSS_ELEMENT_SKIPDAYS,
  /** The data struct is a mrss_category_t */
  MRSS_ELEMENT_CATEGORY,
  /** The data struct is a mrss_tag_t */
  MRSS_ELEMENT_TAG,
  /** The data struct is a mrss_attribute_t */
  MRSS_ELEMENT_ATTRIBUTE
}

/**
Data struct for any items of RSS. It contains a pointer to the list
of categories. 
*/
struct mrss_item_t {

  /** For internal use only: */
  mrss_element_t element;
  int allocated;

  /* Data: */

  				/* 0.91	0.92	1.0	2.0	ATOM	*/
  char* title;			/* R	O	O	O	R	*/
  char* title_type;		/* -	-	-	-	O	*/
  char* link;			/* R	O	O	O	O	*/
  char* description;		/* R	O	-	O	O	*/
  char* description_type;	/* -	-	-	-	0	*/
  char* copyright;		/* -	-	-	-	O	*/
  char* copyright_type;		/* -	-	-	-	O	*/
  
  char* author;			/* -	-	-	O	O	*/
  char* author_uri;		/* -	-	-	-	O	*/
  char* author_email;		/* -	-	-	-	O	*/

  char* contributor;		/* -	-	-	-	O	*/
  char* contributor_uri;	/* -	-	-	-	O	*/
  char* contributor_email;	/* -	-	-	-	O	*/

  char* comments;		/* -	-	-	O	-	*/
  char* pubDate;		/* -	-	-	O	O	*/
  char* guid;			/* -	-	-	O	O	*/
  int guid_isPermaLink;		/* -	-	-	O	-	*/

  char* source;			/* -	O	-	O	-	*/
  char* source_url;		/* -	R	-	R	-	*/

  char* enclosure;		/* -	O	-	O	-	*/
  char* enclosure_url;		/* -	R	-	R	-	*/
  int enclosure_length;		/* -	R	-	R	-	*/
  char* enclosure_type;		/* -	R	-	R	-	*/

  mrss_category_t* category;	/* -	O	-	O	O	*/

  mrss_tag_t* other_tags;

  mrss_item_t* next;
}

/**
Data struct for skipHours elements. 
*/
struct mrss_hour_t {
  /** For internal use only: */
  mrss_element_t element;
  int allocated;

  /* Data: */
  				/* 0.91	0.92	1.0	2.0	ATOM	*/
  char* hour;			/* R	R	-	R	-	*/
  mrss_hour_t* next;
}

/**
Data struct for skipDays elements. 
*/
struct mrss_day_t {
  /** For internal use only: */
  mrss_element_t element;
  int allocated;

  /* Data: */
  				/* 0.91	0.92	1.0	2.0	ATOM	*/
  char* day;			/* R	R	-	R	-	*/
  mrss_day_t* next;
}

/**
Data struct for category elements
*/
 struct mrss_category_t {
  /** For internal use only: */
  mrss_element_t element;
  int allocated;

  /* Data: */
  				/* 0.91	0.92	1.0	2.0	ATOM	*/
  char* category;		/* -	R	-	R	R	*/
  char* domain;			/* -	O	-	O	O	*/
  char* label;			/* -	-	-	-	O	*/
  mrss_category_t* next;
}

/**
  Principal data struct. It contains pointers to any other structures.
*/
struct mrss_t {
  /** For internal use only: */
  mrss_element_t element;
  int allocated;
  int curl_error;

  /* Data: */

  char* file;
  size_t size;
  char* encoding;

  mrss_version_t version_;	/* 0.91	0.92	1.0	2.0	ATOM	*/

  char* title;			/* R	R	R	R	R	*/
  char* title_type;		/* -	-	-	-	O	*/
  char* description;		/* R	R	R	R	R	*/
  char* description_type;	/* -	-	-	-	O	*/
  char* link;			/* R	R	R	R	O	*/
  char* id;			/* 	-	-	-	-	O	*/
  char* language;		/* R	O	-	O	O	*/
  char* rating;			/* O	O	-	O	-	*/
  char* copyright;		/* O	O	-	O	O	*/
  char* copyright_type;		/* -	-	-	-	O	*/
  char* pubDate;		/* O	O	-	O	-	*/
  char* lastBuildDate;		/* O	O	-	O	O	*/
  char* docs;			/* O	O	-	O	-	*/
  char* managingeditor;		/* O	O	-	O	O	*/
  char* managingeditor_email;	/* O	O	-	O	O	*/
  char* managingeditor_uri;	/* O	O	-	O	O	*/
  char* webMaster;		/* O	O	-	O	-	*/
  int ttl;			/* -	-	-	O	-	*/
  char* about;			/* -	-	R	-	-	*/
  
  /// Contributor:		/* -	-	-	-	O	*/
  char* contributor;		/* -	-	-	-	R	*/
  char* contributor_email;	/* -	-	-	-	O	*/
  char* contributor_uri;	/* -	-	-	-	O	*/

  /// Generator:
  char* generator;		/* -	-	-	O	O	*/
  char* generator_uri;		/* -	-	-	-	O	*/
  char* generator_version;	/* -	-	-	-	O	*/

  /// Tag Image:		/* O	O	O	O	-	*/
  char* image_title;		/* R	R	R	R	-	*/
  char* image_url;		/* R	R	R	R	O	*/
  char* image_logo;		/* -	-	-	-	O	*/
  char* image_link;		/* R	R	R	R	-	*/
  uint image_width;	/* O	O	-	O	-	*/
  uint image_height;	/* O	O	-	O	-	*/
  char* image_description;	/* O	O	-	O	-	*/

  /// TextInput: 		/* O	O	O	O	-	*/
  char* textinput_title;	/* R	R	R	R	-	*/
  char* textinput_description;	/* R	R	R	R	-	*/
  char* textinput_name;		/* R	R	R	R	-	*/
  char* textinput_link;		/* R	R	R	R	-	*/

  /// Cloud:
  char* cloud;			/* -	O	-	O	-	*/
  char* cloud_domain;		/* -	R	-	R	-	*/
  int cloud_port;		/* -	R	-	R	-	*/
  char* cloud_path;		/* -	R	-	R	-	*/
  char* cloud_registerProcedure;/* -	R	-	R	-	*/
  char* cloud_protocol;		/* -	R	-	R	-	*/

  mrss_hour_t* skipHours;	/* O	O	-	O	-	*/
  mrss_day_t* skipDays;		/* O	O	-	O	-	*/

  mrss_category_t* category;	/* -	O	-	O	O	*/

  mrss_item_t* item;		/* R	R	R	R	R	*/

  mrss_tag_t* other_tags;

  version (MRSS_USE_LOCALE)
    void* c_locale;
}

/**
Data struct for any other tag out of the RSS namespace.
Struct data for external tags
*/
struct mrss_tag_t {
  /** For internal use only: */
  mrss_element_t element;
  int allocated;

  /// name of the tag
  char* name;

  char* value;

  /// namespace
  char* ns;

  /// list of attributes
  mrss_attribute_t* attributes;

  /// Sub tags
  mrss_tag_t* children;

  /// the next tag
  mrss_tag_t* next;
}

/**
Data struct for the attributes of the tag
Struct data for external attribute
*/
struct mrss_attribute_t {
  /// For internal use only
  mrss_element_t element;
  int allocated;

  /// name of the tag
  char* name;

  /// value
  char* value;

  /// namespace
  char* ns;
  
  /// The next attribute
  mrss_attribute_t* next;
}

/**
Options data struct. It contains some user preferences.
*/
struct mrss_options_t {
  int timeout;
  char* proxy;
  char* proxy_authentication;
  char* certfile;
  char* cacert;
  char* password;
  int verifypeer;
  char* authentication;
  char* user_agent;
}

/**
  Parse Functions:
*/

/**
Parses a url and creates the data struct of the feed RSS url.
This function downloads your request if this is http or ftp.
Params:
  url = The url to be parsed
  mrss = the pointer to your data struct
Returns:
  the error code
*/
mrss_error_t	mrss_parse_url		(char* 		url,
					 mrss_t**	mrss);

/**
Parses a url and creates the data struct of the feed RSS url.
This function downloads your request if this is http or ftp.
with an options struct.
Params:
  url = The url to be parsed
  mrss =the pointer to your data struct
  options = a pointer to a options data struct
Returns:
  the error code
*/
mrss_error_t	mrss_parse_url_with_options
					(char* 		url,
					 mrss_t**	mrss,
					 mrss_options_t* options);

/**
Parses a url and creates the data struct of the feed RSS url.
This function downloads your request if this is http or ftp.
with an options struct and CURLcode error
Params:
  url = The url to be parsed
  mrss = the pointer to your data struct
  options = a pointer to a options data struct. It can be null
  curlcode = the error code from libcurl
Returns:
  the error code
*/
mrss_error_t	mrss_parse_url_with_options_and_error
					(char* 		url,
					 mrss_t**	mrss,
					 mrss_options_t* options,
					 CURLcode*	curlcode);

/**
Like the previous function but you take ownership of the downloaded buffer
in case of success
Params:
  url = The url to be parsed
  mrss = the pointer to your data struct
  options = a pointer to a options data struct
  curlcode = the error code from libcurl
  feed_content = a pointer to the buffer with the document. This is not null terminated
  feed_size = the size of the buffer above
Returns:
  the error code
*/
mrss_error_t	mrss_parse_url_with_options_error_and_transfer_buffer
					(char* 		url,
					 mrss_t**	mrss,
					 mrss_options_t* options,
					 CURLcode*	curlcode,
					 char**	feed_content,
					 int*		feed_size);

/** 
Parses a file and creates the data struct of the feed RSS url
Params:
  file = the file to be parsed
  mrss = the pointer to your data struct
Returns:
  the error code
*/
mrss_error_t	mrss_parse_file		(char* 		file,
					 mrss_t**	mrss);

/** 
  Parses a buffer and creates the data struct of the feed RSS url
  Params:
    buffer = Pointer to the xml memory stream to be parsed
    size_buffer = The size of the array of char
    mrss = the pointer to your data struct
  Returns:
    the error code
*/
mrss_error_t	mrss_parse_buffer	(char* 		buffer,
					 size_t		size_buffer,
					 mrss_t**	mrss);

/**
  Write Functions:
*/

/** 
Writes a RSS struct data in a local file
Params:
  mrss = the rss struct data
  file = the local file
Returns:
  the error code
*/
mrss_error_t	mrss_write_file		(mrss_t*	mrss,
					 char* 		file);

/**
 Write a RSS struct data in a buffer.

`
  char* buffer;
  buffer=null; //<--- This is important!!
  mrss_write_buffer (mrss, &buffer);
`
The buffer must be null.

Params:
  mrss = the rss struct data
  buffer = the buffer
Returns:
  the error code
*/
mrss_error_t	mrss_write_buffer	(mrss_t *	mrss,
					 char**	buffer);

/**
Free Function:
*/

/** 
Frees any type of data struct of libmrss. If the element is alloced by libmrss, it will be freed, else this function frees
only the internal data.
`
  mrss_t *t=....;
  mrss_item_t *item=...;

  mrss_free(t);
  mrss_free(item);
`
Params:
  element = the data struct
Returns:
  the error code
*/
mrss_error_t	mrss_free		(mrss_generic_t	element);

/**
Generic Functions:
*/

/** 
  This function returns a static string with the description of error code
  Params:
    err = the error code that you need as string
  Returns:
    a string. Don't free this string!
*/
char* 		mrss_strerror		(mrss_error_t	err);

/** 
This function returns a static string with the description of curl code
Params:
  err = the error code that you need as string
Returns:
  a string. Don't free this string!
*/
char* 		mrss_curl_strerror	(CURLcode	err);

/**
  Returns the mrss_element_t of a mrss data struct.
  Params:
    element = it is the element that you want check
    ret = pointer to a mrss_element_t. It will be sets.
  Returns:
    the error code
*/
mrss_error_t	mrss_element		(mrss_generic_t	element,
					 mrss_element_t* ret);

/**
  Returns the number of seconds sinze January 1st 1970 in the
  UTC time zone, for the url that the urlstring parameter specifies.
 
  Params:
    urlstring = the url
    lastmodified = pointer to a time_t struct. The return value can
    be 0 if the HEAD request does not return a Last-Modified value.
 
  Returns:
    the error code
*/
mrss_error_t	mrss_get_last_modified	(char* 		urlstring,
					 time_t*	lastmodified);

/**
  Returns the number of seconds sinze January 1st 1970 in the
  UTC time zone, for the url that the urlstring parameter specifies.
  With options struct

  Params:
    urlstring = the url
    lastmodified = pointer to a time_t struct. The return value can
    be 0 if the HEAD request does not return a Last-Modified value.
    options = a pointer to a options struct
  Returns:
    the error code
 */
mrss_error_t	mrss_get_last_modified_with_options
					(char* 		urlstring,
					 time_t* 	lastmodified,
					 mrss_options_t* options);
/**
  Returns the number of seconds sinze January 1st 1970 in the
  UTC time zone, for the url that the urlstring parameter specifies.
  With options struct and CURLcode pointer.
 
 Params:
  urlstring = the url
  lastmodified = pointer to a time_t struct. The return value can
  be 0 if the HEAD request does not return a Last-Modified value.
  options = a pointer to a options struct
  curl_code = error code of libcurl
 Returns:
  the error code
*/
mrss_error_t	mrss_get_last_modified_with_options_and_error
					(char* 		urlstring,
					 time_t* 	lastmodified,
					 mrss_options_t* options,
					 CURLcode*	curl_code);

/**
  Edit Functions:
*/

/**
  To create a new feed RSS from scratch, use this function as the first.

  `
    mrss_t *d;
    mrss_error_t err;
    char* string;
    int integer;

    d=null; // ->this is important! If d!=null, mrss_new doesn't alloc memory.
    mrss_new(&d);

    err=mrss_set (d,
    		 MRSS_FLAG_VERSION, MRSS_VERSION_0_92,
    		 MRSS_FLAG_TITLE, "the title!",
    		 MRSS_FLAG_TTL, 12,
    		 MRSS_FLAG_END);

    if(err!=MRSS_OK) printf("%s\n",mrss_strerror(err));

    err=mrss_get (d, MRSS_FLAG_TITLE, &string, MRSS_FLAG_TTL, &integer, MRSS_FLAG_END);

    if(err!=MRSS_OK) printf("%s\n",mrss_strerror(err));
    printf("The title is: '%s'\n", string);
    printf("The ttl is: '%d'\n", integer);
    free(string);
  `
  Params:
    mrss = pointer to the new data struct
  Returns:
    the error code
*/
mrss_error_t	mrss_new		(mrss_t**	mrss);

/**
For insert/replace/remove a flags use this function as this example:
`
  mrss_set(mrss, MRSS_FLAG_TITLE, "hello world", MRSS_FLAG_END);
  mrss_set(item, MRSS_FLAG_DESCRIPTION, null, MRSS_FLAG_END);
`

Params:
  element = mrss data that you want changes the next list of elements. The list is composted by KEY - VALUES and as last element MRSS_FLAG_END.
  The variable of value depends from key.
Returns:
  the error code
*/
mrss_error_t	mrss_set		(mrss_generic_t	element,
					 ...);

/**
  returns the request arguments. The syntax is the same of mrss_set but the values of the list are
  pointer to data element (int *, * char* *). If the key needs a char* *, the value will be allocated.

  `
    mrss_get(category, MRSS_FLAG_CATEGORY_DOMAIN, &string, MRSS_FLAG_END);
    if(string) free(string);
  `
  Params:
    element = any type of mrss data struct
  Returns:
    the error code
*/
mrss_error_t	mrss_get		(mrss_generic_t	element,
					 ...);

/**
  adds an element to another element. For example: add a item to a channel, or a category to a item, and so on.
  Example:
    `
      mrss_item_t *item = null;
      mrss_hour_t *hour = null;
      mrss_day_t day;              // If the element is no null, the function
      mrss_category_t category,    // does not alloc it

      mrss_new_subdata(mrss, MRSS_ELEMENT_ITEM, &item);
      mrss_new_subdata(mrss, MRSS_ELEMENT_SKIPHOURS, &hour);
      mrss_new_subdata(mrss, MRSS_ELEMENT_SKIPDAYS, &day);
      mrss_new_subdata(item, MRSS_ELEMENT_ITEM_CATEGORY, &category);
    `

  Params:
    element = parent element
    subelement = type of the child (MRSS_ELEMENT_ITEM, MRSS_ELEMENT_CATEGORY, ...)
    subdata =  pointer to the new struct. If the pointer of *subdata does not exist it will be allocated otherwise not
  Returns:
    the error code
*/
mrss_error_t	mrss_new_subdata	(mrss_generic_t	element,
					 mrss_element_t	subelement,
					 mrss_generic_t	subdata);

/**
  Removes a subdata element.
  Params:
    element = parent
    subdata = child to remove
  Does not free the memory. So you can remove a item and reinsert it after.
  Returns:
    the error code
*/
mrss_error_t	mrss_remove_subdata	(mrss_generic_t	element,
					 mrss_generic_t	subdata);

/**
Tags Functions:
*/

/**
  Search a tag in a mrss_t, a mrss_item_t or a mrss_tag_t from name and a namespace.
  Params:
    element = it is the parent node (mrss_t or mrss_item_t)
    name = the name of the element
    ns = the namespace. It can be null if the tag has a null namespace
    tag = the return pointer
  Returns:
    the error code
*/
mrss_error_t	mrss_search_tag		(mrss_generic_t	element,
					 char* 		name,
					 char* 		ns,
					 mrss_tag_t**	tag);

/**
  This function searches an attribute from a mrss_tag_t, a name and a namespace
  Params:
    element = it is the mrss_tag_t
    name = the name of the element
    ns = the namespace. It can be null if the tag has a null namespace
    attribute = the return pointer
  Returns:
    the error code
 */
mrss_error_t	mrss_search_attribute	(mrss_generic_t	element,
					 char* 		name,
					 char* 		ns,
					 mrss_attribute_t** attribute);

/**
  OPTIONS FUNCTIONS:
*/

/**
  This function creates a options struct.
  
    Params:
      timeout = timeout for the download procedure
      proxy = a proxy server. can be null
      proxy_authentication = a proxy authentication (user:pwd). can be null
      certfile = a certificate for ssl authentication connection
      password = the password of certfile
      cacert = CA certificate to verify peer against. can be null
      verifypeer = active/deactive the peer check
      authentication = an authentication login (user:pwd). can be null
      user_agent = a user_agent. can be null
 
    Returns:
      a pointer to a new allocated mrss_options_t struct 
 */
mrss_options_t *
		mrss_options_new	(int timeout,
					 char* proxy,
					 char* proxy_authentication,
					 char* certfile,
					 char* password,
					 char* cacert,
					 int verifypeer,
					 char* authentication,
					 char* user_agent);

/**
  This function destroys a options struct.
  Params:
    options =  a pointer to a options struct
*/
void		mrss_options_free	(mrss_options_t* options);
