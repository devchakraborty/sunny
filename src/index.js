import 'babel-polyfill'
import Server from './server'
import winston from 'winston'

winston.level = 'debug'

let server = new Server()
server.serve()
