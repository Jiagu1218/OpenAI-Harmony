import { ChatMessage } from '../bean/ChatMessage';
import chatViewModel,{ ChatViewModel } from '../model/ChatViewModel';
import AnswerLabelComp from '../Components/AnswerLabelComp';
import QuestionLabelComp from '../Components/QuestionLabelComp';
@Preview
@Component
export default struct ChatView {
  @State textAreaHeight:number = 80
  @State message:string = ""
  private model:ChatViewModel = chatViewModel
  build() {
    Stack(){
      List() {
        LazyForEach(this.model.getMessageList(),(item:ChatMessage)=>{
          if(item.role == 'user'){
            ListItem() {
              QuestionLabelComp({msg:item.content})
            }
            .width("100%")
            .height("80vp")
          }
          if (item.role == 'assistant') {
            ListItem() {
              AnswerLabelComp({msg:item.content})
            }
            .width("100%")
            .height("80vp")
          }
        },item => item.id)
      }
      .width("100%")
      .margin({bottom:this.textAreaHeight})
      Row() {
        Column() {
          TextArea({placeholder:'在此输入'}).width('100%')
            .onChange(value => this.message = value)
        }.width('80%')
        Column() {
          Button('>',{type:ButtonType.Circle})
            .onClick(()=>{
              this.model.createChatCompletion(this.message)
              this.message = ''
            })
        }.width('20%')
      }.height(this.textAreaHeight)
    }.height('100%')
    .alignContent(Alignment.Bottom)
  }
}
