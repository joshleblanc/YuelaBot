import ApplicationController from './application_controller';

export default class extends ApplicationController {

  claim(e) {
    if(window.confirm(this.data.get("confirm"))) {
      this.stimulate("GameKey#claim", e.target)
    }
  }
}
