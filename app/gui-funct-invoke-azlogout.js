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