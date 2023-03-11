import { ChatMessageList } from '../bean/ChatMessageList';
import http from '@ohos.net.http'
import {OpenAIApi,ChatCompletionRequestMessageRoleEnum} from '@ohos/openai-harmony';
export class ChatViewModel {
  private openai:OpenAIApi = OpenAIApi.getInstance({apiKey:''})
  private messageList:ChatMessageList = new ChatMessageList()
  private model:string = "gpt-3.5-turbo"
  private user:string =''

  async createChatCompletion(msg: string): Promise<void> {
    if (msg.length === 0) {
      return ;
    }

    this.messageList.pushData({ role: 'user', content: msg });
    const messages = this.messageList.getList();
    const user = this.user;

    try {
      const response = await this.openai.createChatCompletion({
        model: this.model,
        messages,
        user: user || undefined,
      });

      if (!user) {
        this.user = JSON.parse(response.result.toString()).id;
      }

      const { message } = JSON.parse(response.result.toString()).choices[0] ?? {};

      if (message) {
        this.messageList.pushData(message);
      }
      console.info('openai', JSON.stringify(response));
    } catch (error) {
      console.error('openai', JSON.stringify(error));
      throw error;
    }
  }

  getMessageList(){
    return this.messageList
  }
}

let chatViewModel = new ChatViewModel()

export default chatViewModel as ChatViewModel