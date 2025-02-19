import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["input", "list"];

  perform() {
    clearTimeout(this.timeout);

    this.timeout = setTimeout(() => {
      const query = this.inputTarget.value.trim();
      const url = `${
        this.inputTarget.dataset.searchUrl
      }?query=${encodeURIComponent(query)}`;

      fetch(url, {
        headers: { Accept: "text/plain" },
      })
        .then((response) => response.text())
        .then((html) => {
          this.listTarget.innerHTML = html;
        });
    }, 300);
  }
}
