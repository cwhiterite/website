function put_marker(from_left, from_top, floor) {
    with (document.getElementById('marker')) {
        style.left = from_left + "px";
        style.top = from_top + "px";
        style.display = "block";

        if (floor == "3rd")
            document.getElementById('map').style.backgroundImage = "url(./3rdFloor2.svg)";
        else if (floor == "4th")
            document.getElementById('map').style.backgroundImage = "url(./4thFloor2.svg)";
    }
}

function find_desk() {
    var x = document.getElementById("mySelect").value;

    if (x == "Name") { document.getElementById('marker').style.display = 'none'; }
    // INSERT HERE CODE HERE //
    else { document.getElementById('marker').style.display = 'none'; }
}