import {
  auth,
  provider,
  signInWithEmailAndPassword,
  signInWithPopup
} from "./firebase.js";

function isValidEmail(email) {
  return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
}

document.querySelector(".login-form").addEventListener("submit", async (e) => {
  e.preventDefault();

  const email = document.getElementById("email").value.trim();
  const password = document.getElementById("password").value;

  if (!isValidEmail(email)) {
    alert("Enter valid email");
    return;
  }

  if (password.length < 6) {
    alert("Password must be at least 6 characters");
    return;
  }

  try {
    await signInWithEmailAndPassword(auth, email, password);
    window.location.href = "welcome.html";
  } catch (err) {
    alert(err.message);
  }
});

document.querySelector(".google-btn").addEventListener("click", async () => {
  try {
    await signInWithPopup(auth, provider);
    window.location.href = "welcome.html";
  } catch (err) {
    alert(err.message);
  }
});
