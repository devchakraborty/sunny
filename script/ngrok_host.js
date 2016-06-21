var http = require('http');

http.request({
  host: 'localhost',
  port: 4040,
  path: '/api/tunnels'
}, function(response) {

  var str = '';

  //another chunk of data has been recieved, so append it to `str`
  response.on('data', function (chunk) {
    str += chunk;
  });

  //the whole response has been recieved, so we just print it out here
  response.on('end', function () {
    var tunnels = JSON.parse(str).tunnels;
    for (var t = 0; t < tunnels.length; t++) {
      var tunnel = tunnels[t];
      if (tunnel.proto == 'https') {
        console.log(tunnel.public_url + "/api/bot");
        process.exit(0);
      }
    }
  });
}).end();
