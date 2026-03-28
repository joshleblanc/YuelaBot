import ApplicationController from './application_controller';

export default class ReactionTesterController extends ApplicationController {
  static targets = [ 'regex', 'output', 'input', 'testOutput' ]

  async run() {
    try {
      const response = await fetch('/user_reactions/test', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': this.getCsrfToken(),
        },
        body: JSON.stringify({
          regex: this.regexTarget.value,
          output: this.outputTarget.value,
          input: this.inputTarget.value,
        }),
      });

      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }

      const data = await response.json();
      // Handle the response data as needed
      if (this.hasTestOutputTarget && data.result !== undefined) {
        this.testOutputTarget.textContent = data.result;
      }
    } catch (error) {
      console.error('Reaction test failed:', error);
      if (this.hasTestOutputTarget) {
        this.testOutputTarget.textContent = 'Error running reaction test';
      }
    }
  }

  getCsrfToken() {
    return document.querySelector('meta[name="csrf-token"]')?.content || '';
  }
}
