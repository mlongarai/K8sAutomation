// Mac and Linux have Bash shell scripts (so the following would work)
//        var child = process.spawn('child', ['-l']);
//        var child = process.spawn('./test.sh');       
// Win10 with WSL (Windows Subsystem for Linux)  https://docs.microsoft.com/en-us/windows/wsl/install-win10
//   
// Win10 with Git-Bash (windows Subsystem for Linux) https://git-scm.com/   https://git-for-windows.github.io/
//
function appendOutputLocation(msg_location) {
  if (document.getElementById("eastus").value) {
    getCommandOutputAzLocation().value = document.getElementById("eastus").value + msg_location;
  } else {
    getCommandOutputAzLocation().value += msg_location;
  }
  alert(getCommandOutputAzLocation().value);
};


function setStatusAzLocation(msg_location) { getStatusAzLocation(msg_location); };

function backgroundProcessAzLocation() {
  const process = require('child_process');   // The power of Node.JS
  var cmd = __dirname + '/scripts/' + 'invoke_azLocation.sh';
  console.log('cmd:', cmd);

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