function appendOutputLocation(msg_location) {
  if (msg_location != "Error" || msg_location.toString().substring(0,5) != "stderr"){
  var locations = JSON.parse(msg_location);
  for (i = 0; i < locations.length; i++) {
    switch (locations[i]['location']) {
      case "australiaeast":
        document.getElementById("australiaeast").style.display = "block";
        break;
    
      case "australiasoutheast":
        document.getElementById("australiasoutheast").style.display = "block";
        break;

      case "canadacentral":
        document.getElementById("canadacentral").style.display = "block";
        break;

      case "canadaeast":
        document.getElementById("canadaeast").style.display = "block";
        break;

      case "centralindia":
        document.getElementById("centralindia").style.display = "block";
        break;

      case "centralus":
        document.getElementById("centralus").style.display = "block";
        break;

      case "eastasia":
        document.getElementById("eastasia").style.display = "block";
        break;

      case "eastus":
        document.getElementById("eastus").style.display = "block";
        break;

      case "eastus2":
        document.getElementById("eastus2").style.display = "block";
        break;

      case "francecentral":
        document.getElementById("francecentral").style.display = "block";
        break;

      case "japaneast":
        document.getElementById("japaneast").style.display = "block";
        break;

      case "koreacentral":
        document.getElementById("koreacentral").style.display = "block";
        break;

      case "koreasouth":
        document.getElementById("koreasouth").style.display = "block";
        break;

      case "northeurope":
        document.getElementById("northeurope").style.display = "block";
        break;
      
      case "southeastasia":
        document.getElementById("southeastasia").style.display = "block";
        break;

      case "southcentralus":
        document.getElementById("southcentralus").style.display = "block";
        break;

      case "southindia":
        document.getElementById("southindia").style.display = "block";
        break;

      case "uksouth":
        document.getElementById("uksouth").style.display = "block";
        break;

      case "ukwest":
        document.getElementById("ukwest").style.display = "block";
        break;

      case "westeurope":
        document.getElementById("westeurope").style.display = "block";
        break;

      case "westus":
        document.getElementById("westus").style.display = "block";
        break;

      case "westus2":
        document.getElementById("westus2").style.display = "block";
        break;
    }
  }
}  else {
    console.log('logout');
}
};


function backgroundProcessAzLocation() {
  const process = require('child_process');   // The power of Node.JS
  var cmd = __dirname + '/scripts/' + 'invoke_azLocation.sh';
  //console.log('cmd:', cmd);

  var child = process.spawn(cmd);
  
  child.on('error', function (err) {
    appendOutputLocation('stderr: <' + err + '>');
    console.log('err:', err);
  });

  child.stdout.on('data', function (data) {
    appendOutputLocation(data);
  });

  child.stderr.on('data', function (data) {
    appendOutputLocation('stderr: <' + data + '>');
  });

  child.on('close', function (code) {
    if (code == 0) {
      setStatusAzLocation('Success');
    } else {
      setStatusAzLocation('Error');
    }
  });
};