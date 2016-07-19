import _ from 'lodash'

export default class OutgoingMessage {
  constructor({recipient, replyText, userContext, delay = 0}) {
    this.recipient = recipient
    this.replyText = replyText
    this.userContext = userContext
    this.delay = delay
  }

  payload() {
    var p = {
      recipient: {
        id: this.recipient
      },
      message: {
        text: this.replyText
      }
    }
    if (this.hasQuickReplies()) {
      p = _.merge(p, {
        message: {
          quick_replies: this.quickReplies()
        }
      })
    }
    return p
  }

  hasQuickReplies() {
    for (let key of Object.keys(this.userContext)) {
      if (key.indexOf('fb_qr') == 0) return true
    }
    return false
  }

  quickReplies() {
    let qr = []
    for (let key of Object.keys(this.userContext)) {
      if (key.indexOf('fb_qr') == 0) {
        let reply = key.substr(6).replace(/_/g, ' ').replace(/\w\S*/g, function(txt){
          return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase()
        })
        qr.push({
          content_type: 'text',
          title: reply,
          payload: reply
        })
      }
    }
    return qr
  }
}
