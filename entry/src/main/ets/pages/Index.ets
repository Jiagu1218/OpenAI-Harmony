import CreateImageView from '../views/CreateImageView';
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
    this.openai = OpenAIApi.getInstance({apiKey:''})
  }
  
  build() {
    Column() {
      Column() {
        Tabs() {
          TabContent() {
              ChatView()
          }
          TabContent() {
            CreateImageView()
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