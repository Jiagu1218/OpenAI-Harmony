import { ChatCompletionRequestMessage,ChatCompletionRequestMessageRoleEnum } from '@ohos/openai-harmony'

export class ChatMessage implements ChatCompletionRequestMessage{
  role:ChatCompletionRequestMessageRoleEnum
  content:string
}