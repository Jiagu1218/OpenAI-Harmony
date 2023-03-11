import { CreateImageViewModel } from '../model/CreateImageViewModel';
@Preview
@Component
export default struct CreateImageView {
  private model:CreateImageViewModel = new CreateImageViewModel()
  @State msg:string = ''
  @State imageList:Array<string> = []
  createImageView(){
    this.model.createImage(this.msg).then(result=>{
      this.imageList = result
      this.msg = ''
    })
  }
  build() {
    Column() {
      if (this.imageList.length>0){
        Swiper() {
          ForEach(this.imageList, (item: string, index: number) => {
            Image(item).width("100%").height("100%")
          },(item:string) => item
          )
        }
        .width("100%")
        .height("50%")
      }
      Blank()
      Row() {
        TextArea({text:this.msg})
          .width("100%")
          .height("100%")
          .onChange(value => this.msg = value)
      }      
      .width("100%")
      .height("100vp")
      Row() {
        Button("提交")
          .width("80vp")
          .height("40vp")
          .onClick(()=>{
            this.createImageView()
          })
      }      
      .width("100%")
      .height("100vp")
      .justifyContent(FlexAlign.Center)
    }    
    .width("100%")
    .height("100%")
  }
}
