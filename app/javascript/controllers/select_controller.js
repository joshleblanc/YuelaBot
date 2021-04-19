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

  search = (search, callback) =>
    this.stimulate(this.reflexValue, search).then(() => callback(false))

  results = event => this.select.setData(event.detail.options)

  onChange = () => {
    if (!this.select.data.searchValue) return
    if (this.select.selected() === undefined)
      this.stimulate(this.reflexValue, '')
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
