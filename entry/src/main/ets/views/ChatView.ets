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
  scrollerToEnd(){
//    let strJson = getInspectorByKey('chatList');
//    let obj = JSON.parse(strJson);
//    console.info("[getInspectorByKey] current component obj is: " + JSON.stringify(obj));
//    let rectInfo = JSON.parse('[' + obj.$rect + ']')
//    console.info("[getInspectorByKey] rectInfo is: " + rectInfo);
    this.scroller.scrollEdge(Edge.End)
  }
  build() {
    Stack(){
      Column(){
        List({scroller:this.scroller}) {
          LazyForEach(this.model.getMessageList(),(item:ChatMessage)=>{
            if(item.role == 'user'){
              ListItem() {
                QuestionLabelComp({msg:item.content})
              }
              .width("100%")
            }
            if (item.role == 'assistant') {
              ListItem() {
                AnswerLabelComp({msg:item.content})
              }
              .width("100%")
            }
          },item => item.content)
        }.height("100%")
        .width("100%")
        .cachedCount(3)
//        .padding({bottom:this.textAreaHeight})
//        .id('chatList')
      }.width("100%")
      .height('100%')
      .padding({bottom:this.textAreaHeight})
      Row() {
        Column() {
          TextArea({placeholder:'在此输入',text:this.message}).width('100%')
            .onChange(value => this.message = value)
        }.width('80%')
        Column() {
          Button('>',{type:ButtonType.Circle})
            .onClick(()=>{
              this.model.createChatCompletion(this.message).then(()=>{
                this.scrollerToEnd()
              }).catch((e)=>{
                //todo:提示
              })
              this.scrollerToEnd()
              this.message = ''
            })
        }.width('20%')
      }.height(this.textAreaHeight)
    }.height('100%')
    .alignContent(Alignment.Bottom)
  }
}
