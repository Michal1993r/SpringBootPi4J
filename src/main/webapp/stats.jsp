<!DOCTYPE html>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html lang="en">
<head>
    <script src="https://code.jquery.com/jquery-1.10.2.js"></script>
    <%--Bootstrap--%>
    <!-- Latest compiled and minified CSS -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"
          integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
    <!-- Optional theme -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap-theme.min.css"
          integrity="sha384-rHyoN1iRsVXV4nD0JutlnGaslCJuC7uwjduW9SVrLvRYooPp2bWYgmgJQIXwl/Sp" crossorigin="anonymous">
    <!-- Latest compiled and minified JavaScript -->
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"
            integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa"
            crossorigin="anonymous"></script>

    <%--Indicators--%>
    <link rel="stylesheet" type="text/css" href="css/flightindicators.css"/>
    <script src="js/jquery.flightindicator.js"></script>

    <script async defer
            src="https://maps.googleapis.com/maps/api/js?key=AIzaSyAJWOKUyatUHukA-qslSXXC_RuSvsuKgqI&callback=initMap">
    </script>
    <style>
        #map {
            height: 400px;
            width: 50%;
        }
    </style>
</head>
<body style="background-color: black;">
<div class="jumbotron" style="text-align: center; background-color: #2c1c73; color: darkred;">
    <h1>Drone Telemetry Module</h1>
</div>
<div class="row">
    <div class="col-md-2 col-xs-offset-1">
        <span id="attitude"></span>
    </div>
    <div id="map" class="col-md-5"></div>
    <div class="col-md-2 col-md-offset-1">
        <span id="airspeed"></span>
    </div>
</div>
</body>

</html>

<script>
    var marker;
    var map;
    var path;
    var points = [];
    var attitudeIndicator = $.flightIndicator('#attitude', 'attitude');
    var airspeedIndicator = $.flightIndicator('#airspeed', 'airspeed');
    setInterval(function () {
        $.get("gyroData", function (response) {
            attitudeIndicator.setRoll(response[0]);
            attitudeIndicator.setPitch(response[1]);
        });
    }, 100);

    setInterval(function () {
        var newPosition = new google.maps.LatLng();
        $.get("gpsData", function (response) {
            console.log(response);
            newPosition = new google.maps.LatLng(response[0], response[1]);
            if (response.size !== 0) {
                points.push(newPosition);
                marker.setPosition(newPosition);
                map.setCenter(newPosition);
                path.setMap(map);
                path.setPath(points);
                airspeedIndicator.setAirSpeed(response[2]);
            }
        });
    }, 5000);
    function initMap() {
        var initPos = new google.maps.LatLng(50.978500, 20.547611);
        map = new google.maps.Map(document.getElementById('map'), {
            zoom: 18, //0-18
            center: initPos,
            disableDefaultUI: true,
            mapTypeControls: false,
            mapTypeId: 'hybrid'
        });
        marker = new google.maps.Marker({
            position: initPos,
            map: map,
            icon: 'img/drone_icon.svg'
        });
        path = new google.maps.Polyline({
            path: points,
            strokeColor: "#FF0000",
            strokeOpacity: 1.0,
            strokeWeight: 2
        });
        path.setMap(map);
    }
</script>
