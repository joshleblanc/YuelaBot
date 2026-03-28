// https://gist.github.com/leastbad/bbc4a84c7c1c870b246db48b7641209e

import ApplicationController from './application_controller'
import SlimSelect from 'slim-select'

export default class extends ApplicationController {
  static values = {
    limit: Number,
    placeholder: String,
    searchText: String,
    searchingText: String,
    reflex: String
  }

  connect () {
    super.connect()
    const closeOnSelect = this.single
    const allowDeselect = !this.element.required

    this.select = new SlimSelect({
      select: this.element,
      closeOnSelect,
      allowDeselect,
      limit: this.limitValue,
      placeholder: this.hasPlaceholderValue
        ? this.placeholderValue
        : 'Select Value',
      searchText: this.hasSearchTextValue ? this.searchTextValue : 'No Results',
      searchingText: this.hasSearchingTextValue
        ? this.searchingTextValue
        : 'Searching...',
      ajax: this.hasReflexValue ? this.search : () => {},
      onChange: this.onChange,
      addToBody: true
    })

    if (this.hasReflexValue) document.addEventListener('data', this.results)
  }

  search = (search, callback) => {
    const url = this.buildUrl(search)
    fetch(url, {
      headers: {
        'X-Requested-With': 'XMLHttpRequest',
        'Accept': 'application/json'
      }
    })
      .then(response => response.json())
      .then(data => callback(data))
      .catch(() => callback(false))
  }

  buildUrl (search) {
    const reflex = this.reflexValue
    if (!reflex) return '/'

    // Convert "ControllerName#action" to "/controller_name/action"
    const [controller, action] = reflex.split('#')
    const controllerPath = controller.replace(/([A-Z])/g, '_$1').toLowerCase().replace(/^_/, '').replace('_controller', '')
    return `/${controllerPath}/${action}?q=${encodeURIComponent(search)}`
  }

  results = event => this.select.setData(event.detail.options)

  onChange = () => {
    if (!this.select.data.searchValue) return
    if (this.select.selected() === undefined) {
      const url = this.buildUrl('')
      fetch(url, {
        headers: {
          'X-Requested-With': 'XMLHttpRequest',
          'Accept': 'application/json'
        }
      })
    }
  }

  get single () {
    return !this.element.multiple
  }
  get multi () {
    return this.element.multiple
  }

  disconnect () {
    this.select.destroy()
    if (this.hasReflexValue) document.removeEventListener('data', this.results)
  }
}
