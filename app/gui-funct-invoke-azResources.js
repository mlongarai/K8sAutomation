function appendOutput(msg) { 
  if(msg){
    //alert(msg);
    //alert(msg.toString().split(":")[0]);
    switch (msg.toString().split(':')[0]) {
    case "resources":
      //alert(msg.toString().split(":")[0]);
        document.getElementById("dash_resources").value.resources = msg.toString().split(":")[1];
        document.getElementById("dash_resources_refresh").className = "large";
        document.getElementById("dash_resources").innerHTML = msg.toString().split(":")[1];
      break;
    case "clusters":
        document.getElementById("dash_resources").value.clusters = msg.toString().split(":")[1];
        document.getElementById("dash_clusters_refresh").className = "large";
        document.getElementById("dash_clusters").innerHTML = msg.toString().split(":")[1];
      break;
    case "nodes":
        document.getElementById("dash_resources").value.nodes = msg.toString().split(":")[1];
        document.getElementById("dash_nodes_refresh").className = "large";
        document.getElementById("dash_nodes").innerHTML = msg.toString().split(":")[1];
      break;
    case "pods":
        document.getElementById("dash_resources").value.pods = msg.toString().split(":")[1];
        document.getElementById("dash_pods_refresh").className = "large";
        document.getElementById("dash_pods").innerHTML = msg.toString().split(":")[1];
      break;
  }  
}
};


function setStatusAzResouces(msg) { getStatusAzResouces(msg); };

function backgroundProcessAzResouces() {
  
  document.getElementById("dash_resources_refresh").className = "fa fa-refresh fa-spin";
  document.getElementById("dash_clusters_refresh").className = "fa fa-refresh fa-spin";
  document.getElementById("dash_nodes_refresh").className = "fa fa-refresh fa-spin";
  document.getElementById("dash_pods_refresh").className = "fa fa-refresh fa-spin";
  
  var obj = {
    resources: 0,
    clusters: 0,
    nodes: 0,
    pods: 0
  };
  document.getElementById("dash_resources").value = obj;

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
