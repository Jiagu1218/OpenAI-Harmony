import ChatView from '../views/ChatView';
import QuestionLabelComp from '../Components/QuestionLabelComp'
import AnswerLabelComp from '../Components/AnswerLabelComp'

import {OpenAIApi} from '@ohos/openai-harmony';
import http from '@ohos.net.http'
@Entry
@Component
struct Index {

  @State message: string = 'Hello World'
  private openai:OpenAIApi

  aboutToAppear(){
    //初始化
    this.openai = OpenAIApi.getInstance({apiKey:'openai key'})
  }

  createChatCompletion(){
    //创建对话
    this.openai.createChatCompletion({
      model: "gpt-3.5-turbo",
      messages: [{role: "user", content: "Hello world"}],
    }).then((result) =>{
      //处理返回结果
      console.info('openai',JSON.stringify(result))
    }).catch(error=>{
      //处理异常
      console.error('openai',JSON.stringify(error))
    })
  }
  
  build() {
    Column() {
      Column() {
        Tabs() {
          TabContent() {
              ChatView()
          }
          TabContent() {
            Grid() {
              GridItem() {
                Image("")
                  .width("200vp")
                  .height("200vp")
              }              
              .width("50vp")
              .height("50vp")
            }            
            .width("100%")
            .height("100vp")
          }
        }        
        .width("100%")
        .height("100%")
      }      
      .width("100%")
      .height("100%")
      .justifyContent(FlexAlign.Center)
    }    
    .width("100%")
    .height("100%")
  }
}