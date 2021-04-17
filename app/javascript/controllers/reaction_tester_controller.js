import ApplicationController from './application_controller';

export default class ReactionTesterController extends ApplicationController {
  static targets = [ 'regex', 'output', 'input', 'testOutput' ]
  async run() {
    this.stimulate("ReactionTest#run", {
      regex: this.regexTarget.value,
      output: this.outputTarget.value,
      input: this.inputTarget.value,
    });
  }
}
