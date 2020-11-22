import { isVisible } from '../utils/dom/domUtils.js'
import { getInputValue } from '../utils/dom/inputUtils.js'
import { getValidationMessage } from '../utils/dom/getters.js'
import { showLoading } from '../staticMethods/showLoading.js'
import { DismissReason } from '../utils/DismissReason.js'

export const handleConfirmButtonClick = (instance, innerParams) => {
  instance.disableButtons()
  if (innerParams.input) {
    handleConfirmWithInput(instance, innerParams)
  } else {
    confirm(instance, innerParams, true)
  }
}

export const handleCancelButtonClick = (instance, dismissWith) => {
  instance.disableButtons()
  dismissWith(DismissReason.cancel)
}

const handleConfirmWithInput = (instance, innerParams) => {
  const inputValue = getInputValue(instance, innerParams)

  if (innerParams.inputValidator) {
    instance.disableInput()
    const validationPromise = Promise.resolve().then(() => innerParams.inputValidator(inputValue, innerParams.validationMessage))
    validationPromise.then(
      (validationMessage) => {
        instance.enableButtons()
        instance.enableInput()
        if (validationMessage) {
          instance.showValidationMessage(validationMessage)
        } else {
          confirm(instance, innerParams, inputValue)
        }
      }
    )
  } else if (!instance.getInput().checkValidity()) {
    instance.enableButtons()
    instance.showValidationMessage(innerParams.validationMessage)
  } else {
    confirm(instance, innerParams, inputValue)
  }
}

const succeedWith = (instance, value) => {
  instance.closePopup({ value })
}

const confirm = (instance, innerParams, value) => {
  if (innerParams.showLoaderOnConfirm) {
    showLoading() // TODO: make showLoading an *instance* method
  }

  if (innerParams.preConfirm) {
    instance.resetValidationMessage()
    const preConfirmPromise = Promise.resolve().then(() => innerParams.preConfirm(value, innerParams.validationMessage))
    preConfirmPromise.then(
      (preConfirmValue) => {
        if (isVisible(getValidationMessage()) || preConfirmValue === false) {
          instance.hideLoading()
        } else {
          succeedWith(instance, typeof (preConfirmValue) === 'undefined' ? value : preConfirmValue)
        }
      }
    )
  } else {
    succeedWith(instance, value)
  }
}
