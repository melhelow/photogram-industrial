// Ensure these are imported
import "@rails/ujs"
import "@hotwired/turbo-rails"

// Add manual CSRF handling
document.addEventListener("DOMContentLoaded", function() {
  document.addEventListener("ajax:beforeSend", function(event) {
    const token = document.querySelector("meta[name='csrf-token']").content;
    event.detail[0].setRequestHeader("X-CSRF-Token", token);
  });
});
