  // Get the modal
  var modal = document.getElementById("myModal");

  // Get the button that opens the modal
  var btn = document.getElementById("myBtn");

  // Get the <span> element that closes the modal
  var span = document.getElementsByClassName("close")[0];
  
  // hade modal
  var headermodal = document.getElementById("headermodal");

  function openModal(val,id) {
    headermodal.innerHTML = val;
      console.log(val);
    modal.style.display = "block";
  }


function myFunc() {
console.log("Clicked my func");
  modal.style.display = "block";
}

  // When the user clicks on <span> (x), close the modal
  span.onclick = function() {
    modal.style.display = "none";
  }

  // When the user clicks anywhere outside of the modal, close it
  window.onclick = function(event) {
    if (event.target == modal) {
      modal.style.display = "none";
    }
  }

function isEditing(val) {
  headermodal.innerHTML = val;
    location.href = "www.yoursite.com";
}


