var winston = require('winston');
winston.level = process.env.LOG_LEVEL || 'info';

var readline = require('readline');
var Engine = require('../build/engine').default;

var engine = new Engine();

var rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

rl.setPrompt('You> ');
rl.prompt();
rl.on('line', function(cmd) {
  engine.getReply({
    platform: 'test',
    id: 1,
    message: cmd
  }).then(function(reply) {
    console.log('Bot> ', reply);
    rl.prompt();
  }).catch(function(error) {
    console.error('Error:', error);
    rl.prompt();
  });
}).on('close', function() {
  process.exit(0);
});
