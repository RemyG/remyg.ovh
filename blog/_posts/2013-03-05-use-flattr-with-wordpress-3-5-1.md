---
title: Use Flattr with WordPress 3.5.1
date: 2013-03-05T18:00:10+00:00
author: RemyG
layout: rg-post
categories: Web
tags:
  - Flattr
  - PHP
  - Wordpress
deprecated: true
---

[Flattr](http://flattr.com/) is a "social micro-payment system", that allows you to make online payments, when you like an article, a blog, a project...

I've decided to add it to my personnal websites, both the [Jekyll site](http://remyg.fr) and my [Wordpress blog](http://blog.remyg.fr).

<!--more-->

Looking at the *Flattr documentation*, the basic solution for Wordpress.org blogs (hosted blogs) is to use the [Flattr plugin](https://wordpress.org/extend/plugins/flattr/). But the current version of the plugin (1.2.0) doesn't work with Wordpress 3.5.1. The Flattr button simply isn't displayed.

So I've had to find an alternate solution, which was to simply create a Wordpress function in my theme, and to call this function each time I want to add a Flattr button.

I've based my code on [this post](http://wpengineer.com/2022/flattr-button-4-wordpress-without-a-plugin/), but I've simplified it, as I didn't need customization like multi-user handling.

So the final function, as used on my blog, is:

```
function fb_flattr_link($uid = 'ramy', $cat = 'text', $btn = 'compact') {

	$cat = htmlspecialchars($cat);
	$btn = htmlspecialchars($btn);

	$ftag = '';
	$tags = get_the_tags( get_the_ID() );
	if ( $tags ) {
		foreach( $tags as $tag ) {
			$ftag .= $tag->name . ', ';
		}
		$ftag = substr( $ftag, 0, -2 );
	} else {
		$tag = '';
	}

	$dsc = htmlspecialchars( strip_tags( trim( get_the_excerpt() ) ) );
	$dsc = str_replace( "'", "", $dsc );
	$dsc = str_replace( "\n", " ", $dsc ); // maybe \r\n
	$dsc = substr($dsc, 0, 150);

	$tle = htmlspecialchars( strip_tags( get_the_title() ) );
	$tle = str_replace( "'", "", $tle );

	$flattr = '
		<span class="flattr">
			<script type="text/javascript">
				var flattr_uid = "'.$uid.'";
				var flattr_url = "' . get_permalink() . '";
				var flattr_tle = "' . $tle . '";
				var flattr_dsc = "' . $dsc . '";
				var flattr_cat = "' . $cat . '";
				var flattr_tag = "' . $ftag . '";
				var flattr_btn = "' . $btn . '";
			</script>
			<script src="http://api.flattr.com/button/load.js" type="text/javascript"></script>
		</span>
	';

	echo $flattr;

}
```

To use it, I simply use this code each time I want to add a button:

```
<?php if ( function_exists('fb_flattr_link') ) fb_flattr_link(); ?>
```
