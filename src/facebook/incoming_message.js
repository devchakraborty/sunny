import _ from 'lodash'

export default class IncomingMessage {
  constructor(payload) {
    this.payload = payload
  }

  get text() {
    return _.get(this.payload, 'message.text')
  }

  get sender() {
    return _.get(this.payload, 'sender.id')
  }

  get platform() {
    return 'facebook'
  }
}

IncomingMessage.parseMessages = function(envelope) {
  let messages = []
  if (envelope.entry != null) {
    envelope.entry.forEach(function(entry) {
      if (entry.messaging != null) {
        entry.messaging.forEach(function(messaging) {
          if (messaging.message != null)
            messages.push(new IncomingMessage(messaging))
        })
      }
    })
  }
  return messages
}
