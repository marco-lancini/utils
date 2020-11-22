import { swalClasses, iconTypes } from '../classes.js'
import { toArray, objectValues, warn } from '../utils.js'

// Remember state in cases where opening and handling a modal will fiddle with it.
export const states = {
  previousBodyPadding: null
}

export const hasClass = (elem, className) => {
  return elem.classList.contains(className)
}

const removeCustomClasses = (elem) => {
  toArray(elem.classList).forEach(className => {
    if (!objectValues(swalClasses).includes(className) && !objectValues(iconTypes).includes(className)) {
      elem.classList.remove(className)
    }
  })
}

export const applyCustomClass = (elem, customClass, className) => {
  removeCustomClasses(elem)

  if (customClass && customClass[className]) {
    if (typeof customClass[className] !== 'string' && !customClass[className].forEach) {
      return warn(`Invalid type of customClass.${className}! Expected string or iterable object, got "${typeof customClass[className]}"`)
    }

    addClass(elem, customClass[className])
  }
}

export function getInput (content, inputType) {
  if (!inputType) {
    return null
  }
  switch (inputType) {
    case 'select':
    case 'textarea':
    case 'file':
      return getChildByClass(content, swalClasses[inputType])
    case 'checkbox':
      return content.querySelector(`.${swalClasses.checkbox} input`)
    case 'radio':
      return content.querySelector(`.${swalClasses.radio} input:checked`) ||
        content.querySelector(`.${swalClasses.radio} input:first-child`)
    case 'range':
      return content.querySelector(`.${swalClasses.range} input`)
    default:
      return getChildByClass(content, swalClasses.input)
  }
}

export const focusInput = (input) => {
  input.focus()

  // place cursor at end of text in text input
  if (input.type !== 'file') {
    // http://stackoverflow.com/a/2345915
    const val = input.value
    input.value = ''
    input.value = val
  }
}

export const toggleClass = (target, classList, condition) => {
  if (!target || !classList) {
    return
  }
  if (typeof classList === 'string') {
    classList = classList.split(/\s+/).filter(Boolean)
  }
  classList.forEach((className) => {
    if (target.forEach) {
      target.forEach((elem) => {
        condition ? elem.classList.add(className) : elem.classList.remove(className)
      })
    } else {
      condition ? target.classList.add(className) : target.classList.remove(className)
    }
  })
}

export const addClass = (target, classList) => {
  toggleClass(target, classList, true)
}

export const removeClass = (target, classList) => {
  toggleClass(target, classList, false)
}

export const getChildByClass = (elem, className) => {
  for (let i = 0; i < elem.childNodes.length; i++) {
    if (hasClass(elem.childNodes[i], className)) {
      return elem.childNodes[i]
    }
  }
}

export const applyNumericalStyle = (elem, property, value) => {
  if (value || parseInt(value) === 0) {
    elem.style[property] = (typeof value === 'number') ? value + 'px' : value
  } else {
    elem.style.removeProperty(property)
  }
}

export const show = (elem, display = 'flex') => {
  elem.style.opacity = ''
  elem.style.display = display
}

export const hide = (elem) => {
  elem.style.opacity = ''
  elem.style.display = 'none'
}

export const toggle = (elem, condition, display) => {
  condition ? show(elem, display) : hide(elem)
}

// borrowed from jquery $(elem).is(':visible') implementation
export const isVisible = (elem) => !!(elem && (elem.offsetWidth || elem.offsetHeight || elem.getClientRects().length))

export const isScrollable = (elem) => !!(elem.scrollHeight > elem.clientHeight)

// borrowed from https://stackoverflow.com/a/46352119
export const hasCssAnimation = (elem) => {
  const style = window.getComputedStyle(elem)

  const animDuration = parseFloat(style.getPropertyValue('animation-duration') || '0')
  const transDuration = parseFloat(style.getPropertyValue('transition-duration') || '0')

  return animDuration > 0 || transDuration > 0
}

export const contains = (haystack, needle) => {
  if (typeof haystack.contains === 'function') {
    return haystack.contains(needle)
  }
}
