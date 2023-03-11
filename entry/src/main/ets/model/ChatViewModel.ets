import { ChatMessageList } from '../bean/ChatMessageList';
import http from '@ohos.net.http'
import {OpenAIApi,ChatCompletionRequestMessageRoleEnum} from '@ohos/openai-harmony';
export class ChatViewModel {
  private openai:OpenAIApi = OpenAIApi.getInstance({apiKey:'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'})
  private messageList:ChatMessageList = new ChatMessageList()
  private model:string = "gpt-3.5-turbo"
  private index:number = 0
  private user:string =''

  async createChatCompletion(msg:string,callback?:(index:number)=>void){
    try {
      if (msg.length>0) {
        //创建对话
        this.index++
        this.messageList.pushData({role:'user',content:msg})
        this.openai.createChatCompletion({
          model:this.model,
          messages: this.messageList.getList(),
          user:this.user?this.user:undefined
        }).then((response:http.HttpResponse) =>{
          //处理返回结果
          const result = JSON.parse(response.result.toString())
          if (!this.user) {
            this.user=result.id
          }
          const message = result.choices[0]?.message
          this.index++
          this.messageList.pushData(message)
          if (callback) {
            callback(this.index)
          }
          console.info('openai',JSON.stringify(result))
        }).catch(error=>{
          //处理异常
          console.error('openai',JSON.stringify(error))
        })
      }
    }catch(error){
      console.error('openai',JSON.stringify(error))
    }

  }
  getMessageList(){
    return this.messageList
  }
}

let chatViewModel = new ChatViewModel()

export default chatViewModel as ChatViewModel