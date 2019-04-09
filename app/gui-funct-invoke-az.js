// Mac and Linux have Bash shell scripts (so the following would work)
//        var child = process.spawn('child', ['-l']);
//        var child = process.spawn('./test.sh');       
// Win10 with WSL (Windows Subsystem for Linux)  https://docs.microsoft.com/en-us/windows/wsl/install-win10
//   
// Win10 with Git-Bash (windows Subsystem for Linux) https://git-scm.com/   https://git-for-windows.github.io/
//

//function appendOutput(msg) { getCommandOutput().value += (msg+'\n'); };
function setStatusAz(msg) { getStatusAz(msg); };

function backgroundProcessAz() {
    const process = require('child_process');   // The power of Node.JS

  var cmd = __dirname + '/scripts/' + 'invoke_az.sh';
    console.log('cmd:', cmd);
  
  var child = process.spawn(cmd);

    child.on('close', function (code) {
      if (code == 0)
        setStatusAz('Success');
      else
        setStatusAz('Error');
    });
};
