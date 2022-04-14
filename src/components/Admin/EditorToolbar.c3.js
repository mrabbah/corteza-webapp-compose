// eslint-disable-next-line
import { default as component } from './EditorToolbar.vue'
import { components } from '@cortezaproject/corteza-vue'
const { checkbox } = components.C3.controls
// const { click } = components.C3.events

const props = {
  backLink: {},
  hideDelete: false,
  hideSave: false,
  disableSave: false,
}

export default {
  name: 'Editor toolbar',
  group: ['Admin'],
  component,
  props,

  controls: [
    checkbox('Hide delete', 'hideDelete'),
    checkbox('Hide save', 'hideSave'),
    checkbox('Disable save', 'disableSave'),
  ],

  events: {
    // click () {

    // },
    // onCheck () {

    // },
    // onClick () {

    // },
  },
}
