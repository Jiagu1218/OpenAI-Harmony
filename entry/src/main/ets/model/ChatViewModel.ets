import { ChatMessageList } from '../bean/ChatMessageList';
import http from '@ohos.net.http'
import {OpenAIApi} from '@ohos/openai-harmony';
export class ChatViewModel {
  private openai:OpenAIApi
  private messageList:ChatMessageList = new ChatMessageList()
  private model:string = "gpt-3.5-turbo"
  private id:number = 0
  private user:string

  createChatCompletion(msg:string){
    if (msg.length>0) {
      //创建对话
      this.messageList.pushData({id:this.id=+this.id,role:'user',content:msg})
      this.openai.createChatCompletion({
        model:this.model,
        messages: [{role: "user", content: msg}],
      }).then((response:http.HttpResponse) =>{
        //处理返回结果
        const result = JSON.parse(response.result.toString())
        const message = result.choices[0]?.message
        this.messageList.pushData({id:this.id=+this.id,role:message.role,content:message.content})
        console.info('openai',JSON.stringify(result))
      }).catch(error=>{
        //处理异常
        console.error('openai',JSON.stringify(error))
      })
    }
  }
  getMessageList(){
    return this.messageList
  }
}

let chatViewModel = new ChatViewModel()

export default chatViewModel as ChatViewModel