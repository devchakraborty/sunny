import express from 'express'
import winston from 'winston'
import expressWinston from 'express-winston'
import bodyParser from 'body-parser'
import Facebook from './facebook'

export default class Server {
  constructor() {
    this.app = express()
    this.app.use(bodyParser.json())
    this.app.use(expressWinston.logger({
      winstonInstance: winston
    }))
    new Facebook({
      access_token: process.env.FB_ACCESS_TOKEN,
      verify_token: process.env.FB_VERIFY_TOKEN,
      logger: winston
    }).mount(this.app)
  }

  serve(port) {
    let p = port || process.env.PORT || 3000
    this.app.listen(p)
    winston.info('Express app running on :%d', p)
  }
}
