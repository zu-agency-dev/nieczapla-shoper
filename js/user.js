window.addEventListener("DOMContentLoaded", (event) => {
  const plus = document.querySelector("#plusQuantity");
  const minus = document.querySelector("#minusQuantity");
  const input = document.querySelector('input[name="quantity"]');

  if (plus) {
    plus.addEventListener("click", () => {
      input.value = parseInt(input.value) + 1;
    });
  }

  if (minus) {
    minus.addEventListener("click", () => {
      if (input.value > 0) input.value -= 1;
    });
  }
});

window.addEventListener("DOMContentLoaded", () => {
  const currentPath = window.location.href;
  const links = document.querySelectorAll(".categories__item");

  if (links) {
    links.forEach((link) => {
      if (link.href == currentPath) {
        link.classList.add("active");
      }
    });
  }
});
