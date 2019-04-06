// Mac and Linux have Bash shell scripts (so the following would work)
//        var child = process.spawn('child', ['-l']);
//        var child = process.spawn('./test.sh');       
// Win10 with WSL (Windows Subsystem for Linux)  https://docs.microsoft.com/en-us/windows/wsl/install-win10
//   
// Win10 with Git-Bash (windows Subsystem for Linux) https://git-scm.com/   https://git-for-windows.github.io/
//

function appendOutput(msg) { getCommandOutput().value += (msg+'\n'); };
function setStatus(msg)    { getStatus().innerHTML = msg; };

function backgroundProcess(resource_group, registry_name, aks_name, nodes, aks_location, vmsize) {
    const process = require('child_process');   // The power of Node.JS

  //var cmd = __dirname + '/scripts/' + 'phase1_test.sh';
  var cmd = __dirname + '/scripts/' + 'phase1_Provision.sh';
    console.log('cmd:', cmd);
  
  var child = process.spawn(cmd, ['-a ' + resource_group, '-b ' + registry_name, '-c ' + aks_name, '-d ' + nodes, '-e ' + aks_location, '-f ' + vmsize]);

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
        //getCommandOutput().style.background = "DarkGray";
    });
};
