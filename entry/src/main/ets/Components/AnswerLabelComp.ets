@Preview
@Component
export default struct AnswerLabelComp {
  msg: string = ''
  build() {
    Row() {
      Column() {
        Image($r('app.media.icon'))
          .width("60vp")
          .height("60vp")
          .margin({ top: "10vp", bottom: "10vp", left: "10vp", right: "10vp" })
      }      
      .width("20%")
      Column() {
        Text(this.msg)
          .width("100%")
          .constraintSize({ minHeight: "80vp" })
      }      
      .width("80%")
    }
    .width("100%")
  }
}
