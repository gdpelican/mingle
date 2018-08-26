import { ajax } from 'discourse/lib/ajax'

export default Ember.Controller.extend({
  actions: {
    reschedule() {
      ajax('/admin/mingle/reschedule', { method: 'POST', data: {
        at: this.model.at
      }})
    }
  }
});
