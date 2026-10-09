import {
  auth,
  db,
  createUserWithEmailAndPassword,
  doc,
  setDoc
} from "./firebase.js";

function isValidEmail(email) {
  return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
}

document.querySelector(".signup-form").addEventListener("submit", async (e) => {
  e.preventDefault();

  const fname = document.getElementById("fname").value.trim();
  const lname = document.getElementById("lname").value.trim();
  const email = document.getElementById("email").value.trim();
  const phone = document.getElementById("phone").value.trim();
  const password = document.getElementById("password").value;
  const confirm = document.getElementById("confirm").value;

  if (!isValidEmail(email)) {
    alert("Invalid email");
    return;
  }

  if (password !== confirm) {
    alert("Passwords do not match");
    return;
  }

  try {
    const user = await createUserWithEmailAndPassword(auth, email, password);

    await setDoc(doc(db, "users", user.user.uid), {
      fname,
      lname,
      email,
      phone
    });

    alert("Account created successfully");
    window.location.href = "index.html";

  } catch (err) {
    alert(err.message);
  }
});
