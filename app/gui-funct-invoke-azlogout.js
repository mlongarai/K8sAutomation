// Mac and Linux have Bash shell scripts (so the following would work)
//        var child = process.spawn('child', ['-l']);
//        var child = process.spawn('./test.sh');       
// Win10 with WSL (Windows Subsystem for Linux)  https://docs.microsoft.com/en-us/windows/wsl/install-win10
//   
// Win10 with Git-Bash (windows Subsystem for Linux) https://git-scm.com/   https://git-for-windows.github.io/
//

//function appendOutput(msg) { getCommandOutput().value += (msg+'\n'); };
function setStatusAzLogout(msg) { getStatusAzLogout(msg); };

function backgroundProcessAzLogout() {
    const process = require('child_process');   // The power of Node.JS
  var cmd = __dirname + '/scripts/' + 'invoke_azlogout.sh';
    //console.log('cmd:', cmd);
  
  var child = process.spawn(cmd);

    child.on('close', function (code) {
      if (code == 0) {
        setStatusAzLogout('Success');
      } else {
        setStatusAzLogout('Error');
      }
    });
};
