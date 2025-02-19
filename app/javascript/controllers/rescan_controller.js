import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["profile", "message"];

  perform(event) {
    event.preventDefault();

    const url = event.currentTarget.dataset.rescanUrl;
    const updateUrl = this.element.dataset.rescanUrl;

    fetch(url, {
      method: "POST",
      headers: {
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
          .content,
        Accept: "application/json",
      },
    })
      .then((response) => response.json())
      .then((data) => {
        this.showMessage(
          data.message,
          data.status === "success" ? "text-success" : "text-danger"
        );

        if (data.status === "success") {
          fetch(updateUrl, {
            headers: { Accept: "text/plain" },
          })
            .then((response) => response.text())
            .then((html) => {
              this.profileTarget.innerHTML = html;
            });
        }
      })
      .catch(() => {
        this.showMessage("Erro ao re-escanear o perfil.", "text-danger");
      });
  }

  showMessage(message, cssClass) {
    this.messageTarget.classList.remove(
      "d-none",
      "text-success",
      "text-danger"
    );
    this.messageTarget.classList.add(cssClass);
    this.messageTarget.textContent = message;

    setTimeout(() => {
      this.messageTarget.classList.add("d-none");
    }, 3000);
  }
}
