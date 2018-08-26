import { default as computed } from 'ember-addons/ember-computed-decorators'
import { ajax } from 'discourse/lib/ajax'
import showModal from 'discourse/lib/show-modal'

export default Ember.Component.extend({
  @computed('filter')
  showButton() {
    return this.filter == 'mingle'
  },

  actions: {
    reschedule() {
      ajax('/admin/mingle/scheduled').then((data) => {
        showModal('mingle-reschedule-modal', {
          modalClass: 'mingle-modal',
          title: 'mingle.modal_title',
          model: data
        })
      })
    }
  }
})
