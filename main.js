const { app, BrowserWindow } = require('electron')
process.env.ELECTRON_DISABLE_SECURITY_WARNINGS = '1';
const path = require('path')
const url = require('url')
const Menu = require('electron').Menu

let win

function createWindow() {
    win = new BrowserWindow({
        show: false,
        icon: __dirname + '/app/assets/Icons/Icon.icns',
        title: 'K8s Automation'
    })
    win.maximize();
    win.show();

    win.loadURL(url.format({
        pathname: path.join(__dirname, '/app/home.html'),
        protocol: 'file:',
        slashes: true
    }))

    win.on('closed', () => {
        win = null
    })
    
    // Open the DevTools.
    //win.openDevTools();

    createMenu()
}

app.on('ready', createWindow)



app.on('window-all-closed', () => {
    if (process.platform !== 'darwin') {
        app.quit()
    }
})

app.on('activate', () => {
    if (win === null) {
        createWindow()
    }
})

function createMenu() {
    const application = {
        label: "Application",
        submenu: [
            {
                label: "About Application",
                selector: "orderFrontStandardAboutPanel:"
            },
            {
                type: "separator"
            },
            {
                label: "Quit",
                accelerator: "Command+Q",
                click: () => {
                    app.quit()
                }
            }
        ]
    }

    const edit = {
        label: "Edit",
        submenu: [
            {
                label: "Undo",
                accelerator: "CmdOrCtrl+Z",
                selector: "undo:"
            },
            {
                label: "Redo",
                accelerator: "Shift+CmdOrCtrl+Z",
                selector: "redo:"
            },
            {
                type: "separator"
            },
            {
                label: "Cut",
                accelerator: "CmdOrCtrl+X",
                selector: "cut:"
            },
            {
                label: "Copy",
                accelerator: "CmdOrCtrl+C",
                selector: "copy:"
            },
            {
                label: "Paste",
                accelerator: "CmdOrCtrl+V",
                selector: "paste:"
            },
            {
                label: "Select All",
                accelerator: "CmdOrCtrl+A",
                selector: "selectAll:"
            }
        ]
    }

    const template = [
        application,
        edit
    ]

    Menu.setApplicationMenu(Menu.buildFromTemplate(template))
}