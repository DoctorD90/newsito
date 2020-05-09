function myPEMhide() {
  var x = document.getElementById("myPEM");
  if (x.style.display === "block") {
    x.style.display = "none";
  } else {
    x.style.display = "block";
  }
}

function myPEMcopy() {
  /* Get the text field */
  var copyText = document.getElementById("myPEM");

  /* Select the text field */
  copyText.select();

  /* Copy the text inside the text field */
  document.execCommand("copy");

  /* Alert the copied text */
  alert("Copied the text: " + copyText.value);
} 
