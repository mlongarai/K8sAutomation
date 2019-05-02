function setStatusAz(msg) { getStatusAz(msg); };

function backgroundProcessAz() {
    const process = require('child_process');   // The power of Node.JS
  var cmd = __dirname + '/scripts/' + 'invoke_az.sh';
    //console.log('cmd:', cmd);
  
  var child = process.spawn(cmd);

    child.on('close', function (code) {
      if (code == 0) {
        setStatusAz('Success');
        //alert("Entrou Sucesso!");
      } else {
        setStatusAz('Error');
        //alert("Entrou erro!");
      }
    });
};
