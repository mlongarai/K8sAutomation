// Mac and Linux have Bash shell scripts (so the following would work)
//        var child = process.spawn('child', ['-l']);
//        var child = process.spawn('./test.sh');       
// Win10 with WSL (Windows Subsystem for Linux)  https://docs.microsoft.com/en-us/windows/wsl/install-win10
//   
// Win10 with Git-Bash (windows Subsystem for Linux) https://git-scm.com/   https://git-for-windows.github.io/
//

function appendOutput(msg) { 
  if (document.getElementById("dash_resources").value) {
    getCommandOutputAzResouces().value = document.getElementById("dash_resources").value + "|" + msg; 
  } else {
    getCommandOutputAzResouces().value = msg; 
  }
};


function setStatusAzResouces(msg) { getStatusAzResouces(msg); };

function backgroundProcessAzResouces() {
  const process = require('child_process');   // The power of Node.JS
  var cmd = __dirname + '/scripts/' + 'invoke_azResources.sh';
  //console.log('cmd:', cmd);

  var child = process.spawn(cmd);
  
  child.on('error', function (err) {
    appendOutput('stderr: <' + err + '>');
    console.log('err:', err);
  });

  child.stdout.on('data', function (data) {
    appendOutput(data);
  });

  child.stderr.on('data', function (data) {
    appendOutput('stderr: <' + data + '>');
  });

  child.on('close', function (code) {
    if (code == 0) {
      setStatusAzResouces('Success');
    } else {
      setStatusAzResouces('Error');
    }
  });
};
