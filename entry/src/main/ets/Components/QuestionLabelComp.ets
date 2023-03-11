@Preview
@Component
export default struct QuestionLabelComp {
  msg: string = ''
  build() {
    Row() {
      Column() {
        Text(this.msg)
          .width("100%")
          .constraintSize({ minHeight: "100vp" })
          .textAlign(TextAlign.End)
      }      
      .width("80%")
      Column() {
        Image($r('app.media.icon'))
          .width("60vp")
          .height("60vp")
          .margin({ top: "10vp", bottom: "10vp", left: "10vp", right: "10vp" })
      }      
      .width("20%")
      .justifyContent(FlexAlign.Start)
    }    
    .width("100%")
  }
}
