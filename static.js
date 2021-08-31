function put_marker(from_left, from_top, floor) {

  var marker = document.getElementById('marker');
  marker.style.left = from_left + "px";
  marker.style.top = from_top + "px";
  marker.style.display = "block";

  var map = document.getElementById('map');
  if (floor == "3rd")
    map.style.backgroundImage = "url(./3rdFloor2.svg)";
  else if (floor == "4th")
    map.style.backgroundImage = "url(./4thFloor2.svg)";
}

function find_desk() {
    var x = document.getElementById("mySelect").value;

    if (x == "Name") { document.getElementById('marker').style.display = 'none'; }
    // INSERT HERE CODE HERE //
    else { document.getElementById('marker').style.display = 'none'; }
}