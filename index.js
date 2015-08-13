var WebSocketServer = require('ws').Server;
var wss = new WebSocketServer({ port: 3000 });
var express = require('express');
var app = express();
var http = require('http').Server(app);

var clients = [];

app.get('/', function(req, res){
  res.sendFile(__dirname + '/index.html');
});

http.listen(8000, function(){
  console.log('listening on *:8000');
});

function htmlEntities(str) {
    return String(str).replace(/&/g, '&amp;').replace(/</g, '&lt;')
                      .replace(/>/g, '&gt;').replace(/"/g, '&quot;');
}

wss.on('connection', function (ws) {
  
  var index = clients.push(ws) - 1;
  var userName = false;
  var userColor = false;
  console.log('connected');
  
  ws.on('close', function() {
    clients.splice(index, 1);
    console.log(userName + ' disconnected');
  });
  
  ws.on('message', function (message) {
    if (userName === false) {
      userName = htmlEntities(message);
    }
    else {
      var messageObj = {
          time: (new Date()).getTime() + "",
          message: htmlEntities(message),
          username: userName
      };
      console.log(messageObj);
      var json = JSON.stringify(messageObj);
      clients.forEach(function(client) {
        if (client !== ws) {
          client.send(json);
        }
      });
    }
  });
});