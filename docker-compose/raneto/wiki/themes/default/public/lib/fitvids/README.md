# fitvids

Lets your videos be responsive by keeping an [intrinsic aspect ratio](http://alistapart.com/article/creating-intrinsic-ratios-for-video).

This module is based heavily off of Dave Rupert's [FitVids jQuery plugin](https://github.com/davatron5000/FitVids.js).

## Install

```bash
npm install fitvids --save
```

You can also [download the files manually](https://raw.githubusercontent.com/rosszurowski/vanilla-fitvids/master/fitvids.min.js) and include them via a `<script>` tag.

## Usage

```javascript
fitvids() // Bam, done.
```

The module exports a single function. Just call it, and it'll wrap all your videos. By default it applies to video embeds from the following sites.

Player        | Default?
--------------|-----------
YouTube       | ✓
Vimeo         | ✓
Kickstarter   | ✓

_Other video players can be supported by passing a custom selector via [the options](#custom-players)_

## Options

#### Custom Selector

If you'd prefer to limit fitvids to a single element, you can provide an optional parent selector:

```javascript
fitvids('.video-container')
```

#### Custom Players

By default, fitvids automatically wraps Youtube, Vimeo, and Kickstarter players, but if you'd like it to wrap others too, you can pass them in as selectors via the `players` property.

```javascript
fitvids({
	players: 'iframe[src*="example.com"]'
})
```

Or several at once:

```javascript
fitvids('.video-container', {
	players: ['iframe[src*="example1.com"]', 'iframe[src*="example2.com"]']
})
```

#### Ignoring Selectors

If you'd like to ignore one of the [default selectors](#usage), you can pass a selector via the `ignore` option:

```javascript
fitvids({
	ignore: ['object']
})
```

### Browser Support

This module uses `document.querySelector` which is supported in newer browsers. According to [Can I Use](http://caniuse.com/#feat=queryselector), `querySelector` has a 94.61% global support rate, so it should be safe for most people.

* Chrome 4+
* Firefox 2+
* IE 9+
* Safari 3.1+
* Safari Mobile 3.2+

### License

[WTFPL](http://www.wtfpl.net)
