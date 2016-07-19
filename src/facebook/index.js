import Botkit from 'botkit'
import winston from 'winston'
import Engine from '../engine'
import FB from 'fb'
import _ from 'lodash'
import IncomingMessage from './incoming_message'
import OutgoingMessage from './outgoing_message'

FB.setAccessToken(process.env.FB_ACCESS_TOKEN)

export default class Facebook {
  constructor(options) {
    this.controller = Botkit.facebookbot(options)
    this.bot = this.controller.spawn({})
    this.engine = new Engine({
      profileFetcher: this.profileFetcher.bind(this),
      messageFlags: ['fb_qr'],
      OutgoingMessage: OutgoingMessage
    })

    this.engine.on('message_sending', this.sendMessage.bind(this))
  }

  mount(app) {
    app.get('/facebook/receive', (req, res) => {
      if (req.query['hub.mode'] == 'subscribe' && req.query['hub.verify_token'] == process.env.FB_VERIFY_TOKEN) {
        res.send(req.query['hub.challenge'])
        winston.info('subscribed to facebook notifications')
      } else {
        res.status(400).send('bad token')
      }
    })

    app.post('/facebook/receive', (req, res) => {
      winston.debug('received facebook notification', JSON.stringify(req.body))
      let messages = IncomingMessage.parseMessages(req.body)
      console.log('MESSAGES', messages)
      messages.forEach((message) => {
        console.log('MESSAGE', message)
        this.engine.emit('message_received', message)
      })
      res.status(200).end()
    })
  }

  sendMessage(message) {
    winston.debug('send', JSON.stringify(message.payload()))
    FB.api('me/messages', 'post', message.payload())
  }

  profileFetcher(id) {
    return new Promise((resolve, reject) => {
      FB.api(id, (res) => {
        if (!res || res.error) {
          return reject(!res ? 'FB API error' : res.error)
        }
        resolve(res)
      })
    })
  }

  postprocess(id, reply) {
    return reply.split('\n').map((message) => {
      return {
        recipient: {
          id: id
        },
        message: {
          text: message
        }
      }
    })
  }
}
