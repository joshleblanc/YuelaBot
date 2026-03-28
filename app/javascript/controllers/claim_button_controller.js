import ApplicationController from './application_controller';

export default class extends ApplicationController {

  claim(e) {
    if(window.confirm(this.data.get("confirm"))) {
      const form = e.target.closest('form');
      if (form) {
        form.requestSubmit();
      } else {
        Turbo.visit(e.target.href || e.target.closest('a').href);
      }
    }
  }
}
