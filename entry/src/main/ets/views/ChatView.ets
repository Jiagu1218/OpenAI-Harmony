import { ChatMessage } from '../bean/ChatMessage';
import chatViewModel,{ ChatViewModel } from '../model/ChatViewModel';
import AnswerLabelComp from '../Components/AnswerLabelComp';
import QuestionLabelComp from '../Components/QuestionLabelComp';

@Preview
@Component
export default struct ChatView {
  private scroller: Scroller = new Scroller()
  @State textAreaHeight:number = 80
  @State message:string = ""
  private model:ChatViewModel = chatViewModel
  scrollerTo(index:number){
    this.scroller.scrollToIndex(index)
  }
  build() {
    Stack(){
      List({scroller:this.scroller}) {
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
        },item => item.content)
      }
      .width("100%")
      .margin({bottom:this.textAreaHeight})
      Row() {
        Column() {
          TextArea({placeholder:'在此输入',text:this.message}).width('100%')
            .onChange(value => this.message = value)
        }.width('80%')
        Column() {
          Button('>',{type:ButtonType.Circle})
            .onClick(()=>{
              this.model.createChatCompletion(this.message,this.scrollerTo.bind(this))
              this.message = ''
            })
        }.width('20%')
      }.height(this.textAreaHeight)
    }.height('100%')
    .alignContent(Alignment.Bottom)
  }
}
