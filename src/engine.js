import RiveScript from 'rivescript'
import _ from 'lodash'
import firebase from 'firebase'
import winston from 'winston'
import EventEmitter from 'events'
import natural from 'natural'
import Utils from './utils'
import mmt from 'moment'

const WPM = 300
let tokenizer = new natural.WordTokenizer()

// Firebase setup
let firebaseConfig = {
  apiKey: process.env.FIREBASE_API_KEY,
  authDomain: process.env.FIREBASE_AUTH_DOMAIN,
  databaseURL: process.env.FIREBASE_DATABASE_URL,
  storageBucket: process.env.FIREBASE_STORAGE_BUCKET
}
firebase.initializeApp(firebaseConfig)
let database = firebase.database()

// Engine class
export default class Engine extends EventEmitter {
  constructor(options) {
    super()
    this.options = _.defaults(options || {}, {messageFlags:[]})
    this.options.messageFlags.push('moment', 'message')

    // RiveScript setup
    let rs = new RiveScript()

    rs.errors.replyNotMatched = 'Sorry, I don\'t know what to say to that!'
    rs.errors.replyNotFound =
    rs.errors.objectNotFound =
    rs.errors.deepRecursion = 'Sorry, something went wrong. My masters are investigating.'

    rs.loadDirectory('brain', function() {
      winston.debug('loaded brain')
    })

    rs.setSubroutine('storeMoment', this.storeMoment.bind(this))

    this.rs = rs

    this.on('message_received', this.handleMessage.bind(this))
  }

  handleMessage(incomingMessage) {
    let message = incomingMessage.text
    let id = incomingMessage.sender
    let platform = incomingMessage.platform
    this.rs.sortReplies()
    let userRef = database.ref(`/users/${platform}/${id}`)
    return this.options.profileFetcher(id).then((profile) => {
      return userRef.once('value').then((snapshot) => {
        winston.debug('got user vars from firebase', JSON.stringify(snapshot.val()))
        let userVars = _.defaults(snapshot.val(), profile, {platform: platform})

        this.rs.clearUservars(id)
        this.rs.setUservars(id, userVars)
        winston.debug('set user vars in rivescript')

        return this.rs.replyAsync(id, message, this).then((reply) => {
          winston.debug('got reply from rivescript', reply)

          var updatedUserVars = this.rs.getUservars(id)
          winston.debug('updated user vars', JSON.stringify(updatedUserVars))

          var cumulativeDelay = 0
          reply.split('\n').forEach((reply) => {
            let message = new this.options.OutgoingMessage({
              recipient: id,
              replyText: reply,
              userContext: updatedUserVars,
              delay: cumulativeDelay += (tokenizer.tokenize(reply).length / WPM * 60 * 1000)
            })
            setTimeout(() => {
              this.emit('message_sending', message)
            }, message.delay)
          })

          let omitKeys = []
          _.each(updatedUserVars, (value, key) => {
            for (let messageFlag of this.options.messageFlags) {
              winston.debug('match', key, messageFlag)
              if (key.indexOf(messageFlag) == 0) {
                omitKeys.push(key)
                break
              }
            }
          })
          updatedUserVars = _.omit(updatedUserVars, omitKeys)

          userRef.set(updatedUserVars)
          winston.debug('updated user vars in firebase', JSON.stringify(updatedUserVars))
        })
      })
    }).catch((error) => {
      winston.error(error)
      return Promise.resolve(this.rs.errors.objectNotFound)
    })
  }

  storeMoment(rs, args) {
    let id = rs.currentUser()
    let vars = rs.getUservars(id)
    let platform = vars.platform
    let moment = args[0]
    let momentsRef = database.ref(`/moments/${platform}/${id}`)
    momentsRef.push({
      entered_at: firebase.database.ServerValue.TIMESTAMP,
      text: moment
    })
    return ''
  }

  fetchMoment(rs, args) {
    let id = rs.currentUser()
    let vars = rs.getUservars(id)
    let platform = vars.platform
    let momentsRef = database.ref(`/moments/${platform}/${id}`)
    return new rs.Promise((resolve, reject) => {
      momentsRef.once('value').then((snapshot) => {
        let moments = snapshot.val()
        let momentKeys = Object.keys(snapshot.val())
        if (momentKeys.length == 0) {
          resolve()
        } else {
          let moment = moments[Utils.sample(momentKeys)]
          rs.setUservars({
            moment_text: moment.text,
            moment_time: mmt(moment.entered_at).fromNow()
          })
        }
      })
    })
  }

  sendAttachment(rs, [type, attachment]) {

  }
}
