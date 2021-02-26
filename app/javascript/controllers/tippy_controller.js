import ApplicationController from './application_controller';
import tippy from 'tippy.js';

export default class extends ApplicationController {
  connect() {
    tippy(this.element);
  }

  disconnect() {
    this.element._tippy.destroy();
  }
}
