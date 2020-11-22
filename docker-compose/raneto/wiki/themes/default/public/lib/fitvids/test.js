
require('tap-dev-tool/register')

var fitvids = require('./')
var test = require('tape')

test('injects styles', function (t) {
	fitvids()

	var styles = document.getElementById('fit-vids-style')

	t.ok(styles.innerHTML, 'has content')
	t.equal(styles.parentNode, document.head, 'added to head')
	t.end()
})

test('wraps videos in fluid wrapper', function (t) {
	var video = player('https://www.youtube.com/embed/Bfk83WZcAI4')
	video.width = 560
	video.height = 315

	fitvids()

	var wrapper = document.querySelector('.fluid-width-video-wrapper')

	t.equal(wrapper.style.paddingTop, '56.25%', 'aspect ratio preserved')
	t.equal(video.src, 'https://www.youtube.com/embed/Bfk83WZcAI4', 'source doesn\'t change')
	t.equal(video.parentNode.className, 'fluid-width-video-wrapper', 'wrapped in fluid container')
	document.body.removeChild(wrapper)
	t.end()
})

test('wraps all default selectors', function (t) {
	var defaults = [
		player('https://www.youtube.com/embed/Bfk83WZcAI4'),
		player('http://player.vimeo.com/video/118801020'),
		player('https://www.kickstarter.com/projects/181236819/no-2-story-of-the-pencil-documentary/widget/video.html')
	]

	var extra = player('http://localhost/')

	fitvids()

	defaults.forEach(function (video) {
		t.equal(video.parentNode.className, 'fluid-width-video-wrapper', 'wrapped in fluid container')
		document.body.removeChild(video.parentNode)
	})

	t.notEqual(extra.parentNode.className, 'fluid-width-video-wrapper', 'didn\'t wrap unknown video selector')
	document.body.removeChild(extra)
	t.end()
})

test('allows custom players', function (t) {
	var video = player('http://www.dailymotion.com/embed/video/x1wt7d1')

	fitvids({
		players: ['iframe[src*="dailymotion"]']
	})

	t.equal(video.parentNode.className, 'fluid-width-video-wrapper', 'wrapped in fluid container')
	document.body.removeChild(video.parentNode)
	t.end()
})

test('allows ignoring default selectors', function (t) {
	var video = player('http://player.vimeo.com/video/118801020')

	fitvids({
		ignore: ['iframe[src*="player.vimeo.com"]']
	})

	t.equal(video.parentNode.tagName, 'BODY', 'not wrapped in container')
	document.body.removeChild(video)
	t.end()
})

test('allows ignored and custom players at the same time', function (t) {
	var vimeo = player('http://player.vimeo.com/video/118801020')
	var youtube = player('https://www.youtube.com/embed/Bfk83WZcAI4')
	var dailymotion = player('http://www.dailymotion.com/embed/video/x1wt7d1')

	fitvids({
		players: ['iframe[src*="dailymotion.com"]'],
		ignore: ['iframe[src*="player.vimeo.com"],iframe[src*="youtube.com"]']
	})

	t.equal(vimeo.parentNode.tagName, 'BODY', 'ignored not wrapped in container')
	t.equal(youtube.parentNode.tagName, 'BODY', 'ignored not wrapped in container')
	t.equal(dailymotion.parentNode.tagName, 'DIV', 'custom is wrapped in container')
	document.body.removeChild(vimeo)
	document.body.removeChild(youtube)
	document.body.removeChild(dailymotion.parentNode)
	t.end()
})

test('doesn\'t wrap videos multiple times', function (t) {
	var video = player('http://player.vimeo.com/video/118801020')
	fitvids()
	fitvids()
	t.equal(video.parentNode.className, 'fluid-width-video-wrapper', 'wrapped in fluid container')
	t.equal(video.parentNode.parentNode.tagName, 'BODY', 'not wrapped twice')
	document.body.removeChild(video.parentNode)
	t.end()
})

/**
 * Generate a video embed from a source url
 */
function player (src) {
	var el = document.createElement('iframe')
	el.src = src
	document.body.appendChild(el)
	return el
}
