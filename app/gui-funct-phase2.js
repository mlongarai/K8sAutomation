require('path');
var is = require("electron-is");

// Mac and Linux have Bash shell scripts (so the following would work)
//        var child = process.spawn('child', ['-l']);
//        var child = process.spawn('./test.sh');       
// Win10 with WSL (Windows Subsystem for Linux)  https://docs.microsoft.com/en-us/windows/wsl/install-win10
//   
// Win10 with Git-Bash (windows Subsystem for Linux) https://git-scm.com/   https://git-for-windows.github.io/
//

function appendOutput(msg) { getCommandOutput().value += (msg+'\n'); };
function setStatus(msg)    { getStatus().innerHTML = msg; };

function showOS() {
    if (is.windows())
      appendOutput("Windows Detected.")
    if (is.macOS())
      appendOutput("macOS Detected.")
    if (is.linux())
      appendOutput("Linux Detected.")
}

function backgroundProcess(resource_group, aks_name, app_name, aks_service, dns_name_suffix, aks_location, aks_files) {
    const process = require('child_process');   // The power of Node.JS

  //showOS();

  //var cmd = __dirname + '/scripts/' + 'phase2_test.sh';
  var cmd = __dirname + '/scripts/' + 'phase2_Deploy.sh';
    console.log('cmd:', cmd);
  
  var child = process.spawn(cmd, ['-a ' + resource_group, '-b ' + aks_name, '-c ' + app_name, '-d ' + aks_service, '-e ' + dns_name_suffix, '-f ' + aks_location, '-g ' + aks_files]);

    child.on('error', function(err) {
      appendOutput('stderr: <'+err+'>' );
    });

    child.stdout.on('data', function (data) {
      appendOutput(data);
    });

    child.stderr.on('data', function (data) {
      appendOutput('stderr: <'+data+'>' );
    });

    child.on('close', function (code) {
        if (code == 0)
          setStatus('Process complete.');
        else
          setStatus('child process exited with code ' + code);

      getCommandOutput().style.background = "Dark";
    });
};
