const { app, BrowserWindow } = require("electron");
process.env.ELECTRON_DISABLE_SECURITY_WARNINGS = '1';

// Keep a global reference of the window object, if you don't, the window will
// be closed automatically when the JavaScript object is garbage collected.
var mainWindow = null

// Quit when all windows are closed.
app.on('window-all-closed', function() {
  // On OS X it is common for applications and their menu bar
  // to stay active until the user quits explicitly with Cmd + Q
  if (process.platform != 'darwin') {
    app.quit();
  }
});

// This method will be called when Electron has finished
// initialization and is ready to create browser windows.
app.on('ready', function() {
  // Create the browser window.
  
  mainWindow = new BrowserWindow({ 
    show: false ,
    icon: __dirname + '/app/assets/Icons/Icon.icns',
    title: 'K8s Automation'
  });
  mainWindow.maximize();
  mainWindow.show();

  // and load the index.html of the app.
  mainWindow.loadURL('file://' + __dirname + '/app/home.html');

  // Open the DevTools.
  mainWindow.openDevTools();    // requires a height 410px 

  // Emitted when the window is closed.
  mainWindow.on('closed', function() {
    // Dereference the window object, usually you would store windows
    // in an array if your app supports multi windows, this is the time
    // when you should delete the corresponding element.
    mainWindow = null;
  });
});

